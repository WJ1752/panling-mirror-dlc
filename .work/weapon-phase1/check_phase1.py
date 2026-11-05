# -*- coding: utf-8 -*-
"""
Phase 1 静态检查
================
运行：
  python -I E:/梦回盘灵DLC开发/.work/weapon-phase1/check_phase1.py

检查项（全部在本次运行内执行）：
  1. 所有 JSON 可解析（src/datapack/data + pack.mcmeta）
  2. 不存在 data/pld/functions/**（不覆盖本体 body）；data/pld 下只允许 tags/functions、tags/items
  3. pld 函数标签只追加：replace 缺省/false；值可解析到 DLC 或本体函数/标签
  4. 所有 function / function #tag / schedule function 目标存在（DLC ∪ 本体 zip）
  5. 所有 predicate / loot table / advancement 引用存在
  6. Phase 1 文件没有 data merge Items 整表覆盖，也没有 data modify ... Items set value
  7. scoreboard objectives add 全局唯一
  8. Phase 1 引用的 objective 都在 DLC/本体声明过
  9. 12 DMG / 10 FX / 6 BASE / 36 SKL 文件齐全；parse 挂点、tick 去重、追加伤害 tag 等关键接线在位
 10. 备份目录存在

alpha.54 起本检查按“五纹完整化”契约更新：SKL 开纹、弓弩 DMG、全部 FX 解除
Phase 1 的 deferred 限制；镜隙(4) 停用、炉形仅 ying_ren 的边界仍强制校验。

退出码 0 = 全部通过；1 = 有失败项。
"""

import glob
import json
import os
import re
import sys
import zipfile

PROJ = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
DP = os.path.join(PROJ, "src", "datapack")
BODY = os.path.join(PROJ, "梦回盘灵服务端", "world", "datapacks", "panling-1.1.0b.zip")
BACKUP = os.path.join(PROJ, ".work", "weapon-phase1", "backup")

FAILS = []
WARNS = []


def fail(msg):
    FAILS.append(msg)


def warn(msg):
    WARNS.append(msg)


def rel(path):
    return os.path.relpath(path, DP).replace(os.sep, "/")


def read_text(path):
    with open(path, "r", encoding="utf-8") as f:
        return f.read()


def load_json(path):
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def id_from_path(path, kind):
    """data/<ns>/<kind>/<sub>.json|mcfunction -> ns:sub"""
    p = path.replace(os.sep, "/")
    m = re.match(r"data/([^/]+)/" + kind + r"/(.+)\.(json|mcfunction)$", p)
    if not m:
        return None
    return m.group(1) + ":" + m.group(2)


# ---------------------------------------------------------------------------
# 收集 DLC 资源
# ---------------------------------------------------------------------------
if not os.path.isdir(DP):
    print("FATAL: missing", DP)
    sys.exit(1)
if not os.path.isfile(BODY):
    print("FATAL: missing body zip", BODY)
    sys.exit(1)

dlc_files = []
for dp, dn, fn in os.walk(DP):
    for f in fn:
        dlc_files.append(rel(os.path.join(dp, f)))

json_files = []
json_objs = {}
for r in dlc_files:
    if r.endswith(".json"):
        full = os.path.join(DP, r.replace("/", os.sep))
        json_files.append(r)
        try:
            json_objs[r] = load_json(full)
        except Exception as e:
            fail("JSON 解析失败 %s: %s" % (r, e))

# pack.mcmeta
try:
    load_json(os.path.join(DP, "pack.mcmeta"))
except Exception as e:
    fail("pack.mcmeta 解析失败: %s" % e)

dlc_funcs, dlc_tags, dlc_preds, dlc_loot, dlc_advs = set(), set(), set(), set(), set()
for r in dlc_files:
    if r.startswith("data/") and "/functions/" in r and r.endswith(".mcfunction"):
        i = id_from_path(r, "functions")
        if i:
            dlc_funcs.add(i)
    if r.startswith("data/") and "/tags/functions/" in r and r.endswith(".json"):
        i = id_from_path(r, "tags/functions")
        if i:
            dlc_tags.add(i)
    if r.startswith("data/") and "/predicates/" in r and r.endswith(".json"):
        i = id_from_path(r, "predicates")
        if i:
            dlc_preds.add(i)
    if r.startswith("data/") and "/loot_tables/" in r and r.endswith(".json"):
        i = id_from_path(r, "loot_tables")
        if i:
            dlc_loot.add(i)
    if r.startswith("data/") and "/advancements/" in r and r.endswith(".json"):
        i = id_from_path(r, "advancements")
        if i:
            dlc_advs.add(i)

# ---------------------------------------------------------------------------
# 本体资源
# ---------------------------------------------------------------------------
body_funcs, body_tags, body_preds, body_loot, body_advs = set(), set(), set(), set(), set()
body_text = {}
try:
    z = zipfile.ZipFile(BODY)
    for n in z.namelist():
        if n.endswith(".mcfunction") and "/functions/" in n:
            i = id_from_path(n, "functions")
            if i:
                body_funcs.add(i)
                body_text[n] = z.read(n).decode("utf-8", errors="ignore")
        if n.endswith(".json") and "/tags/functions/" in n:
            i = id_from_path(n, "tags/functions")
            if i:
                body_tags.add(i)
        if n.endswith(".json") and "/predicates/" in n:
            i = id_from_path(n, "predicates")
            if i:
                body_preds.add(i)
        if n.endswith(".json") and "/loot_tables/" in n:
            i = id_from_path(n, "loot_tables")
            if i:
                body_loot.add(i)
        if n.endswith(".json") and "/advancements/" in n:
            i = id_from_path(n, "advancements")
            if i:
                body_advs.add(i)
except Exception as e:
    fail("读取本体 zip 失败: %s" % e)

all_funcs = dlc_funcs | body_funcs
all_tags = dlc_tags | body_tags
all_preds = dlc_preds | body_preds
all_loot = dlc_loot | body_loot
all_advs = dlc_advs | body_advs

# ---------------------------------------------------------------------------
# 1) 不覆盖 pld body
# ---------------------------------------------------------------------------
allowed_pld_prefix = ("data/pld/tags/functions/", "data/pld/tags/items/")
for r in dlc_files:
    if r.startswith("data/pld/"):
        if not r.startswith(allowed_pld_prefix):
            fail("发现 pld 非标签文件（可能覆盖 body）: %s" % r)
if any(r.startswith("data/pld/functions/") for r in dlc_files):
    fail("发现 data/pld/functions/**：禁止覆盖本体 body 函数")
if os.path.isdir(os.path.join(DP, "data", "pld", "functions")):
    fail("data/pld/functions 目录存在")

# ---------------------------------------------------------------------------
# 2) pld 标签只追加
# ---------------------------------------------------------------------------
for r, obj in json_objs.items():
    if not r.startswith("data/pld/tags/functions/"):
        continue
    if not isinstance(obj, dict):
        fail("%s: tag 不是对象" % r)
        continue
    if obj.get("replace") is True:
        fail("%s: replace=true，会覆盖本体标签" % r)
    vals = obj.get("values")
    if not isinstance(vals, list):
        fail("%s: values 不是数组" % r)
        continue
    for v in vals:
        if isinstance(v, dict):
            v = v.get("id")
        if not isinstance(v, str):
            fail("%s: 非法 tag 值 %r" % (r, v))
            continue
        if v.startswith("#"):
            if v[1:] not in all_tags:
                fail("%s: 嵌套标签不存在 %s" % (r, v))
        else:
            if v not in all_funcs:
                fail("%s: 标签函数不存在 %s" % (r, v))

# ---------------------------------------------------------------------------
# 3) 函数引用 / predicate / loot / advancement
# ---------------------------------------------------------------------------
func_re = re.compile(r"\bfunction\s+(#[A-Za-z0-9_./:-]+|[A-Za-z0-9_.-]+:[A-Za-z0-9_./-]+)")
sched_re = re.compile(r"\bschedule\s+function\s+([A-Za-z0-9_.-]+:[A-Za-z0-9_./-]+)")
pred_re = re.compile(r"\bpredicate\s+([A-Za-z0-9_.-]+:[A-Za-z0-9_./-]+)")
loot_re = re.compile(r"\bloot\s+spawn\s+[^\n]*?\bloot\s+([A-Za-z0-9_.-]+:[A-Za-z0-9_./-]+)")
adv_re = re.compile(r"\badvancement\s+(?:revoke|grant)\s+@[a-z]\s+only\s+([A-Za-z0-9_.-]+:[A-Za-z0-9_./-]+)")

for r in dlc_files:
    if not r.endswith(".mcfunction"):
        continue
    text = read_text(os.path.join(DP, r.replace("/", os.sep)))
    for line in text.splitlines():
        if line.lstrip().startswith("#"):
            continue
        for m in func_re.finditer(line):
            t = m.group(1)
            if t.startswith("#"):
                if t[1:] not in all_tags:
                    fail("%s: 调用的标签不存在 %s" % (r, t))
            elif t not in all_funcs:
                fail("%s: 调用的函数不存在 %s" % (r, t))
        for m in sched_re.finditer(line):
            t = m.group(1)
            if t not in all_funcs:
                fail("%s: schedule 目标不存在 %s" % (r, t))
        for m in pred_re.finditer(line):
            t = m.group(1)
            if t not in all_preds:
                fail("%s: predicate 不存在 %s" % (r, t))
        for m in loot_re.finditer(line):
            t = m.group(1)
            if t not in all_loot:
                fail("%s: loot table 不存在 %s" % (r, t))
        for m in adv_re.finditer(line):
            t = m.group(1)
            if t not in all_advs:
                fail("%s: advancement 不存在 %s" % (r, t))

# advancement reward function 存在
for r, obj in json_objs.items():
    if "/advancements/" in r and isinstance(obj, dict):
        fn = (obj.get("rewards") or {}).get("function")
        if isinstance(fn, str) and fn not in all_funcs:
            fail("%s: advancement reward 函数不存在 %s" % (r, fn))

# 主 tick/load 标签仍包含 DLC 入口
for r, needle in (("data/minecraft/tags/functions/tick.json", "plm:tick/main"),
                  ("data/minecraft/tags/functions/load.json", "plm:load/main")):
    obj = json_objs.get(r)
    if obj is None:
        fail("缺少 %s" % r)
    elif needle not in obj.get("values", []):
        fail("%s: 缺少 %s" % (r, needle))

# ---------------------------------------------------------------------------
# 4) 禁止 data merge Items / Items set value（Phase 1 文件）
# ---------------------------------------------------------------------------
phase1_roots = ("data/plm/functions/weapon/",)
bad_items = []
for r in dlc_files:
    if not r.endswith(".mcfunction"):
        continue
    text = read_text(os.path.join(DP, r.replace("/", os.sep)))
    if re.search(r"\bdata\s+merge\s+\S+\s+\S+[^\n]*\bItems\b", text) or \
       re.search(r"\bdata\s+modify\s+\S+\s+\S+[^\n]*\bItems\s+set\s+value\b", text):
        if r.startswith(phase1_roots):
            fail("%s: 出现 Items 整表覆盖" % r)
        else:
            bad_items.append(r)
if bad_items:
    warn("已存在的 Items 整表覆盖（Phase 1 未修改，未计入失败）: " + ", ".join(sorted(set(bad_items))[:8]))

# ---------------------------------------------------------------------------
# 5) objective 唯一 + 引用已声明
# ---------------------------------------------------------------------------
declared = set()
dup = {}
for r in dlc_files:
    if not r.endswith(".mcfunction"):
        continue
    text = read_text(os.path.join(DP, r.replace("/", os.sep)))
    for line in text.splitlines():
        if line.lstrip().startswith("#"):
            continue
        # 只统计顶层声明；`execute ... run scoreboard objectives add ...` 是幂等补建，
        # 与 arena/load/ensure.mcfunction 一样按设计可能重复出现，不构成重复声明。
        m = re.match(r"^\s*scoreboard\s+objectives\s+add\s+(\S+)\s+(\S+)", line)
        if m:
            name = m.group(1)
            if name in declared:
                dup.setdefault(name, []).append(r)
            declared.add(name)
if dup:
    for name, where in dup.items():
        fail("objective 重复声明 %s: %s" % (name, ", ".join(sorted(set(where)))))

body_declared = set()
for text in body_text.values():
    for line in text.splitlines():
        m = re.search(r"scoreboard\s+objectives\s+add\s+(\S+)\s+(\S+)", line)
        if m:
            body_declared.add(m.group(1))
all_declared = declared | body_declared

obj_ref_patterns = [
    re.compile(r"scoreboard\s+players\s+(?:set|add|remove|reset|enable|get|operation)\s+(\S+)\s+(\S+)"),
    re.compile(r"store\s+result\s+score\s+(\S+)\s+(\S+)"),
    re.compile(r"(?:if|unless)\s+score\s+(\S+)\s+(\S+)"),
]
scores_re = re.compile(r"scores\s*=\s*\{([^}]*)\}")

bad_obj = set()
for r in dlc_files:
    if not r.endswith(".mcfunction") or not r.startswith(phase1_roots):
        continue
    text = read_text(os.path.join(DP, r.replace("/", os.sep)))
    for line in text.splitlines():
        if line.lstrip().startswith("#"):
            continue
        for pat in obj_ref_patterns:
            for m in pat.finditer(line):
                obj = m.group(2)
                if obj not in all_declared:
                    bad_obj.add((r, obj))
        for m in scores_re.finditer(line):
            for part in m.group(1).split(","):
                if "=" in part:
                    obj = part.split("=", 1)[0].strip()
                    if obj and obj not in all_declared:
                        bad_obj.add((r, obj))
if bad_obj:
    for r, obj in sorted(bad_obj):
        fail("%s: 引用未声明 objective %s" % (r, obj))

# ---------------------------------------------------------------------------
# 6) Phase 1 交付齐全 / 关键接线
# ---------------------------------------------------------------------------
DMG_IDS = ["po_xiao", "xu_ying", "ni_lin", "jing_xi", "zhui_ying", "lian_xing",
           "bei_zhao", "yu_xiang", "ying_ren", "su_feng", "shuang_zhao", "jing_shu"]
FX_IDS = ["jing_hen", "zhe_guang", "jie_ying", "zhao_xi", "shi_ying",
          "jing_xi", "fan_zhao", "shuang_ying", "ying_sheng", "jing_jing"]
BASE_IDS = ["base_zhao_xin", "base_lie_ying", "base_jing_hua", "base_can_ying",
            "base_shuang_sheng", "base_ta_yin"]
SKL_IDS = ["ying_xin", "chi_jing", "fen_ying_ji", "fen_ying_shi", "ming_jing_zao", "jing_xin_su",
           "lie_shen", "ying_zhong", "ying_chi", "lie_xu", "chong_ying_xu", "ying_sui_zhi",
           "jing_hua_tan", "jing_hua_bao", "shui_yue_kuan", "shui_yue_jiu", "hua_ying_su", "ying_shui_qiang",
           "liu_ying_jiu", "liu_ying_su", "ying_sui_duo", "ying_sui_qiang", "lian_ying_yi", "chong_ying_chuan",
           "dao_ying_qiang", "dao_ying_kuai", "jing_xia_jiu", "gong_ming_shang", "gong_ming_xiao", "shuang_sheng_qi",
           "ta_yin_cheng", "ta_pian_shang", "ta_pian_qiang", "xian_ying_jiu", "zhao_yao_shen", "he_yin_sheng"]

for aid in DMG_IDS:
    if ("plm:weapon/dmg/melee/" + aid) not in dlc_funcs:
        fail("缺少 DMG 分支 plm:weapon/dmg/melee/%s" % aid)
    if ("plm:weapon/dmg/archer/" + aid) not in dlc_funcs:
        fail("缺少 DMG(archer) 分支 plm:weapon/dmg/archer/%s" % aid)
for aid in FX_IDS:
    if ("plm:weapon/fx/" + aid) not in dlc_funcs:
        fail("缺少 FX 分支 plm:weapon/fx/%s" % aid)
for aid in BASE_IDS:
    if ("plm:weapon/base/" + aid) not in dlc_funcs:
        fail("缺少 BASE 分支 plm:weapon/base/%s" % aid)
for aid in SKL_IDS:
    if ("plm:weapon/skl/" + aid) not in dlc_funcs:
        fail("缺少 SKL 占位 plm:weapon/skl/%s" % aid)

# 标签接线
tag_expect = {
    "data/pld/tags/functions/weapon_unlock/enchant.json": ["plm:weapon/parse", "plm:mirror/enable/weapon"],
    "data/pld/tags/functions/warrior/when_hurt_entity.json": ["plm:weapon/on_hit"],
    "data/pld/tags/functions/attack_damage/multiply_base.json": ["plm:weapon/ctx/melee"],
    "data/pld/tags/functions/archer_damage/multiply_base.json": ["plm:weapon/ctx/archer"],
    "data/pld/tags/functions/archer/the_arrow.json": ["plm:weapon/ctx/arrow"],
    "data/pld/tags/functions/equipment_lock/when_damaged.json": ["plm:weapon/event/damaged"],
    "data/pld/tags/functions/equipment_lock/when_weapon_skill_enable.json": ["plm:weapon/ctx/skill"],
}
for r, expected in tag_expect.items():
    obj = json_objs.get(r)
    if obj is None:
        fail("缺少标签文件 %s" % r)
        continue
    vals = obj.get("values", [])
    for v in expected:
        if v not in vals:
            fail("%s: 缺少标签值 %s" % (r, v))

# 设计 §10.3 明确禁止 equipment_lock/weapon/enhance/id_check 挂点（镜武没有 enhance_lvl）
id_check_tag = "data/pld/tags/functions/equipment_lock/weapon/enhance/id_check.json"
if os.path.isfile(os.path.join(DP, id_check_tag.replace("/", os.sep))):
    fail("%s: 仍存在（设计 §10.3 禁止 id_check 挂点）" % id_check_tag)
if "plm:weapon/parse/id_check" in dlc_funcs:
    fail("plm:weapon/parse/id_check 仍存在（设计 §10.3 禁止 id_check 挂点）")

# 关键接线
def has(relpath, needle, must=True):
    p = os.path.join(DP, relpath.replace("/", os.sep))
    if not os.path.isfile(p):
        fail("缺少文件 %s" % relpath)
        return
    t = read_text(p)
    if (needle in t) != must:
        fail("%s: %s %r" % (relpath, "缺少" if must else "不应出现", needle))

has("data/plm/functions/weapon/on_hit.mcfunction", "mirror_affix_damage")
has("data/plm/functions/weapon/dmg/extra_hit.mcfunction", "mirror_affix_damage")
has("data/plm/functions/weapon/dmg/extra_hit.mcfunction", "if_death_count")
has("data/plm/functions/weapon/dmg/extra_hit.mcfunction", "pld:pre/damage/public_damage_entity")
has("data/plm/functions/weapon/on_hit.mcfunction", "plm:weapon/dmg/extra_apply")
has("data/plm/functions/weapon/ctx/melee.mcfunction", "warrior_tag")
has("data/plm/functions/weapon/clear.mcfunction", "mirror_weapon_active")
has("data/plm/functions/weapon/parse.mcfunction", "~ 255 ~")
has("data/plm/functions/weapon/parse.mcfunction", "plm:weapon/refresh")
if "plm:weapon/ctx/target" not in dlc_funcs:
    fail("缺少目标选择 API plm:weapon/ctx/target")
has("data/plm/functions/weapon/refresh.mcfunction", "WeaponSlot")
has("data/plm/functions/weapon/load/combat.mcfunction", "mirror_game_time")

# 本轮修复的接线（防止回退）
has("data/plm/functions/weapon/ctx/melee.mcfunction", "plm:weapon/ctx/target")
has("data/plm/functions/weapon/on_hit.mcfunction", "plm:weapon/ctx/target")
has("data/plm/functions/weapon/ctx/archer.mcfunction", "job matches 1")
has("data/plm/functions/weapon/dmg/extra_apply.mcfunction", "attack_multiplier")
has("data/plm/functions/weapon/dmg/extra_apply.mcfunction", "attack_damage_multiply_base")
has("data/plm/functions/weapon/tick/refresh.mcfunction", "plm:weapon/refresh/check")
has("data/plm/functions/weapon/refresh/check.mcfunction", "mirror:1,act:1")
has("data/plm/functions/weapon/ctx/melee.mcfunction", "mirror:1,act:1")
has("data/plm/functions/weapon/ctx/melee.mcfunction", "job matches 0")
has("data/plm/functions/weapon/ctx/melee.mcfunction", "mirror_xu_streak")
has("data/plm/functions/weapon/on_hit.mcfunction", "mirror:1,act:1")
has("data/plm/functions/weapon/ctx/archer.mcfunction", "mirror:1,act:1")
has("data/plm/functions/weapon/fx/jing_xi/tick.mcfunction", "mirror_fx_jing_xi_next")
has("data/plm/functions/weapon/fx/jing_xi/tick.mcfunction", "add @s mirror_fx_jing_xi_until 100")
has("data/plm/functions/weapon/fx/jing_xi/tick.mcfunction", "add @s mirror_fx_jing_xi_next 20")
has("data/plm/functions/weapon/fx/jing_xi/heal.mcfunction", "mirror_wtmp2 matches ..0")
has("data/plm/functions/weapon/event/damaged.mcfunction", "mirror_fx_jing_xi_next")
has("data/plm/functions/weapon/load/combat.mcfunction", "mirror_fx_jing_xi_next")
has("data/plm/functions/weapon/fx/jing_xi/tick.mcfunction", "mirror_fx_jing_xi_done matches -2147483648..")
has("data/plm/functions/weapon/trail/tick.mcfunction", "minecraft:the_nether")
has("data/plm/functions/weapon/trail/load_dim.mcfunction", "plm_trail_5")
has("data/plm/functions/weapon/on_hit/mark.mcfunction", "mirror_uid")
has("data/plm/functions/weapon/event/kill.mcfunction", "mirror_last_kill")
has("data/plm/functions/weapon/refresh/hook.mcfunction", "mirror_refresh_pending")
has("data/plm/functions/weapon/refresh/pending.mcfunction", "plm:weapon/refresh")
if "plm:weapon/inventory_changed" not in dlc_advs:
    fail("缺少进度 plm:weapon/inventory_changed（事件驱动 parse）")
if "plm:weapon/trail/load" not in dlc_funcs:
    fail("缺少 plm:weapon/trail/load")

# 五纹完整化（alpha.54）：Phase 1 的 deferred 限制已按设计解除。
# 仍必须保证：镜隙(4) 停用；炉形只开 ying_ren(9) 且最多 1 条 DMG；
# SKL 按器形 6 条池、上限 3；FX 上限 1；总上限 5；Lore 分文件按器形过滤。
has("data/plm/functions/weapon/affix/add/skl.mcfunction",
    "execute unless score #t wp_form matches 1..6 run return 0")
has("data/plm/functions/weapon/affix/pick_skl.mcfunction",
    "function plm:weapon/affix/pick_skl/try")
has("data/plm/functions/weapon/affix/pick_skl/try.mcfunction", "wp_pool_skl")
skl_try = read_text(os.path.join(DP, "data/plm/functions/weapon/affix/pick_skl/try.mcfunction"))
skl_fallback = read_text(os.path.join(DP, "data/plm/functions/weapon/affix/pick_skl/fallback.mcfunction"))
for sid in SKL_IDS:
    needle = 'mirror_skl[{id:"%s"}]' % sid
    if needle not in skl_try:
        fail("pick_skl/try: 缺少 SKL %s 抽取分支" % sid)
    if needle not in skl_fallback:
        fail("pick_skl/fallback: 缺少 SKL %s 兜底分支" % sid)
has("data/plm/functions/weapon/affix/add/dmg.mcfunction",
    "wp_form matches 5..6 if score #t wp_n_dmg matches 1.. run return 0")
has("data/plm/functions/weapon/affix/pick_dmg/try.mcfunction",
    "wp_form matches 5..6 unless score #t wp_idx matches 9 run scoreboard players set #t wp_dup 1")
has("data/plm/functions/weapon/affix/pick_dmg/fallback.mcfunction",
    'wp_form matches 5..6 if score #t wp_found matches 0 unless data block ~ ~ ~ '
    'Items[{Slot:3b}].tag.mirror_dmg[{id:"ying_ren"}] run scoreboard players set #t wp_idx 9')
has("data/plm/functions/weapon/affix/add_one.mcfunction", "scoreboard players set #t wp_can_skl 0")
has("data/plm/functions/weapon/affix/add_one.mcfunction",
    "wp_n_skl matches ..2 run scoreboard players add #t wp_can_skl 1")
has("data/plm/functions/weapon/affix/add_one.mcfunction",
    "wp_n_fx matches 0 run scoreboard players set #t wp_can_fx 1")
has("data/plm/functions/weapon/affix/add_one.mcfunction", "wp_added 0")
has("data/plm/functions/weapon/affix/add/dmg.mcfunction", "wp_added 1")
has("data/plm/functions/weapon/affix/add/fx.mcfunction", "wp_added 1")
has("data/plm/functions/weapon/affix/pick_dmg/try.mcfunction",
    "matches 4 run scoreboard players set #t wp_dup 1")
has("data/plm/functions/weapon/affix/pick_fx/try.mcfunction",
    'execute if score #t wp_idx matches 7 if data block ~ ~ ~ '
    'Items[{Slot:3b}].tag.mirror_fx[{id:"fan_zhao"}] run scoreboard players set #t wp_dup 1')

# 12 DMG 中 11 条 active：镜隙(4) 停用；每条都要在抽取/兜底里有真实分支。
dmg_try = read_text(os.path.join(DP, "data/plm/functions/weapon/affix/pick_dmg/try.mcfunction"))
dmg_fallback = read_text(os.path.join(DP, "data/plm/functions/weapon/affix/pick_dmg/fallback.mcfunction"))
for did in DMG_IDS:
    if did == "jing_xi":
        continue
    needle = 'mirror_dmg[{id:"%s"}]' % did
    if needle not in dmg_try:
        fail("pick_dmg/try: 缺少 DMG %s 抽取分支" % did)
    if needle not in dmg_fallback:
        fail("pick_dmg/fallback: 缺少 DMG %s 兜底分支" % did)
if 'mirror_dmg[{id:"jing_xi"}]' in dmg_fallback:
    fail("pick_dmg/fallback: 仍把设计停用的镜隙(jing_xi)放进兜底池")

# 10 FX 全部 active：每条都要在抽取/兜底里有真实分支。
fx_try = read_text(os.path.join(DP, "data/plm/functions/weapon/affix/pick_fx/try.mcfunction"))
fx_fallback = read_text(os.path.join(DP, "data/plm/functions/weapon/affix/pick_fx/fallback.mcfunction"))
for fid in FX_IDS:
    needle = 'mirror_fx[{id:"%s"}]' % fid
    if needle not in fx_try:
        fail("pick_fx/try: 缺少 FX %s 抽取分支" % fid)
    if needle not in fx_fallback:
        fail("pick_fx/fallback: 缺少 FX %s 兜底分支" % fid)
if "matches 7 run scoreboard players set #t wp_dup 1" in fx_try:
    fail("pick_fx/try: 第 7 条 FX 仍被无条件跳过（设计已启用）")

# 五纹上限 5，类别上限 DMG 3 / SKL 3 / FX 1
has("data/plm/functions/weapon/table/full.mcfunction", "scoreboard players set #t wp_cap 5")
has("data/plm/functions/weapon/table/full.mcfunction", "wp_full")
has("data/plm/functions/weapon/affix/add_one.mcfunction", "wp_n_dmg matches ..2")
has("data/plm/functions/weapon/table/temper.mcfunction", "plm:weapon/table/full")
has("data/plm/functions/weapon/table/temper.mcfunction", "wp_added")
has("data/plm/functions/weapon/table/reroll.mcfunction", "wp_temper = #t wp_n_dmg")
has("data/plm/functions/weapon/table/reroll.mcfunction", "+= #t wp_n_skl")
has("data/plm/functions/weapon/table/reroll.mcfunction", "+= #t wp_n_fx")
has("data/plm/functions/weapon/table/reroll.mcfunction", "plm:weapon/msg/not_full")
has("data/plm/functions/weapon/affix/reroll_all.mcfunction", "plm:weapon/affix/reroll_loop")
has("data/plm/functions/weapon/affix/reroll_all.mcfunction", "wp_rr_n")
has("data/plm/functions/weapon/affix/reroll_loop.mcfunction", "plm:weapon/affix/add_one")
has("data/plm/functions/weapon/load/combat.mcfunction", "wp_rr_n")
has("data/plm/functions/weapon/table/quench.mcfunction", "plm:weapon/msg/not_full")
has("data/plm/functions/weapon/table/route/core.mcfunction", "wp_full")
has("data/plm/functions/weapon/table/route/lens.mcfunction", "wp_full")
has("data/plm/functions/weapon/msg/temper_full.mcfunction", "本器形可开纹数已满")
has("data/plm/functions/weapon/msg/not_full.mcfunction", "镜纹未满")
has("data/plm/functions/weapon/load/combat.mcfunction", "wp_added")
has("data/plm/functions/weapon/load/combat.mcfunction", "wp_cap")
has("data/plm/functions/weapon/load/combat.mcfunction", "wp_full")
add_one = read_text(os.path.join(DP, "data/plm/functions/weapon/affix/add_one.mcfunction"))
if "scoreboard players set #t wp_can_skl 1" in add_one:
    fail("add_one: SKL 仍被强制设为可抽（应由类别权重与上限决定）")

# Lore 已按 dmg/skl/fx 拆分：入口只负责调用，具体过滤在子文件。
for lf in ("data/plm/functions/weapon/table/lore/at5.mcfunction",
           "data/plm/functions/weapon/table/lore/at3.mcfunction"):
    lp = os.path.join(DP, lf.replace("/", os.sep))
    if not os.path.isfile(lp):
        fail("缺少 Lore 文件 %s" % lf)
        continue
    lt = read_text(lp)
    if "五纹已满" in lt:
        fail("%s: 仍显示「五纹已满」（Phase 1 有效纹数低于 5）" % lf)
    for n in ("1/5", "2/5", "3/5", "4/5"):
        if ("镜纹 " + n) in lt:
            fail("%s: 仍显示「镜纹 %s」" % (lf, n))
    if "本器形已满" not in lt:
        fail("%s: 缺少器形上限提示" % lf)
    if "plm:weapon/table/full" not in lt:
        fail("%s: 缺少 table/full 上限计算" % lf)
    suffix = "5" if lf.endswith("at5.mcfunction") else "3"
    for kind in ("dmg", "skl", "fx"):
        call = "function plm:weapon/table/lore/%s_at%s" % (kind, suffix)
        if call not in lt:
            fail("%s: 缺少 Lore 分文件调用 %s" % (lf, call))

for suffix, slot in (("5", "5b"), ("3", "3b")):
    dl = "data/plm/functions/weapon/table/lore/dmg_at%s.mcfunction" % suffix
    dt = read_text(os.path.join(DP, dl.replace("/", os.sep)))
    if 'mirror_dmg[{id:"jing_xi"}]' in dt:
        fail("%s: 仍显示设计停用的镜隙(jing_xi)" % dl)
    for did in DMG_IDS:
        if did == "jing_xi":
            continue
        if 'mirror_dmg[{id:"%s"}]' % did not in dt:
            fail("%s: 缺少 DMG %s 的 Lore" % (dl, did))
    if "wp_form matches 1..4 if data block" not in dt:
        fail("%s: 近战/弓弩 DMG 缺少 form 1..4 守卫" % dl)
    if ('wp_form matches 1..6 if data block ~ ~ ~ Items[{Slot:%s}].tag.mirror_dmg[{id:"ying_ren"}]'
            % slot) not in dt:
        fail("%s: 炉形映刃缺少 form 1..6 守卫" % dl)

    fl = "data/plm/functions/weapon/table/lore/fx_at%s.mcfunction" % suffix
    ft = read_text(os.path.join(DP, fl.replace("/", os.sep)))
    for fid in FX_IDS:
        if 'mirror_fx[{id:"%s"}]' % fid not in ft:
            fail("%s: 缺少 FX %s 的 Lore" % (fl, fid))
    if "共鸣" not in ft:
        fail("%s: 缺少 4 条共鸣 Lore" % fl)

    sl = "data/plm/functions/weapon/table/lore/skl_at%s.mcfunction" % suffix
    st = read_text(os.path.join(DP, sl.replace("/", os.sep)))
    for sid in SKL_IDS:
        if 'mirror_skl[{id:"%s"}]' % sid not in st:
            fail("%s: 缺少 SKL %s 的 Lore" % (sl, sid))

# scoreboard players operation 的源必须是 <holder> <objective>，不能写数字字面量
for r in dlc_files:
    if not r.startswith("data/plm/functions/weapon/") or not r.endswith(".mcfunction"):
        continue
    t = read_text(os.path.join(DP, r.replace("/", os.sep)))
    for line in t.splitlines():
        if line.lstrip().startswith("#"):
            continue
        if "scoreboard players operation" in line and re.search(r"[*/%]= [0-9-]+", line):
            fail("%s: scoreboard operation 使用了数字字面量源（应使用 #const* mirror_calc）: %s" % (r, line.strip()))

# tick 去重 + 武器 tick 扩展
lm = read_text(os.path.join(DP, "data/plm/functions/load/main.mcfunction"))
if "schedule function plm:tick/loop" in lm:
    fail("plm:load/main 仍然 schedule plm:tick/loop（tick 入口重复）")
tm = read_text(os.path.join(DP, "data/plm/functions/tick/main.mcfunction"))
if "mirror_game_time" not in tm:
    fail("plm:tick/main 未更新 mirror_game_time")
wt = read_text(os.path.join(DP, "data/plm/functions/weapon/tick.mcfunction"))
for needle in ("plm:weapon/tick/refresh", "plm:weapon/tick/5t", "plm:weapon/tick/20t", "mirror_tick20"):
    if needle not in wt:
        fail("plm:weapon/tick 缺少 %s" % needle)
wl = read_text(os.path.join(DP, "data/plm/functions/weapon/load.mcfunction"))
for needle in ("plm:weapon/load/combat", "plm:weapon/config/affix", "plm:weapon/trail/load"):
    if needle not in wl:
        fail("plm:weapon/load 缺少 %s" % needle)

# 不应使用 wp_form 作为玩家器形（table 的 #t wp_form 不受影响）
for r in dlc_files:
    if r.startswith("data/plm/functions/weapon/") and r.endswith(".mcfunction"):
        if r in ("data/plm/functions/weapon/affix/append/skl_4.mcfunction",
                 "data/plm/functions/weapon/affix/append/skl_5.mcfunction"):
            continue
        t = read_text(os.path.join(DP, r.replace("/", os.sep)))
        if re.search(r"\b@[spe]\S*\s+wp_form\b", t):
            fail("%s: 把 wp_form 当作玩家器形使用（应为 mirror_form）" % r)

# Phase 1 洗练入口必须按 wp_full 判定，不能写死 wp_temper==5（cap 4/3/1）
rs = read_text(os.path.join(DP, "data/plm/functions/weapon/table/route/sand.mcfunction"))
if "wp_temper matches 5" in rs:
    fail("route/sand 仍写死 wp_temper==5；Phase 1 cap 4/3/1 会导致新武器无法洗练")
if "function plm:weapon/table/reroll" not in rs:
    fail("route/sand 未调用 plm:weapon/table/reroll")

# ---------------------------------------------------------------------------
# 7) 六器形共享接线
# ---------------------------------------------------------------------------
# 7.1 pld 标签只追加（replace:false），且包含 DLC 入口
shared_tag_expect = {
    "data/pld/tags/functions/right_click/check.json": ["plm:mirror/input/check"],
    "data/pld/tags/functions/archer/when_shoot.json": ["plm:mirror/input/archer"],
}
for r, expected in shared_tag_expect.items():
    obj = json_objs.get(r)
    if obj is None:
        fail("缺少共享标签 %s" % r)
        continue
    if obj.get("replace") is True:
        fail("%s: replace=true，会覆盖本体标签" % r)
    vals = obj.get("values", [])
    if not isinstance(vals, list):
        fail("%s: values 不是数组" % r)
        continue
    for v in expected:
        if v not in vals:
            fail("%s: 缺少标签值 %s" % (r, v))
    for v in vals:
        if isinstance(v, str) and v.startswith("pld:"):
            fail("%s: 追加文件不应重复本体值 %s" % (r, v))

# 7.2 共享 objective 必须在 DLC 或本体声明（唯一性由第 5 节统一检查）
shared_objs = [
    "mirror_cd_int", "mirror_cast_lock",
    "mirror_taying_dist", "mirror_taying_buff", "mirror_taying_cd",
    "mirror_taying_last_x", "mirror_taying_last_z", "mirror_taying_dx", "mirror_taying_dz",
    "mirror_yingsui_5ticks", "mirror_yingsui_i", "mirror_yingsui_x", "mirror_yingsui_z",
    "mirror_bloom_5ticks", "mirror_bloom_dmg", "mirror_bloom_range", "mirror_bloom_extra",
    "mirror_bloom_free", "mirror_bloom_count", "mirror_bloom_pct", "mirror_bloom_target",
    "mirror_flower", "mirror_flower_until", "mirror_flower_max", "mirror_flower_extra",
    "mirror_turret_5ticks", "mirror_turret_atk", "mirror_turret_owner", "mirror_turret_ratio",
    "mirror_turret_interval", "mirror_turret_shots", "mirror_turret_prev", "mirror_turret_count",
    "mirror_path_t", "mirror_path_n", "mirror_path_i",
    "mirror_lian", "mirror_lian_target", "mirror_lian_until", "mirror_lian_extra",
    "mirror_box_5ticks", "mirror_box_el", "mirror_box_remember",
    "mirror_zf_base", "mirror_zf_el", "mirror_zf_due", "mirror_zf_owner",
    "mirror_resonance", "mirror_resonance_until", "mirror_resonance_target", "mirror_resonance_extra",
    "mirror_rub_stack", "mirror_rub_type", "mirror_rub_base", "mirror_rub_flag",
    "mirror_rub_cd", "mirror_rub_extra", "mirror_rub_free", "mirror_rub_rubbable",
]
for name in shared_objs:
    if name not in all_declared:
        fail("缺少共享 objective %s" % name)

# 7.3 六器形入口文件存在（route/tick/clear + 14 个器形占位）
shared_entries = [
    "plm:mirror/input/check", "plm:mirror/input/archer",
    "plm:mirror/skill/route", "plm:mirror/skill/tick", "plm:mirror/skill/clear",
    "plm:mirror/skill/sword/tick", "plm:mirror/skill/sword/on_hit",
    "plm:mirror/skill/bow/route", "plm:mirror/skill/bow/tick",
    "plm:mirror/skill/crossbow/route", "plm:mirror/skill/crossbow/tick",
    "plm:mirror/skill/furnace/twin/box_route", "plm:mirror/skill/furnace/twin/after_main",
    "plm:mirror/skill/furnace/twin/after_off", "plm:mirror/skill/furnace/twin/tick",
    "plm:mirror/skill/furnace/rub/release_route", "plm:mirror/skill/furnace/rub/after_main",
    "plm:mirror/skill/furnace/rub/after_off", "plm:mirror/skill/furnace/rub/tick",
    "plm:mirror/skill/axe/tick",
]
for f in shared_entries:
    if f not in dlc_funcs:
        fail("缺少共享入口 %s" % f)

# 7.4 路由/ tick / 丹炉分派关键行在位
route_rel = "data/plm/functions/mirror/skill/route.mcfunction"
route_text = read_text(os.path.join(DP, route_rel.replace("/", os.sep)))
for needle in ("right_click_run matches 20..29",
               "plm:mirror/skill/parry/start", "plm:mirror/skill/shadow/route",
               "plm:mirror/skill/axe/chongying/route",
               "plm:mirror/skill/furnace/twin/box_route",
               "plm:mirror/skill/furnace/rub/release_route"):
    if needle not in route_text:
        fail("%s: 缺少分派 %s" % (route_rel, needle))
tick_text = read_text(os.path.join(DP, "data/plm/functions/mirror/skill/tick.mcfunction"))
for needle in ("plm:mirror/skill/shadow/tick", "plm:mirror/skill/axe/chongying/tick",
               "plm:mirror/skill/sword/tick", "plm:mirror/skill/bow/tick",
               "plm:mirror/skill/crossbow/tick", "plm:mirror/skill/furnace/twin/tick",
               "plm:mirror/skill/furnace/rub/tick", "plm:mirror/skill/axe/tick"):
    if needle not in tick_text:
        fail("mirror/skill/tick: 缺少 %s" % needle)
for rel in ("data/plm/functions/mirror/furnace/after_main.mcfunction",
            "data/plm/functions/mirror/furnace/after_off.mcfunction"):
    t = read_text(os.path.join(DP, rel.replace("/", os.sep)))
    if "score @s zfsuccess matches 1" not in t:
        fail("%s: 缺少 zfsuccess 守卫" % rel)
    if "plm:mirror/skill/furnace/" not in t:
        fail("%s: 缺少 twin/rub 分派" % rel)
has("data/plm/functions/weapon/on_hit.mcfunction", "plm:mirror/skill/sword/on_hit")

# 7.5 正式竞技场必须通过受控入口生成 Boss，历史灰盒的施工和调试入口不随包发布。
arena_dir = os.path.join(DP, "data", "plm", "functions", "arena")
if not os.path.isdir(arena_dir):
    fail("缺少 arena 目录")
else:
    has("data/plm/functions/arena/start.mcfunction", "plm:arena/start_room")
    has("data/plm/functions/arena/start_room.mcfunction", "plm:arena/boss/spawn")
    has("data/plm/functions/arena/boss/spawn.mcfunction", "summon minecraft:husk")
    for bad in ("build", "dev"):
        if os.path.isdir(os.path.join(arena_dir, bad)):
            fail("arena 不应恢复目录 %s" % bad.replace(os.sep, "/"))

# ---------------------------------------------------------------------------
# 8) 备份
# ---------------------------------------------------------------------------
bk = sorted(glob.glob(os.path.join(BACKUP, "src-datapack-*")))
if not bk:
    fail("缺少备份 .work/weapon-phase1/backup/src-datapack-<timestamp>")
else:
    n = sum(len(fn) for dp, dn, fn in os.walk(bk[-1]))
    if n < 300:
        fail("备份文件数异常: %d" % n)

# ---------------------------------------------------------------------------
# 输出
# ---------------------------------------------------------------------------
print("== Phase 1 static check ==")
print("DLC files:", len(dlc_files), " functions:", len(dlc_funcs), " tags:", len(dlc_tags),
      " predicates:", len(dlc_preds), " loot:", len(dlc_loot), " advancements:", len(dlc_advs))
print("Body functions:", len(body_funcs), " body tags:", len(body_tags))
print("Declared objectives: DLC %d + body %d = %d" % (len(declared), len(body_declared), len(all_declared)))
if WARNS:
    print("\nWARN:")
    for w in WARNS:
        print("  -", w)
if FAILS:
    print("\nFAIL (%d):" % len(FAILS))
    for f in FAILS:
        print("  -", f)
    sys.exit(1)
print("\nOK: all checks passed")
sys.exit(0)
