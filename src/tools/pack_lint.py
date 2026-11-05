# -*- coding: utf-8 -*-
"""
pack_lint —— 《梦回盘灵：镜中倒影》数据包/资源包静态校验

检查项：
  C1 资源包路径冲突     ：DLC 覆盖了本体已占用的 models/item/*.json、blockstates/*.json、models/block/*.json
  C2 数据包函数引用     ：mcfunction / tag json / advancement rewards 里引用的 plm:* 与 pld:* 函数是否存在
  C3 语言键完整性       ：zh_cn 有而 zh_tw 缺失的键（只告警）；代码里引用的 translate 键是否在语言包里
  C4 记分板声明         ：使用到的 mirror_* 目标是否在 load/const 里声明
  C5 CMD 段位冲突       ：同一载体物品的 custom_model_data 是否与本体占用冲突
  C6 括号/语法           ：mcfunction 行的花括号/方括号/引号平衡；JSON 可解析
  C7 边界纪律           ：tick 函数里是否存在未加区域闸门的 @e / @a 全量扫描
  C8 实体泄漏           ：summon 了带 tag 的实体，但没有对应的 kill/clear 函数

用法：
  python src/tools/pack_lint.py                 # 全量
  python src/tools/pack_lint.py --only C1,C6    # 指定项
  python src/tools/pack_lint.py --json          # 机器可读
"""
import argparse
import io
import json
import os
import re
import sys

sys.stdout.reconfigure(encoding='utf-8', errors='replace')

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))   # src/
PROJ = os.path.dirname(ROOT)                                        # 项目根
DP = os.path.join(ROOT, 'datapack')
RP = os.path.join(ROOT, 'resourcepack')
BASE_RP = os.path.join(PROJ, '梦回盘灵服务端', 'resourcepack', 'panling-1.20-resourcepack-1.1.0b.zip')
BASE_DP = os.path.join(PROJ, '梦回盘灵服务端', 'world', 'datapacks', 'panling-1.1.0b.zip')

# 本体已占用的资源路径前缀（实测，2026-11-02）
BASE_OWNED_EXACT = {
    # models/item（19 个）
    'assets/minecraft/models/item/blue_dye.json', 'assets/minecraft/models/item/bone_meal.json',
    'assets/minecraft/models/item/bow.json', 'assets/minecraft/models/item/brick.json',
    'assets/minecraft/models/item/carrot_on_a_stick.json', 'assets/minecraft/models/item/cookie.json',
    'assets/minecraft/models/item/crossbow.json', 'assets/minecraft/models/item/diamond_sword.json',
    'assets/minecraft/models/item/echo_shard.json', 'assets/minecraft/models/item/goods.json',
    'assets/minecraft/models/item/iron_axe.json', 'assets/minecraft/models/item/nether_brick.json',
    'assets/minecraft/models/item/orange_dye.json', 'assets/minecraft/models/item/stone_sword.json',
    'assets/minecraft/models/item/sugar.json', 'assets/minecraft/models/item/warped_fungus_on_a_stick.json',
    'assets/minecraft/models/item/wooden_axe.json', 'assets/minecraft/models/item/wooden_pickaxe.json',
    'assets/minecraft/models/item/wooden_sword.json',
}
# 本体已占用的 blockstates（20 个）
BASE_OWNED_BLOCKSTATES = {
    'acacia_log', 'bookshelf', 'cauldron', 'cobblestone', 'cyan_terracotta', 'dark_oak_log',
    'dark_prismarine', 'dirt', 'grass_block', 'green_stained_glass', 'hopper',
    'mossy_cobblestone_wall', 'orange_stained_glass', 'red_sandstone_slab', 'sand', 'shroomlight',
    'smooth_red_sandstone', 'smooth_sandstone', 'spruce_leaves', 'stone_brick',
}
# CMD 段位（设计稿 §2.1 / 美术规范 §1.3）
CMD_RESERVED = [(100, 105, '武器'), (200, 223, '防具'), (300, 320, '镜片'), (340, 360, '镜心'),
                (370, 379, '镜胚'), (380, 385, '镜缘'), (390, 391, '影尘砺镜砂'),
                (400, 403, '定影符'), (410, 410, '倒影核')]

# 合并补丁：源文件只放标记 + overrides，打包时由 build.py 读本体同名 JSON 合并
MERGE_MARKER = '__merge_with_base__'


class Report:
    def __init__(self):
        self.items = []

    def add(self, code, level, path, msg):
        self.items.append({'code': code, 'level': level, 'path': path, 'msg': msg})

    def err(self, code, path, msg):
        self.add(code, 'ERROR', path, msg)

    def warn(self, code, path, msg):
        self.add(code, 'WARN', path, msg)

    def ok(self, code, msg=''):
        self.add(code, 'OK', '', msg)

    def has_error(self):
        return any(i['level'] == 'ERROR' for i in self.items)


def walk_files(base, exts=None):
    out = []
    if not os.path.isdir(base):
        return out
    for dp, dn, fn in os.walk(base):
        for f in fn:
            if exts and not any(f.endswith(e) for e in exts):
                continue
            out.append(os.path.join(dp, f))
    return out


def rel_of(path, base):
    return os.path.relpath(path, base).replace(os.sep, '/')


# ---------- 资源包模型索引 ----------
_BASE_ITEM_CACHE = None


def load_json(path):
    with io.open(path, encoding='utf-8') as f:
        return json.load(f)


def base_item_models():
    """本体 RP 里所有 assets/minecraft/models/item/*.json → {rel: obj}"""
    global _BASE_ITEM_CACHE
    if _BASE_ITEM_CACHE is not None:
        return _BASE_ITEM_CACHE
    out = {}
    try:
        import zipfile
        with zipfile.ZipFile(BASE_RP) as z:
            for n in z.namelist():
                if not n.startswith('assets/minecraft/models/item/') or not n.endswith('.json'):
                    continue
                try:
                    out[n] = json.loads(z.read(n).decode('utf-8'))
                except Exception:
                    continue
    except Exception:
        pass
    _BASE_ITEM_CACHE = out
    return out


def src_item_models():
    """我们的 RP 里 assets/minecraft/models/item/*.json → {rel: obj}"""
    out = {}
    base = os.path.join(RP, 'assets', 'minecraft', 'models', 'item')
    for f in walk_files(base, ['.json']):
        rel = rel_of(f, RP)
        try:
            out[rel] = load_json(f)
        except Exception:
            continue
    return out


def merge_patch_objects():
    return {rel: o for rel, o in src_item_models().items()
            if isinstance(o, dict) and o.get(MERGE_MARKER) is True}


def effective_item_models():
    """本体打底 + 我们的覆盖；补丁按「本体 overrides + 我们 overrides」合并。"""
    base = base_item_models()
    src = src_item_models()
    out = dict(base)
    for rel, obj in src.items():
        if isinstance(obj, dict) and obj.get(MERGE_MARKER) is True:
            b = base.get(rel, {})
            merged = dict(b)
            merged['overrides'] = list(b.get('overrides', [])) + list(obj.get('overrides', []))
            out[rel] = merged
        else:
            out[rel] = obj
    return out


def carrier_of(rel):
    return 'minecraft:' + os.path.splitext(os.path.basename(rel))[0]


def override_index(models):
    """{(carrier, cmd): [(model, predicate), ...]}，跳过坏条目。"""
    idx = {}
    for rel, obj in models.items():
        if not isinstance(obj, dict):
            continue
        carrier = carrier_of(rel)
        for o in obj.get('overrides', []) or []:
            if not isinstance(o, dict):
                continue
            pred = o.get('predicate') or {}
            cmd = pred.get('custom_model_data')
            if isinstance(cmd, bool) or not isinstance(cmd, int):
                continue
            idx.setdefault((carrier, cmd), []).append((o.get('model'), pred))
    return idx


def source_override_index():
    """只看我们源文件里的 override（补丁只取我们那几条）。"""
    return override_index(src_item_models())


def available_model_ids():
    """本包 + 本体包里实际存在的模型 id 集合。"""
    ids = set()
    for f in walk_files(os.path.join(RP, 'assets'), ['.json']):
        rel = rel_of(f, os.path.join(RP, 'assets'))
        parts = rel.split('/')
        if len(parts) >= 3 and parts[1] == 'models':
            ids.add('%s:%s' % (parts[0], '/'.join(parts[2:])[:-len('.json')]))
    try:
        import zipfile
        with zipfile.ZipFile(BASE_RP) as z:
            for n in z.namelist():
                if not n.startswith('assets/') or '/models/' not in n or not n.endswith('.json'):
                    continue
                p = n[len('assets/'):-len('.json')]
                ns, rest = p.split('/', 1)
                rest = rest[len('models/'):]
                ids.add('%s:%s' % (ns, rest))
    except Exception:
        pass
    return ids


def norm_model(ref):
    ref = (ref or '').strip()
    return ref if ':' in ref else 'minecraft:' + ref


def pred_key(pred):
    return json.dumps(pred, sort_keys=True, separators=(',', ':'))


# ---------- C1 资源包路径冲突 ----------
def check_c1(r):
    rp_files = walk_files(RP)
    if not rp_files:
        r.ok('C1', '资源包目录为空，跳过')
        return
    patches = set(merge_patch_objects())
    conflicts = []
    for f in rp_files:
        rel = rel_of(f, RP)
        if rel in BASE_OWNED_EXACT and rel not in patches:
            conflicts.append(rel)
        m = re.match(r'assets/minecraft/blockstates/([a-z0-9_]+)\.json$', rel)
        if m and m.group(1) in BASE_OWNED_BLOCKSTATES:
            conflicts.append(rel)
    if conflicts:
        for c in conflicts:
            r.err('C1', c, '覆盖了本体已占用的路径（会静默破坏本体外观）')
    else:
        r.ok('C1', '资源包无路径冲突（%d 个文件，合并补丁 %d 个）' % (len(rp_files), len(patches)))


# ---------- C2 函数引用 ----------
def build_function_index():
    idx = set()
    if not os.path.isdir(DP):
        return idx
    for f in walk_files(DP, ['.mcfunction']):
        rel = rel_of(f, os.path.join(DP, 'data'))
        ns, rest = rel.split('/', 1)
        if rest.startswith('functions/'):
            rest = rest[len('functions/'):]
        idx.add('%s:%s' % (ns, rest[:-len('.mcfunction')]))
    return idx


def base_function_index():
    idx = set()
    try:
        import zipfile
        with zipfile.ZipFile(BASE_DP) as z:
            for n in z.namelist():
                if n.startswith('data/') and n.endswith('.mcfunction'):
                    rel = n[len('data/'):-len('.mcfunction')]
                    ns, rest = rel.split('/', 1)
                    if rest.startswith('functions/'):
                        rest = rest[len('functions/'):]
                    idx.add('%s:%s' % (ns, rest))
    except Exception:
        pass
    return idx


def check_c2(r):
    mine = build_function_index()
    base = base_function_index()
    refs = []
    for f in walk_files(DP, ['.mcfunction']):
        src = io.open(f, encoding='utf-8', errors='replace').read()
        for line in src.splitlines():
            code = line.split('#', 1)[0]      # 去掉注释，避免文档里的示例被误判
            if not code.strip():
                continue
            for m in re.finditer(r'\bfunction\s+(#?)([a-z0-9_]+:[a-z0-9_/.\-]+)', code):
                refs.append((rel_of(f, DP), m.group(2), bool(m.group(1))))
    for f in walk_files(DP, ['.json']):
        try:
            d = json.load(io.open(f, encoding='utf-8'))
        except Exception:
            continue
        def scan(obj):
            if isinstance(obj, dict):
                for k, v in obj.items():
                    if k == 'function' and isinstance(v, str):
                        refs.append((rel_of(f, DP), v, False))
                    else:
                        scan(v)
            elif isinstance(obj, list):
                for v in obj:
                    scan(v)
            elif isinstance(obj, str) and obj.startswith('plm:') and '/' in obj and 'function' in obj.lower():
                pass
        scan(d)
    missing = []
    for path, ref, is_tag in refs:
        if is_tag:
            continue
        if ref.startswith('plm:') and ref not in mine:
            missing.append((path, ref))
        elif ref.startswith('pld:') and ref not in base and ref not in mine:
            missing.append((path, ref))
    if missing:
        for p, ref in sorted(set(missing)):
            r.err('C2', p, '引用了不存在的函数 %s' % ref)
    r.ok('C2', '函数引用检查完成（%d 个函数，%d 处引用）' % (len(mine), len(refs)))


# ---------- C3 语言键 ----------
TRANS_RE = re.compile(r'"translate"\s*:\s*"([a-zA-Z0-9_.\-]+)"')


def load_lang(ns_dir):
    d = {}
    for f in walk_files(ns_dir, ['.json']):
        if '/lang/' not in f.replace(os.sep, '/'):
            continue
        try:
            d.update(json.load(io.open(f, encoding='utf-8')))
        except Exception:
            pass
    return d


def check_c3(r):
    lang_files = [f for f in walk_files(RP, ['.json']) if '/lang/' in f.replace(os.sep, '/')]
    if not lang_files:
        r.ok('C3', '资源包暂无语言文件，跳过')
        return
    zh_cn = {k: v for k, v in load_lang(RP).items()}
    zh_tw = {}
    for f in lang_files:
        if 'zh_tw' in f:
            try:
                zh_tw.update(json.load(io.open(f, encoding='utf-8')))
            except Exception:
                pass
    missing_tw = sorted(set(zh_cn) - set(zh_tw))
    if missing_tw:
        r.warn('C3', 'lang/zh_tw', '缺 %d 个键（繁中未完成，不影响运行）' % len(missing_tw))
    used = set()
    for f in walk_files(DP, ['.mcfunction']):
        used |= set(TRANS_RE.findall(io.open(f, encoding='utf-8', errors='replace').read()))
    for f in walk_files(DP, ['.json']):
        try:
            used |= set(TRANS_RE.findall(io.open(f, encoding='utf-8', errors='replace').read()))
        except Exception:
            pass
    used = {k for k in used if not k.startswith('pl.')}   # 本体键不检查
    missing = sorted(k for k in used if k not in zh_cn)
    if missing:
        for k in missing[:40]:
            r.err('C3', 'lang/zh_cn', '缺少 translate 键 %s' % k)
        if len(missing) > 40:
            r.err('C3', 'lang/zh_cn', '…另有 %d 个缺失键' % (len(missing) - 40))
    else:
        r.ok('C3', '语言键检查完成（%d 键，引用 %d 个）' % (len(zh_cn), len(used)))


# ---------- C4 记分板声明 ----------
OBJ_USE_RE = re.compile(r'\b(?:scoreboard players (?:set|add|remove|get|reset|enable|operation)|'
                        r'execute (?:if|unless) score|store (?:result|success) score)[^\n]*?\b'
                        r'([a-z_][a-z0-9_]*)\b')
OBJ_ADD_RE = re.compile(r'scoreboard objectives add ([a-z_][a-z0-9_]*)')
SB_PLAYERS_RE = re.compile(r'scoreboard players (?:set|add|remove|reset|get|enable)\s+\S+\s+([a-z_][a-z0-9_]*)')


def check_c4(r):
    declared, used = set(), set()
    for f in walk_files(DP, ['.mcfunction']):
        src = io.open(f, encoding='utf-8', errors='replace').read()
        declared |= set(OBJ_ADD_RE.findall(src))
        used |= set(SB_PLAYERS_RE.findall(src))
    mirror_used = {u for u in used if u.startswith('mirror_')}
    mirror_decl = {d for d in declared if d.startswith('mirror_')}
    missing = sorted(mirror_used - mirror_decl)
    if missing:
        for m in missing:
            r.err('C4', 'load/const', '记分板 mirror_* 未声明：%s' % m)
    else:
        r.ok('C4', '记分板声明完整（声明 %d，使用 %d）' % (len(mirror_decl), len(mirror_used)))


# ---------- C5 CMD 段位 ----------
CMD_RE = re.compile(r'CustomModelData:(\d+)')


def check_c5(r):
    seen = {}
    for f in walk_files(DP):
        if not f.endswith(('.mcfunction', '.json')):
            continue
        src = io.open(f, encoding='utf-8', errors='replace').read()
        for m in CMD_RE.finditer(src):
            v = int(m.group(1))
            seen.setdefault(v, set()).add(rel_of(f, DP))
    bad = []
    for v, files in seen.items():
        if not any(lo <= v <= hi for lo, hi, _ in CMD_RESERVED):
            bad.append((v, sorted(files)[0]))
    if bad:
        for v, f in sorted(bad)[:20]:
            r.warn('C5', f, 'CMD %d 不在预留段位'
                             '（100-105/200-223/300-320/340-360/370-379/'
                             '380-385/390-391/400-403/410）' % v)
    else:
        r.ok('C5', 'CMD 段位正常（%d 个不同值）' % len(seen))


# ---------- C6 语法 ----------
def bracket_ok(line):
    dc = ds = 0
    in_s = in_d = False
    for ch in line:
        if ch == "'" and not in_d:
            in_s = not in_s
            continue
        if ch == '"' and not in_s:
            in_d = not in_d
            continue
        if in_s or in_d:
            continue
        if ch == '{':
            dc += 1
        elif ch == '}':
            dc -= 1
        elif ch == '[':
            ds += 1
        elif ch == ']':
            ds -= 1
        if dc < 0 or ds < 0:
            return False
    return dc == 0 and ds == 0 and not in_s and not in_d


def check_c6(r):
    bad = 0
    for f in walk_files(DP, ['.mcfunction']):
        for i, line in enumerate(io.open(f, encoding='utf-8', errors='replace').read().splitlines(), 1):
            s = line.strip()
            if not s or s.startswith('#'):
                continue
            if not bracket_ok(s):
                bad += 1
                r.err('C6', '%s:%d' % (rel_of(f, DP), i), '括号/引号不平衡：%s' % s[:90])
    for f in walk_files(DP, ['.json']):
        try:
            json.load(io.open(f, encoding='utf-8'))
        except Exception as e:
            bad += 1
            r.err('C6', rel_of(f, DP), 'JSON 解析失败：%s' % e)
    if not bad:
        r.ok('C6', '语法检查通过')


# ---------- C7 tick 边界纪律 ----------
GATE_RE = re.compile(r'\b(?:if entity|unless entity)\s+@[ae]\[')
FULL_SCAN_RE = re.compile(r'@[ae]\[(?:[^\]]*)\]')


def check_c7(r):
    tick_dir = os.path.join(DP, 'data', 'plm', 'functions', 'tick')
    bad = 0
    for f in walk_files(tick_dir, ['.mcfunction']):
        for i, line in enumerate(io.open(f, encoding='utf-8', errors='replace').read().splitlines(), 1):
            s = line.strip()
            if not s or s.startswith('#'):
                continue
            if not FULL_SCAN_RE.search(s):
                continue
            if GATE_RE.search(s):
                continue
            bad += 1
            r.warn('C7', '%s:%d' % (rel_of(f, DP), i), 'tick 内存在未加区域闸门的实体/玩家扫描')
    if not bad:
        r.ok('C7', 'tick 边界纪律检查通过')


# ---------- C8 实体泄漏 ----------
SUMMON_RE = re.compile(r'summon\s+([a-z0-9_:]+)[^\n]*?Tags:\[([^\]]*)\]')


def check_c8(r):
    summoned, cleared = {}, set()
    for f in walk_files(DP, ['.mcfunction']):
        src = io.open(f, encoding='utf-8', errors='replace').read()
        for m in SUMMON_RE.finditer(src):
            for t in re.findall(r'"([a-z0-9_]+)"', m.group(2)):
                summoned.setdefault(t, set()).add(rel_of(f, DP))
        for m in re.finditer(r'kill\s+@e\[([^\]]*)\]', src):
            for t in re.findall(r'tag=([a-z0-9_]+)', m.group(1)):
                cleared.add(t)
    missing = {t: fs for t, fs in summoned.items() if t not in cleared}
    if missing:
        for t, fs in sorted(missing.items()):
            r.warn('C8', sorted(fs)[0], 'summon 的 tag=%s 没有对应的 kill @e[tag=%s]' % (t, t))
    else:
        r.ok('C8', '实体清理检查通过（%d 种 tag）' % len(summoned))




# ---------- C9 非法 score 比较 ----------
# 1.20.1 的 if score 只能与另一个记分板项比较，不能直接写字面量（1.20.5+ 才支持）。
BAD_CMP_RE = re.compile(r'\b(?:if|unless)\s+score\s+\S+\s+\S+\s*(?:[<>]=?)\s*-?\d')
# scoreboard players operation 的 int 字面量在 1.20.1 实际是「假玩家 N + objective int」，
# 只有本体建好的常量表才成立；不在表内的数值会静默算错或除零。
OPER_LITERAL_RE = re.compile(r'scoreboard\s+players\s+operation\s+\S+\s+\S+\s+[+\-*/%]=?\s+(-?\d+)\s+int\b')
SAFE_INT_CONST = {'1', '2', '4', '5', '10', '20', '100'}


def check_c9(r):
    bad = 0
    for f in walk_files(DP, ['.mcfunction']):
        for i, line in enumerate(io.open(f, encoding='utf-8', errors='replace').read().splitlines(), 1):
            code = line.split('#', 1)[0]
            if BAD_CMP_RE.search(code):
                bad += 1
                r.err('C9', '%s:%d' % (rel_of(f, DP), i),
                      '非法 score 比较（1.20.1 只能用 matches 或与记分板项比较）：%s' % code.strip()[:80])
            m = OPER_LITERAL_RE.search(code)
            if m and m.group(1) not in SAFE_INT_CONST:
                bad += 1
                r.err('C9', '%s:%d' % (rel_of(f, DP), i),
                      'operation 字面量 %s 不在本体的 int 常量表内（会算错/除零）：%s' % (m.group(1), code.strip()[:80]))
    if not bad:
        r.ok('C9', 'score 比较语法检查通过')

# ---------- C10 合并补丁完整性 ----------
def check_c10(r):
    patches = merge_patch_objects()
    if not patches:
        r.ok('C10', '没有合并补丁')
        return
    base = base_item_models()
    valid = available_model_ids()
    bad = 0
    for rel, obj in sorted(patches.items()):
        if rel not in base:
            r.err('C10', rel, '本体 RP 没有同名文件，补丁无法合并')
            bad += 1
            continue
        extra = set(obj) - {MERGE_MARKER, 'overrides'}
        if extra:
            r.err('C10', rel, '补丁只允许 %s/overrides，多出 %s' % (MERGE_MARKER, sorted(extra)))
            bad += 1
        ovs = obj.get('overrides')
        if not isinstance(ovs, list) or not ovs:
            r.err('C10', rel, '补丁缺少非空 overrides 数组')
            bad += 1
            continue

        # 构建期合并的硬约束：除 overrides 外全部字段必须来自本体，
        # 且本体 override 必须原样保留在前、我们的条目只追加。
        merged = effective_item_models().get(rel)
        if not isinstance(merged, dict):
            r.err('C10', rel, '无法构造构建期合并结果')
            bad += 1
        else:
            for field in ('parent', 'textures', 'display'):
                if merged.get(field) != base[rel].get(field):
                    r.err('C10', rel, '合并结果 %s 与本体不逐字段相同' % field)
                    bad += 1
            base_ovs = list(base[rel].get('overrides') or [])
            merged_ovs = list(merged.get('overrides') or [])
            if merged_ovs[:len(base_ovs)] != base_ovs:
                r.err('C10', rel, '合并结果未原样保留本体 %d 条 override 在前' % len(base_ovs))
                bad += 1
            if len(merged_ovs) != len(base_ovs) + len(ovs):
                r.err('C10', rel, '合并结果 override 总数 %d，期望 %d（本体 %d + 我们 %d）'
                      % (len(merged_ovs), len(base_ovs) + len(ovs), len(base_ovs), len(ovs)))
                bad += 1

        base_pred = {}
        for o in base[rel].get('overrides', []) or []:
            if isinstance(o, dict):
                base_pred[pred_key(o.get('predicate') or {})] = o.get('model')

        seen = {}
        for i, o in enumerate(ovs):
            where = '%s[%d]' % (rel, i)
            if not isinstance(o, dict):
                r.err('C10', where, 'override 不是对象')
                bad += 1
                continue
            pred = o.get('predicate')
            if not isinstance(pred, dict):
                r.err('C10', where, 'override 缺少 predicate 对象')
                bad += 1
                continue
            cmd = pred.get('custom_model_data')
            if isinstance(cmd, bool) or not isinstance(cmd, int):
                r.err('C10', where, 'predicate 缺少整数 custom_model_data')
                bad += 1
            model = o.get('model')
            if not isinstance(model, str) or not model:
                r.err('C10', where, 'override 缺少 model')
                bad += 1
                continue
            if norm_model(model) not in valid:
                r.err('C10', where, 'override 指向不存在的模型 %s' % model)
                bad += 1
            key = pred_key(pred)
            if key in seen and seen[key] != model:
                r.err('C10', where, '同一 predicate 指向不同模型（%s vs %s）' % (seen[key], model))
                bad += 1
            seen[key] = model
            if key in base_pred and base_pred[key] != model:
                r.err('C10', where, '与本体同 predicate 冲突（本体 %s，我们 %s）'
                      % (base_pred[key], model))
                bad += 1
    if not bad:
        r.ok('C10', '合并补丁完整（%d 个）' % len(patches))


# ---------- C11 载体—CMD 冲突 ----------
CMD_LINE_ID_RE = re.compile(r'id:"(minecraft:[a-z0-9_]+)"')
CMD_LINE_PANLING_RE = re.compile(r'id:"(panling:[a-z0-9_]+)"')
CMD_GIVE_RE = re.compile(r'\b(?:give|clear|replaceitem)\b[^\n]*?\b(minecraft:[a-z0-9_]+)')


def datapack_cmd_pairs():
    """解析数据包里的 (载体, CMD) → {逻辑 id}；返回 (pairs, 无法识别的行)。

    一行可能写多个物品（如 setblock 箱子），按 id:"minecraft:*" 出现位置切段，
    每段只取本物品自己的 CustomModelData 与 tag id。
    """
    pairs, unparsed = {}, []
    for f in walk_files(DP, ['.mcfunction', '.json']):
        for i, line in enumerate(io.open(f, encoding='utf-8', errors='replace').read().splitlines(), 1):
            # mcfunction 只有整行注释；不能按 '#' 截断（#t 是记分板假玩家）
            if line.strip().startswith('#'):
                continue
            code = line
            if 'CustomModelData' not in code:
                continue
            found = False
            marks = list(CMD_LINE_ID_RE.finditer(code))
            for j, m in enumerate(marks):
                start = m.start()
                end = marks[j + 1].start() if j + 1 < len(marks) else len(code)
                seg = code[start:end]
                cmds = [int(x.group(1)) for x in CMD_RE.finditer(seg)]
                if not cmds:
                    continue
                p = CMD_LINE_PANLING_RE.search(seg)
                logical = p.group(1) if p else ''
                for cmd in cmds:
                    pairs.setdefault((m.group(1), cmd), set()).add(logical)
                found = True
            if not found:
                g = CMD_GIVE_RE.search(code)
                if g:
                    cmds = [int(x.group(1)) for x in CMD_RE.finditer(code)]
                    p = CMD_LINE_PANLING_RE.search(code)
                    logical = p.group(1) if p else ''
                    for cmd in cmds:
                        pairs.setdefault((g.group(1), cmd), set()).add(logical)
                    found = True
            if not found:
                unparsed.append('%s:%d' % (rel_of(f, DP), i))
    return pairs, unparsed


def check_c11(r):
    pairs, unparsed = datapack_cmd_pairs()
    bad = 0
    for (carrier, cmd), ids in sorted(pairs.items()):
        real = {x for x in ids if x}
        if len(real) > 1:
            r.err('C11', carrier, '同一载体 CMD %d 被多个 id 使用：%s'
                  % (cmd, ', '.join(sorted(real))))
            bad += 1
    base_idx = override_index(base_item_models())
    src_idx = source_override_index()
    for carrier, cmd in sorted(pairs):
        key = (carrier, cmd)
        base_models = {m for m, _ in base_idx.get(key, [])}
        our_models = {m for m, _ in src_idx.get(key, [])}
        if base_models and our_models and (base_models - our_models):
            r.err('C11', carrier, 'CMD %d 已被本体指向 %s，我们又指向 %s'
                  % (cmd, ', '.join(sorted(str(x) for x in base_models)),
                     ', '.join(sorted(str(x) for x in our_models))))
            bad += 1
        elif base_models and not our_models:
            r.warn('C11', carrier, 'CMD %d 复用了本体已有的 override（本体模型 %s）'
                   % (cmd, ', '.join(sorted(str(x) for x in base_models))))
    for loc in unparsed[:10]:
        r.warn('C11', loc, '含 CustomModelData 但无法识别载体，已跳过')
    if not bad:
        r.ok('C11', '载体—CMD 无冲突（%d 个 载体×CMD）' % len(pairs))


# ---------- C12 CMD 悬挂 / 孤儿 ----------
def check_c12(r):
    pairs, _ = datapack_cmd_pairs()
    eff = override_index(effective_item_models())
    ours = source_override_index()
    src_rels = set(src_item_models())
    valid = available_model_ids()
    dangling = 0
    for carrier, cmd in sorted(pairs):
        key = (carrier, cmd)
        if key not in eff:
            rel = 'assets/minecraft/models/item/%s.json' % carrier.split(':', 1)[-1]
            if rel in src_rels:
                r.err('C12', carrier, 'CMD %d 没有对应 override（载体模型已在我们包内）' % cmd)
            else:
                r.warn('C12', carrier, 'CMD %d 没有对应 override（载体模型不在我们包内）' % cmd)
            dangling += 1
            continue
        for model, pred in eff[key]:
            if norm_model(model) not in valid:
                r.err('C12', carrier, 'CMD %d 指向不存在的模型 %s' % (cmd, model))
                dangling += 1
    orphan = 0
    for carrier, cmd in sorted(ours):
        if (carrier, cmd) not in pairs:
            r.warn('C12', carrier, 'CMD %d 的 override 无数据包使用（孤儿）' % cmd)
            orphan += 1
    if not dangling:
        r.ok('C12', 'CMD 无悬挂（%d 个 载体×CMD，孤儿 %d）' % (len(pairs), orphan))


# ---------- C13 弓弩状态齐全 ----------
STATE_EXPECT = {
    'minecraft:bow': [
        {},
        {'pulling': 1},
        {'pulling': 1, 'pull': 0.65},
        {'pulling': 1, 'pull': 0.9},
    ],
    'minecraft:crossbow': [
        {},
        {'pulling': 1},
        {'pulling': 1, 'pull': 0.58},
        {'pulling': 1, 'pull': 1.0},
        {'charged': 1},
        {'charged': 1, 'firework': 1},
    ],
}


def state_key(pred):
    return pred_key({k: v for k, v in pred.items() if k != 'custom_model_data'})


def check_c13(r):
    src = source_override_index()
    bad = 0
    for carrier, expected in STATE_EXPECT.items():
        cmds = sorted(cmd for (c, cmd) in src if c == carrier)
        if not cmds:
            r.err('C13', carrier, '没有任何 override')
            bad += 1
            continue
        want = {state_key(p) for p in expected}
        for cmd in cmds:
            actual_list = [p for _, p in src[(carrier, cmd)]]
            actual = {state_key(p) for p in actual_list}
            missing = want - actual
            extra = actual - want
            if len(actual_list) != len(expected) or missing or extra:
                r.err('C13', carrier,
                      'CMD %d 状态不齐：期望 %d 条，实际 %d 条；缺 %s；多 %s'
                      % (cmd, len(expected), len(actual_list),
                         sorted(missing) or '-', sorted(extra) or '-'))
                bad += 1
    if not bad:
        r.ok('C13', '弓弩状态齐全（bow %d 态 / crossbow %d 态）'
             % (len(STATE_EXPECT['minecraft:bow']), len(STATE_EXPECT['minecraft:crossbow'])))

CHECKS = [('C1', check_c1), ('C2', check_c2), ('C3', check_c3), ('C4', check_c4),
          ('C5', check_c5), ('C6', check_c6), ('C7', check_c7), ('C8', check_c8), ('C9', check_c9),
          ('C10', check_c10), ('C11', check_c11), ('C12', check_c12), ('C13', check_c13)]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--only', default='', help='逗号分隔的检查项，如 C1,C6')
    ap.add_argument('--json', action='store_true')
    args = ap.parse_args()
    want = {x.strip().upper() for x in args.only.split(',') if x.strip()}
    r = Report()
    for code, fn in CHECKS:
        if want and code not in want:
            continue
        try:
            fn(r)
        except Exception as e:
            r.err(code, '', '检查器异常：%s' % e)
    if args.json:
        print(json.dumps(r.items, ensure_ascii=False, indent=2))
    else:
        fails = [i for i in r.items if i['level'] == 'ERROR']
        warns = [i for i in r.items if i['level'] == 'WARN']
        oks = [i for i in r.items if i['level'] == 'OK']
        for i in fails:
            print('  [ERROR] %-3s %-40s %s' % (i['code'], i['path'][:40], i['msg']))
        for i in warns:
            print('  [WARN ] %-3s %-40s %s' % (i['code'], i['path'][:40], i['msg']))
        for i in oks:
            print('  [ OK  ] %-3s %s' % (i['code'], i['msg']))
        print('\n结果：%d error / %d warn / %d ok' % (len(fails), len(warns), len(oks)))
    sys.exit(1 if r.has_error() else 0)


if __name__ == '__main__':
    main()
