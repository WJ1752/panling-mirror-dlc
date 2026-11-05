# -*- coding: utf-8 -*-
"""
verify_assets —— 《梦回盘灵：镜中倒影》构建产物验收

检查 dist 里的两个 zip（不读 src 资源包）：

  1. 71 个图标模型：assets/panling/models/item/mirror_*.json 数量/内容/父模型/layer0
  2. 71 张贴图：assets/panling/textures/item/mirror_*.png 数量/64×64/RGBA
  3. CMD 覆盖：manifest 的 63 个 (载体, CMD) 全部落到产物 override；数据包无悬挂 CMD
  4. 本体前缀保留：17 个新建载体带原版 parent/layer0；bow/crossbow 的
     parent/textures/display 与本体逐字段相同，本体 overrides 原样在前、我们的在后
  5. 弓弩状态：bow 每个 CMD 4 态、crossbow 每个 CMD 6 态，谓词与本体一致
  6. 无孤儿：我们的每条 override 都指向产物里存在的模型，且都有数据包使用
  7. 无合并标记：产物任何 JSON 都不含 __merge_with_base__

任一失败 → 退出码 1。

用法：
  python -I src/tools/verify_assets.py --ver 1.0.0-alpha.16
  python -I src/tools/verify_assets.py            # 版本取 dist/manifest.json
"""
from __future__ import annotations

import argparse
import hashlib
import io
import json
import os
import re
import sys
import zipfile

from PIL import Image

sys.stdout.reconfigure(encoding='utf-8', errors='replace')

HERE = os.path.dirname(os.path.abspath(__file__))          # src/tools
SRC = os.path.dirname(HERE)                                # src
PROJ = os.path.dirname(SRC)                                # 项目根
DIST = os.path.join(PROJ, 'dist')
MANIFEST = os.path.join(HERE, 'art', 'manifest.json')
BASE_RP = os.path.join(PROJ, '梦回盘灵服务端', 'resourcepack',
                       'panling-1.20-resourcepack-1.1.0b.zip')

MERGE_MARKER = '__merge_with_base__'
TRIM_MANIFEST = os.path.join(HERE, 'art', 'trim_manifest.json')
ATLAS_PATH = 'assets/minecraft/atlases/armor_trims.json'
VANILLA_PALETTE_KEY = 'trims/color_palettes/trim_palette'
PLM_PALETTE_KEY = 'plm:trims/color_palettes/key'
TRIM_RE = re.compile(r'Trim:\{pattern:"([^"]+)",material:"([^"]+)"\}')
TRIM_SETS = ['zhao', 'lie', 'jing', 'can', 'twin', 'rub']
ARMOR_CARRIERS = {
    'minecraft:netherite_helmet', 'minecraft:netherite_chestplate',
    'minecraft:netherite_leggings', 'minecraft:netherite_boots',
}
# 1.20.1 客户端 jar 的 armor_trims.json（sha1 b2e64a67…）sources[0] 逐条抄录，
# 顺序与 jar 内一致；用来核对“原版 32 pattern / 14 permutation 原样保留”。
VANILLA_TRIM_PATTERN_NAMES = [
    'coast', 'sentry', 'dune', 'wild', 'ward', 'eye', 'vex', 'tide',
    'snout', 'rib', 'spire', 'wayfinder', 'shaper', 'silence', 'raiser', 'host',
]
VANILLA_TRIM_MATERIALS = [
    'quartz', 'iron', 'gold', 'diamond', 'netherite', 'redstone', 'copper',
    'emerald', 'lapis', 'amethyst', 'iron_darker', 'gold_darker',
    'diamond_darker', 'netherite_darker',
]
VANILLA_TRIM_TEXTURES = []
for _n in VANILLA_TRIM_PATTERN_NAMES:
    VANILLA_TRIM_TEXTURES.append('trims/models/armor/%s' % _n)
    VANILLA_TRIM_TEXTURES.append('trims/models/armor/%s_leggings' % _n)

# 原版物品模型骨架（与 gen_item_models.py 的契约）
VANILLA_CARRIERS = {
    'minecraft:netherite_sword': ('item/handheld', 'item/netherite_sword'),
    'minecraft:netherite_axe': ('item/handheld', 'item/netherite_axe'),
    'minecraft:netherite_hoe': ('item/handheld', 'item/netherite_hoe'),
    'minecraft:netherite_shovel': ('item/handheld', 'item/netherite_shovel'),
    'minecraft:netherite_helmet': ('item/generated', 'item/netherite_helmet'),
    'minecraft:netherite_chestplate': ('item/generated', 'item/netherite_chestplate'),
    'minecraft:netherite_leggings': ('item/generated', 'item/netherite_leggings'),
    'minecraft:netherite_boots': ('item/generated', 'item/netherite_boots'),
    'minecraft:netherite_scrap': ('item/generated', 'item/netherite_scrap'),
    'minecraft:amethyst_shard': ('item/generated', 'item/amethyst_shard'),
    'minecraft:flint': ('item/generated', 'item/flint'),
    'minecraft:charcoal': ('item/generated', 'item/charcoal'),
    'minecraft:quartz': ('item/generated', 'item/quartz'),
    'minecraft:gunpowder': ('item/generated', 'item/gunpowder'),
    'minecraft:glowstone_dust': ('item/generated', 'item/glowstone_dust'),
    'minecraft:paper': ('item/generated', 'item/paper'),
    'minecraft:nautilus_shell': ('item/generated', 'item/nautilus_shell'),
}

STATE_EXPECT = {
    'bow': {
        'static': {},
        'pulling_0': {'pulling': 1},
        'pulling_1': {'pulling': 1, 'pull': 0.65},
        'pulling_2': {'pulling': 1, 'pull': 0.9},
    },
    'crossbow': {
        'static': {},
        'pulling_0': {'pulling': 1},
        'pulling_1': {'pulling': 1, 'pull': 0.58},
        'pulling_2': {'pulling': 1, 'pull': 1.0},
        'arrow': {'charged': 1},
        'firework': {'charged': 1, 'firework': 1},
    },
}
STATE_ORDER = {
    'bow': ['static', 'pulling_0', 'pulling_1', 'pulling_2'],
    'crossbow': ['static', 'pulling_0', 'pulling_1', 'pulling_2', 'arrow', 'firework'],
}

CMD_RE = re.compile(r'CustomModelData:(\d+)')
ITEM_ID_RE = re.compile(r'id:"(minecraft:[a-z0-9_]+)"')
PANLING_ID_RE = re.compile(r'id:"(panling:[a-z0-9_]+)"')
GIVE_RE = re.compile(r'\b(?:give|clear|replaceitem)\b[^\n]*?\b(minecraft:[a-z0-9_]+)')


class Report:
    def __init__(self):
        self.fails = 0
        self.oks = 0

    def ok(self, name, msg=''):
        self.oks += 1
        print('  [ OK ] %-26s %s' % (name, msg))

    def err(self, name, msg):
        self.fails += 1
        print('  [FAIL] %-26s %s' % (name, msg))


def sha1_of(path):
    h = hashlib.sha1()
    with open(path, 'rb') as f:
        for chunk in iter(lambda: f.read(1 << 20), b''):
            h.update(chunk)
    return h.hexdigest()


def read_json_zip(z, name):
    try:
        return json.loads(z.read(name).decode('utf-8'))
    except KeyError:
        return None
    except Exception:
        return None


def icon_parent(entry):
    b = entry.get('builder')
    if b == 'bow':
        return 'item/bow'
    if b == 'crossbow':
        return 'item/crossbow'
    if b in ('sword', 'axe', 'twin_furnace', 'rub_furnace'):
        return 'item/handheld'
    return 'item/generated'


def expected_override(entry):
    b = entry.get('builder')
    if b in STATE_EXPECT:
        pred = dict(STATE_EXPECT[b][entry.get('state', 'static')])
    else:
        pred = {}
    pred['custom_model_data'] = entry['cmd']
    return {'predicate': pred, 'model': entry['model']}


def expected_overrides(entries):
    b = entries[0].get('builder')
    if b in STATE_EXPECT:
        by_state = {e.get('state', 'static'): e for e in entries}
        return [expected_override(by_state[s]) for s in STATE_ORDER[b]]
    return [expected_override(e) for e in sorted(entries, key=lambda x: (x['cmd'], x['key']))]


def carrier_groups(m):
    groups = {}
    for e in m['entries']:
        groups.setdefault(e['carrier'], []).append(e)
    return groups


def segment_items(code):
    """把一行拆成物品段：每个 id:"minecraft:*" 到下一个之间为一段。"""
    marks = list(ITEM_ID_RE.finditer(code))
    if marks:
        for j, m in enumerate(marks):
            end = marks[j + 1].start() if j + 1 < len(marks) else len(code)
            yield m.group(1), code[m.start():end]
        return
    g = GIVE_RE.search(code)
    if g:
        yield g.group(1), code


def datapack_cmd_pairs(dp_zip):
    pairs = {}
    for name in dp_zip.namelist():
        if not name.endswith(('.mcfunction', '.json')):
            continue
        text = dp_zip.read(name).decode('utf-8', 'replace')
        for line in text.splitlines():
            if line.strip().startswith('#'):
                continue
            if 'CustomModelData' not in line:
                continue
            for carrier, seg in segment_items(line):
                cmds = [int(x.group(1)) for x in CMD_RE.finditer(seg)]
                if not cmds:
                    continue
                p = PANLING_ID_RE.search(seg)
                logical = p.group(1) if p else ''
                for cmd in cmds:
                    pairs.setdefault((carrier, cmd), set()).add(logical)
    return pairs


def texture_file(loc):
    """资源位置 → 包内 PNG 路径（无命名空间时按 minecraft 处理）。"""
    loc = (loc or '').strip()
    if ':' not in loc:
        loc = 'minecraft:' + loc
    ns, path = loc.split(':', 1)
    return 'assets/%s/textures/%s.png' % (ns, path)


def scan_armor_items(text):
    """扫一段 mcfunction，返回 ({(载体, CMD): [(pattern, material), ...]}, [无 Trim 的 (载体, CMD)])。"""
    found, bare = {}, []
    for line in text.splitlines():
        s = line.strip()
        if not s or s.startswith('#'):
            continue
        for carrier, seg in segment_items(line):
            if carrier not in ARMOR_CARRIERS:
                continue
            cmds = [int(x.group(1)) for x in CMD_RE.finditer(seg)]
            if not cmds:
                continue
            hit = TRIM_RE.search(seg)
            for cmd in cmds:
                if hit:
                    found.setdefault((carrier, cmd), []).append(hit.groups())
                else:
                    bare.append((carrier, cmd))
    return found, bare


def read_text_zip(z, name):
    try:
        return z.read(name).decode('utf-8', 'replace')
    except KeyError:
        return None


def pred_without_cmd(pred):
    return {k: v for k, v in (pred or {}).items() if k != 'custom_model_data'}


def pred_key(pred):
    return json.dumps(pred, sort_keys=True, separators=(',', ':'))


def norm_model(ref):
    ref = (ref or '').strip()
    return ref if ':' in ref else 'minecraft:' + ref


def main():
    ap = argparse.ArgumentParser(description='验收镜中倒影构建产物')
    ap.add_argument('--ver', default='', help='版本号，如 1.0.0-alpha.16')
    args = ap.parse_args()

    ver = args.ver
    dist_manifest_path = os.path.join(DIST, 'manifest.json')
    if not ver:
        try:
            ver = json.load(io.open(dist_manifest_path, encoding='utf-8'))['version']
        except Exception:
            print('✗ 未指定 --ver，且读不到 dist/manifest.json')
            return 2

    rp_path = os.path.join(DIST, 'panling-mirror-resourcepack-%s.zip' % ver)
    dp_path = os.path.join(DIST, 'panling-mirror-%s.zip' % ver)
    print('验收版本：%s' % ver)
    print('  RP: %s' % rp_path)
    print('  DP: %s' % dp_path)

    for p in (rp_path, dp_path, BASE_RP):
        if not os.path.exists(p):
            print('✗ 缺少文件：%s' % p)
            return 2

    with io.open(MANIFEST, encoding='utf-8') as f:
        m = json.load(f)
    with io.open(TRIM_MANIFEST, encoding='utf-8') as f:
        trim_manifest = json.load(f)
    entries = m['entries']
    groups = carrier_groups(m)
    want_armor = {(e['carrier'], e['cmd']): e['set'] for e in entries if e['kind'] == 'armor'}

    report = Report()
    with zipfile.ZipFile(rp_path) as z, zipfile.ZipFile(dp_path) as dpz, \
            zipfile.ZipFile(BASE_RP) as base:
        names = set(z.namelist())
        base_names = set(base.namelist())

        # ---------- 1) 71 个图标模型 ----------
        want_models = {e['model_path'] for e in entries}
        got_models = {n for n in names
                      if n.startswith('assets/panling/models/item/mirror_') and n.endswith('.json')}
        bad = []
        if want_models - got_models:
            bad.append('缺少 %s' % sorted(want_models - got_models)[:5])
        if got_models - want_models:
            bad.append('多出 %s' % sorted(got_models - want_models)[:5])
        for e in entries:
            d = read_json_zip(z, e['model_path'])
            if not isinstance(d, dict):
                bad.append('%s 无法解析' % e['model_path'])
                continue
            if d.get('parent') != icon_parent(e):
                bad.append('%s parent=%r，期望 %r' % (e['key'], d.get('parent'), icon_parent(e)))
            if (d.get('textures') or {}).get('layer0') != 'panling:item/%s' % e['key']:
                bad.append('%s layer0=%r' % (e['key'], (d.get('textures') or {}).get('layer0')))
            if 'overrides' in d or 'display' in d:
                bad.append('%s 图标模型不应写 overrides/display' % e['key'])
        if bad:
            report.err('71 个图标模型', '%d 处问题：%s' % (len(bad), '；'.join(bad[:5])))
        else:
            report.ok('71 个图标模型', '%d 个，parent/layer0 正确' % len(entries))

        # ---------- 2) 71 张贴图 / 64×64 / RGBA ----------
        want_tex = {e['texture'] for e in entries}
        got_tex = {n for n in names
                   if n.startswith('assets/panling/textures/item/mirror_') and n.endswith('.png')}
        bad = []
        if want_tex - got_tex:
            bad.append('缺少 %s' % sorted(want_tex - got_tex)[:5])
        if got_tex - want_tex:
            bad.append('多出 %s' % sorted(got_tex - want_tex)[:5])
        for e in entries:
            path = e['texture']
            if path not in names:
                continue
            try:
                im = Image.open(io.BytesIO(z.read(path)))
                im.load()
            except Exception as exc:
                bad.append('%s 打开失败：%s' % (e['key'], exc))
                continue
            if im.size != (64, 64):
                bad.append('%s 尺寸 %s' % (e['key'], im.size))
            if im.mode != 'RGBA':
                bad.append('%s 模式 %s' % (e['key'], im.mode))
        if bad:
            report.err('71 张贴图', '%d 处问题：%s' % (len(bad), '；'.join(bad[:5])))
        else:
            report.ok('71 张贴图', '64×64 RGBA，全部到位')

        # ---------- 建立产物里的 (载体, CMD) 索引 ----------
        idx = {}
        carrier_models = {}
        for carrier, items in groups.items():
            rel = items[0]['carrier_model']
            d = read_json_zip(z, rel)
            carrier_models[carrier] = d
            if not isinstance(d, dict):
                continue
            for o in d.get('overrides', []) or []:
                if not isinstance(o, dict):
                    continue
                pred = o.get('predicate') or {}
                cmd = pred.get('custom_model_data')
                if isinstance(cmd, bool) or not isinstance(cmd, int):
                    continue
                idx.setdefault((carrier, cmd), []).append((o.get('model'), pred))

        # 数据包实际用到的 (载体, CMD)
        dp_pairs = datapack_cmd_pairs(dpz)

        # ---------- 3) CMD 覆盖 ----------
        manifest_pairs = {(e['carrier'], e['cmd']) for e in entries}
        bad = []
        missing_in_rp = sorted(manifest_pairs - set(idx))
        if missing_in_rp:
            bad.append('产物无 override：%s' % missing_in_rp[:8])
        missing_in_dp = sorted(manifest_pairs - set(dp_pairs))
        if missing_in_dp:
            bad.append('数据包未使用：%s' % missing_in_dp[:8])
        dangling = sorted(set(dp_pairs) - set(idx))
        if dangling:
            bad.append('数据包 CMD 无 override：%s' % dangling[:8])
        for e in entries:
            key = (e['carrier'], e['cmd'])
            hit = [x for x in idx.get(key, [])
                   if norm_model(x[0]) == norm_model(e['model'])
                   and pred_without_cmd(x[1]) == pred_without_cmd(expected_override(e)['predicate'])]
            if not hit:
                bad.append('%s（%s CMD %d）没有命中' % (e['key'], e['carrier'], e['cmd']))
        if bad:
            report.err('CMD 覆盖', '%d 处问题：%s' % (len(bad), '；'.join(bad[:5])))
        else:
            report.ok('CMD 覆盖', '%d 个 载体×CMD，RP/DP 双向一致' % len(manifest_pairs))

        # ---------- 4) 本体前缀保留 ----------
        bad = []
        for carrier, items in groups.items():
            rel = items[0]['carrier_model']
            dist_obj = carrier_models.get(carrier)
            if not isinstance(dist_obj, dict):
                bad.append('%s 载体模型缺失' % carrier)
                continue
            want_ovs = expected_overrides(items)
            builder = items[0].get('builder')
            if builder in STATE_EXPECT:
                base_obj = read_json_zip(base, rel)
                if not isinstance(base_obj, dict):
                    bad.append('%s 本体无同名模型' % rel)
                    continue
                for k in ('parent', 'textures', 'display'):
                    if dist_obj.get(k) != base_obj.get(k):
                        bad.append('%s 的 %s 与本体不一致' % (rel, k))
                base_ovs = base_obj.get('overrides', []) or []
                dist_ovs = dist_obj.get('overrides', []) or []
                if dist_ovs[:len(base_ovs)] != base_ovs:
                    bad.append('%s 本体 %d 条 override 未原样保留在前' % (rel, len(base_ovs)))
                if dist_ovs[len(base_ovs):] != want_ovs:
                    bad.append('%s 我们的 override 不在本体条目之后' % rel)
                if len(dist_ovs) != len(base_ovs) + len(want_ovs):
                    bad.append('%s override 总数 %d，期望 %d'
                               % (rel, len(dist_ovs), len(base_ovs) + len(want_ovs)))
            else:
                if rel in base_names:
                    bad.append('%s 本体已有同名文件，新建会顶掉本体' % rel)
                parent, layer0 = VANILLA_CARRIERS.get(carrier, (None, None))
                if parent is None:
                    bad.append('%s 没有原版骨架定义' % carrier)
                    continue
                if dist_obj.get('parent') != parent:
                    bad.append('%s parent=%r，期望 %r' % (rel, dist_obj.get('parent'), parent))
                if (dist_obj.get('textures') or {}).get('layer0') != layer0:
                    bad.append('%s layer0=%r，期望 %r'
                               % (rel, (dist_obj.get('textures') or {}).get('layer0'), layer0))
                if dist_obj.get('overrides') != want_ovs:
                    bad.append('%s override 列表与 manifest 不一致' % rel)
        if bad:
            report.err('本体前缀保留', '%d 处问题：%s' % (len(bad), '；'.join(bad[:5])))
        else:
            report.ok('本体前缀保留', '17 个原版骨架 + 2 个合并文件')

        # ---------- 5) 弓弩状态 ----------
        bad = []
        for carrier, builder in (('minecraft:bow', 'bow'), ('minecraft:crossbow', 'crossbow')):
            items = groups.get(carrier, [])
            cmds = sorted({e['cmd'] for e in items})
            want = [pred_key(STATE_EXPECT[builder][s]) for s in STATE_ORDER[builder]]
            for cmd in cmds:
                got = idx.get((carrier, cmd), [])
                got_keys = [pred_key(pred_without_cmd(p)) for _, p in got]
                if sorted(got_keys) != sorted(want):
                    bad.append('%s CMD %d 谓词不齐：%s' % (carrier, cmd, got_keys))
                models = {norm_model(model) for model, _ in got}
                want_models = {e['model'] for e in items if e['cmd'] == cmd}
                if models != want_models:
                    bad.append('%s CMD %d 模型不齐' % (carrier, cmd))
        if bad:
            report.err('弓弩状态', '%d 处问题：%s' % (len(bad), '；'.join(bad[:5])))
        else:
            report.ok('弓弩状态', 'bow 4 态 / crossbow 6 态，谓词与本体一致')

        # ---------- 6) 无孤儿 ----------
        model_ids = set()
        for n in names:
            if n.startswith('assets/') and '/models/' in n and n.endswith('.json'):
                p = n[len('assets/'):-len('.json')]
                ns, rest = p.split('/', 1)
                model_ids.add('%s:%s' % (ns, rest[len('models/'):]))
        bad = []
        for carrier, items in groups.items():
            d = carrier_models.get(carrier)
            if not isinstance(d, dict):
                continue
            for o in d.get('overrides', []) or []:
                model = norm_model((o or {}).get('model'))
                # 只审查我们自己的 mirror_* 条目；本体前缀（item/bow_* 等）不在此列
                if not model.startswith('panling:item/mirror_'):
                    continue
                if model not in model_ids:
                    bad.append('%s 指向不存在的模型 %s' % (carrier, model))
                cmd = ((o or {}).get('predicate') or {}).get('custom_model_data')
                if (carrier, cmd) not in dp_pairs:
                    bad.append('%s CMD %s 无数据包使用' % (carrier, cmd))
        if bad:
            report.err('无孤儿', '%d 处问题：%s' % (len(bad), '；'.join(bad[:5])))
        else:
            report.ok('无孤儿', 'override 模型存在且全部有数据包使用')

        # ---------- 7) 无合并标记 ----------
        marked = []
        for n in names:
            if not n.endswith('.json'):
                continue
            if MERGE_MARKER.encode('utf-8') in z.read(n):
                marked.append(n)
        for n in dpz.namelist():
            if not n.endswith('.json'):
                continue
            if MERGE_MARKER.encode('utf-8') in dpz.read(n):
                marked.append('dp:' + n)
        if marked:
            report.err('无合并标记', '%d 个文件残留标记：%s' % (len(marked), marked[:5]))
        else:
            report.ok('无合并标记', 'RP/DP 产物 JSON 均不含 %s' % MERGE_MARKER)

        # ---------- 8) 共用底纹 128×64 ----------
        bad = []
        for layer in (1, 2):
            p = 'assets/minecraft/textures/models/armor/netherite_layer_%d.png' % layer
            if p not in names:
                bad.append('缺少 %s' % p)
                continue
            try:
                im = Image.open(io.BytesIO(z.read(p)))
                im.load()
            except Exception as exc:
                bad.append('%s 打开失败：%s' % (p, exc))
                continue
            if im.size != (128, 64):
                bad.append('%s 尺寸 %s' % (p, im.size))
            if im.mode != 'RGBA':
                bad.append('%s 模式 %s' % (p, im.mode))
        if bad:
            report.err('底纹 128×64', '；'.join(bad[:5]))
        else:
            report.ok('底纹 128×64', 'netherite_layer_1/2 均为 128×64 RGBA')

        # ---------- 9) 12 张纹饰 64×32 ----------
        want_trim = set()
        for s in TRIM_SETS:
            want_trim.add('assets/plm/textures/trims/models/armor/%s.png' % s)
            want_trim.add('assets/plm/textures/trims/models/armor/%s_leggings.png' % s)
        got_trim = {n for n in names
                    if n.startswith('assets/plm/textures/trims/models/armor/') and n.endswith('.png')}
        bad = []
        if want_trim - got_trim:
            bad.append('缺少 %s' % sorted(want_trim - got_trim)[:5])
        if got_trim - want_trim:
            bad.append('多出 %s' % sorted(got_trim - want_trim)[:5])
        for p in sorted(want_trim):
            if p not in names:
                continue
            try:
                im = Image.open(io.BytesIO(z.read(p)))
                im.load()
            except Exception as exc:
                bad.append('%s 打开失败：%s' % (p, exc))
                continue
            if im.size != (64, 32):
                bad.append('%s 尺寸 %s' % (p, im.size))
            if im.mode != 'RGBA':
                bad.append('%s 模式 %s' % (p, im.mode))
        if bad:
            report.err('12 张纹饰', '；'.join(bad[:5]))
        else:
            report.ok('12 张纹饰', '6 套 × 2 层，64×32 RGBA')

        # ---------- 10) 6 个 palette + key + 原版 trim_palette ----------
        bad = []
        palette_paths = ['assets/plm/textures/trims/color_palettes/%s.png' % s
                         for s in TRIM_SETS + ['key']]
        palette_paths.append('assets/minecraft/textures/trims/color_palettes/trim_palette.png')
        for p in palette_paths:
            if p not in names:
                bad.append('缺少 %s' % p)
                continue
            try:
                im = Image.open(io.BytesIO(z.read(p)))
                im.load()
            except Exception as exc:
                bad.append('%s 打开失败：%s' % (p, exc))
                continue
            if im.size != (8, 1):
                bad.append('%s 尺寸 %s' % (p, im.size))
            if im.mode not in ('RGB', 'RGBA'):
                bad.append('%s 模式 %s' % (p, im.mode))
        if bad:
            report.err('6 个 palette', '；'.join(bad[:5]))
        else:
            report.ok('6 个 palette', '6 张强调色 + plm key + 原版 trim_palette，均 8×1')

        # ---------- 11) armor_trims 图集：原版 source + plm 独立 source ----------
        atlas = read_json_zip(z, ATLAS_PATH)
        bad = []
        if not isinstance(atlas, dict) or not isinstance(atlas.get('sources'), list):
            bad.append('%s 缺失或无法解析' % ATLAS_PATH)
        else:
            sources = atlas['sources']
            if len(sources) != 2:
                bad.append('sources=%d，期望 2（原版 + plm 各一）' % len(sources))
            vs = sources[0] if len(sources) > 0 else {}
            ps = sources[1] if len(sources) > 1 else {}
            if vs.get('type') != 'paletted_permutations':
                bad.append('source0 type=%r' % vs.get('type'))
            if vs.get('palette_key') != VANILLA_PALETTE_KEY:
                bad.append('source0 palette_key=%r' % vs.get('palette_key'))
            if list(vs.get('textures') or []) != VANILLA_TRIM_TEXTURES:
                bad.append('原版 32 条 pattern 未按原序保留')
            vperms = vs.get('permutations') or {}
            for name in VANILLA_TRIM_MATERIALS:
                if vperms.get(name) != 'trims/color_palettes/%s' % name:
                    bad.append('原版 permutation %s=%r' % (name, vperms.get(name)))
            if ps.get('type') != 'paletted_permutations':
                bad.append('source1 type=%r' % ps.get('type'))
            if ps.get('palette_key') != PLM_PALETTE_KEY:
                bad.append('source1 palette_key=%r，期望 %r'
                           % (ps.get('palette_key'), PLM_PALETTE_KEY))
            ptex = list(ps.get('textures') or [])
            pperms = ps.get('permutations') or {}
            for st in TRIM_SETS:
                for t in ('plm:trims/models/armor/%s' % st,
                          'plm:trims/models/armor/%s_leggings' % st):
                    if t not in ptex:
                        bad.append('缺 plm 纹理 %s' % t)
                if pperms.get(st) != 'plm:trims/color_palettes/%s' % st:
                    bad.append('plm permutation %s=%r' % (st, pperms.get(st)))
            for loc in list(ptex) + [pperms.get(st) for st in TRIM_SETS] + [PLM_PALETTE_KEY]:
                f = texture_file(loc)
                if f not in names:
                    bad.append('图集引用的纹理不存在：%s' % f)
        if bad:
            report.err('armor_trims 图集', '；'.join(bad[:5]))
        else:
            report.ok('armor_trims 图集', '原版 source 原样 + plm source 12/6，双 key')

        # ---------- 12) trim_pattern / trim_material 注册 ----------
        bad = []
        if list(trim_manifest.get('sets', {})) != TRIM_SETS:
            bad.append('trim_manifest.sets 顺序/数量不符：%r' % list(trim_manifest.get('sets', {})))
        want_files = {'data/plm/trim_pattern/%s.json' % s for s in TRIM_SETS}
        want_files |= {'data/plm/trim_material/%s.json' % s for s in TRIM_SETS}
        got_files = {n for n in dpz.namelist()
                     if n.startswith(('data/plm/trim_pattern/', 'data/plm/trim_material/'))
                     and n.endswith('.json')}
        if got_files != want_files:
            bad.append('文件集不符：缺 %s，多 %s'
                       % (sorted(want_files - got_files)[:4], sorted(got_files - want_files)[:4]))
        for i, s in enumerate(TRIM_SETS):
            rel = 'data/plm/trim_pattern/%s.json' % s
            d = read_json_zip(dpz, rel)
            if not isinstance(d, dict):
                bad.append('%s 缺失/坏' % rel)
            else:
                if d.get('asset_id') != 'plm:%s' % s:
                    bad.append('%s asset_id=%r' % (rel, d.get('asset_id')))
                if (d.get('description') or {}).get('translate') != 'trim_pattern.plm.%s' % s:
                    bad.append('%s description=%r' % (rel, d.get('description')))
                if d.get('template_item') != 'minecraft:air':
                    bad.append('%s template_item=%r' % (rel, d.get('template_item')))
            rel = 'data/plm/trim_material/%s.json' % s
            d = read_json_zip(dpz, rel)
            if not isinstance(d, dict):
                bad.append('%s 缺失/坏' % rel)
                continue
            desc = d.get('description') or {}
            if d.get('asset_name') != s:
                bad.append('%s asset_name=%r' % (rel, d.get('asset_name')))
            if desc.get('translate') != 'trim_material.plm.%s' % s:
                bad.append('%s description=%r' % (rel, desc))
            color = desc.get('color')
            if not (isinstance(color, str) and color.startswith('#') and len(color) == 7):
                bad.append('%s color=%r' % (rel, color))
            if d.get('ingredient') != 'minecraft:quartz':
                bad.append('%s ingredient=%r' % (rel, d.get('ingredient')))
            want_idx = round(0.1 * (i + 1), 1)
            if d.get('item_model_index') != want_idx:
                bad.append('%s item_model_index=%r，期望 %r'
                           % (rel, d.get('item_model_index'), want_idx))
        if bad:
            report.err('trim 注册 JSON', '；'.join(bad[:5]))
        else:
            report.ok('trim 注册 JSON', '6 pattern + 6 material，asset_id/描述/材料/序号正确')

        # ---------- 13) 24 件防具 Trim NBT ----------
        armor_fn = 'data/plm/functions/mirror/table/output/armor.mcfunction'
        text = read_text_zip(dpz, armor_fn)
        bad = []
        if text is None:
            bad.append('缺 %s' % armor_fn)
        else:
            got, bare = scan_armor_items(text)
            total = sum(len(v) for v in got.values())
            if len(want_armor) != 24:
                bad.append('manifest 防具 %d 件，期望 24' % len(want_armor))
            if bare:
                bad.append('无 Trim：%s' % bare[:6])
            if set(got) != set(want_armor):
                bad.append('缺 %s；多 %s'
                           % (sorted(set(want_armor) - set(got))[:4],
                              sorted(set(got) - set(want_armor))[:4]))
            if total != 24:
                bad.append('Trim 条目 %d 条，期望 24' % total)
            for key, st in sorted(want_armor.items()):
                for pat, mat in got.get(key, []):
                    if (pat, mat) != ('plm:%s' % st, 'plm:%s' % st):
                        bad.append('%s CMD %d 的 Trim=%s/%s，期望 plm:%s'
                                   % (key[0], key[1], pat, mat, st))
        if bad:
            report.err('24 件 Trim NBT', '；'.join(bad[:5]))
        else:
            report.ok('24 件 Trim NBT', '6 套 × 4 部位，pattern=material=plm:<set>')

        # ---------- 14) gallery / 发放函数带 Trim ----------
        bad = []
        checks = [
            ('data/plm/functions/dev/build_gallery.mcfunction', '展馆'),
            ('data/plm/functions/dev/give_all.mcfunction', 'give_all'),
            ('data/plm/functions/dev/give_test_set.mcfunction', 'give_test_set'),
            ('data/plm/functions/dev/give_test_gear.mcfunction', 'give_test_gear'),
        ]
        for rel, tag in checks:
            text = read_text_zip(dpz, rel)
            if text is None:
                bad.append('缺 %s' % rel)
                continue
            got, bare = scan_armor_items(text)
            if bare:
                bad.append('%s 有 %d 件防具无 Trim：%s' % (tag, len(bare), bare[:3]))
            if tag == '展馆':
                # 当前布局：每套 4 物品框 + 4 领取箱 + 4 盔甲架 = 12 次
                per = {}
                for vals in got.values():
                    for pat, _mat in vals:
                        per[pat] = per.get(pat, 0) + 1
                want_per = {'plm:%s' % s: 12 for s in TRIM_SETS}
                if per != want_per:
                    bad.append('展馆各套 Trim 次数 %r，期望 %r' % (per, want_per))
                for key, st in want_armor.items():
                    for pat, mat in got.get(key, []):
                        if (pat, mat) != ('plm:%s' % st, 'plm:%s' % st):
                            bad.append('展馆 %s CMD %d Trim=%s/%s'
                                       % (key[0], key[1], pat, mat))
            elif tag == 'give_all':
                if set(got) != set(want_armor):
                    bad.append('give_all 防具与 manifest 不一致')
                if sum(len(v) for v in got.values()) != 24:
                    bad.append('give_all Trim %d 条，期望 24'
                               % sum(len(v) for v in got.values()))
            else:
                want = 4 if tag == 'give_test_set' else 1
                if sum(len(v) for v in got.values()) != want:
                    bad.append('%s Trim %d 条，期望 %d'
                               % (tag, sum(len(v) for v in got.values()), want))
                for vals in got.values():
                    for pat, mat in vals:
                        if (pat, mat) != ('plm:zhao', 'plm:zhao'):
                            bad.append('%s 发的是 %s/%s，期望 plm:zhao' % (tag, pat, mat))
        if bad:
            report.err('gallery/test Trim', '；'.join(bad[:5]))
        else:
            report.ok('gallery/test Trim', '展馆 72 条 / give_all 24 条 / 测试函数 5 条')

        # ---------- 15) 语言键 ----------
        lang = read_json_zip(z, 'assets/lang_mirror/lang/zh_cn.json')
        bad = []
        if not isinstance(lang, dict):
            bad.append('缺 assets/lang_mirror/lang/zh_cn.json')
        else:
            for k, v in trim_manifest['lang'].items():
                if lang.get(k) != v:
                    bad.append('%s=%r，期望 %r' % (k, lang.get(k), v))
        if bad:
            report.err('trim 语言键', '；'.join(bad[:5]))
        else:
            report.ok('trim 语言键', '12 条 trim_pattern/trim_material 中文键齐全')

    # ---------- 16) dist/manifest.json 的本体记录 ----------
    try:
        dm = json.load(io.open(dist_manifest_path, encoding='utf-8'))
    except Exception:
        dm = None
    if not isinstance(dm, dict):
        report.err('dist/manifest', '读不到 dist/manifest.json')
    else:
        bad = []
        if dm.get('version') != ver:
            bad.append('version=%r，期望 %r' % (dm.get('version'), ver))
        br = dm.get('base_resourcepack') or {}
        if br.get('file') != os.path.basename(BASE_RP):
            bad.append('base_resourcepack.file=%r' % br.get('file'))
        if br.get('sha1') != sha1_of(BASE_RP):
            bad.append('base_resourcepack.sha1 与本体文件不符')
        if bad:
            report.err('dist/manifest', '；'.join(bad))
        else:
            report.ok('dist/manifest', '版本与本体 RP 文件名/sha1 已记录')

    print('\n结果：%d fail / %d ok' % (report.fails, report.oks))
    return 1 if report.fails else 0


if __name__ == '__main__':
    raise SystemExit(main())
