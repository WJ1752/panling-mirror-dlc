# -*- coding: utf-8 -*-
"""
《梦回盘灵：镜中倒影》武器五纹 Phase 1 生成器
=================================================
只写 src/datapack 下的新增 plm: 函数、plm: 谓词/进度、以及 pld: 函数标签的追加值。
不触碰 data/pld/functions/**（本体 body）。

核心产出：
  1. 激活 parse：parse / parse/apply / parse/clear / parse/id_check / parse_hand 重写
  2. 战斗上下文：ctx/melee、ctx/archer、ctx/arrow、ctx/skill、目标 HP/背向/负面计数
  3. 命中外挂：on_hit（目标条件 DMG 合并为一次 mirror_affix_damage 追加伤害）
  4. DMG 12 条分支（9 条实装、3 条 deferred/停用）
  5. FX 10 条分支（3 条实装、7 条 deferred）
  6. BASE 6 条分支（1 条实装、5 条 deferred）
  7. SKL 36 条全部 deferred 占位函数
  8. tick 5t/20t 分离；镜径 trail、镜息回复、拾影掉落、10 秒/3 秒计时
  9. 必要的 pld: 函数标签追加（replace:false）

运行：
  python -I E:/梦回盘灵DLC开发/.work/weapon-phase1/gen_phase1.py

生成器是幂等的：它只覆盖自己生成的新文件；不修改 pld: body。
"""

import json
import os

PROJ = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
DP = os.path.join(PROJ, "src", "datapack")
PLM = os.path.join(DP, "data", "plm")
W = os.path.join(PLM, "functions", "weapon")
PDL_TAGS = os.path.join(DP, "data", "pld", "tags", "functions")

HEADER = [
    "# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。",
    "# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。",
    "# SKL 全部 deferred（六把武器技未编码）。",
]


def write_mc(rel, lines):
    full = os.path.join(W, rel.replace("/", os.sep))
    os.makedirs(os.path.dirname(full), exist_ok=True)
    with open(full, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(HEADER + [""] + list(lines)).rstrip() + "\n")


def write_json(rel, obj):
    full = os.path.join(DP, rel.replace("/", os.sep))
    os.makedirs(os.path.dirname(full), exist_ok=True)
    with open(full, "w", encoding="utf-8", newline="\n") as f:
        json.dump(obj, f, ensure_ascii=False, indent=4)
        f.write("\n")


# ---------------------------------------------------------------------------
# 词条表
#   max 的单位 = 设计文档 §6 的 max（百分点）。
#   parse 写入 objective 的 actual = max * val / 10（= max*val/100 的 ×10 定点）。
#   status:
#     self      —— 自状态条件，可进 #pld:attack_damage/multiply_base
#     target    —— 目标条件，命中后在 #pld:warrior/when_hurt_entity 追加伤害
#     disabled  —— 设计 v1 明确停用 / 无可接管线
#     deferred  —— Phase 1 明确不实现
# ---------------------------------------------------------------------------
DMG = [
    {"id": "po_xiao",     "name": "破晓", "max": 15, "status": "target",
     "why": "目标生命 >=90% 时 +15%（ctx 在 multiply_base 内、伤害结算前读目标 HP）"},
    {"id": "xu_ying",     "name": "续影", "max": 4,  "status": "target",
     "why": "同一目标连续命中每层 +4%，上限 3 层；按玩家记录目标 uid，切换目标清零"},
    {"id": "ni_lin",      "name": "逆鳞", "max": 12, "status": "self",
     "why": "自身 hp_precent <40 时 +12%"},
    {"id": "jing_xi",     "name": "镜隙", "max": 0,  "status": "disabled",
     "why": "设计 §6.1 v1 停用：近战无暴击乘区；镜隙 DMG 不实现（FX 镜隙另见 fx/jing_xi）"},
    {"id": "zhui_ying",   "name": "追映", "max": 12, "status": "target",
     "why": "目标有 slowness 或 vertigo_5ticks（眩晕）时 +12%；被标记 Phase 1 无来源（镜痕 deferred）"},
    {"id": "lian_xing",   "name": "连星", "max": 20, "status": "self",
     "why": "每第 3 次命中 +20%；mirror_hit_seq 在 on_hit 递增"},
    {"id": "bei_zhao",    "name": "背照", "max": 15, "status": "target",
     "why": "攻击者位于目标背后 120° 锥内 +15%（目标朝向为参考系，点积平方比较）"},
    {"id": "yu_xiang",    "name": "余响", "max": 10, "status": "self",
     "why": "击杀后 3s（60 tick）内 +10%"},
    {"id": "ying_ren",    "name": "映刃", "max": 12, "status": "deferred",
     "why": "技能伤害直接写 #temp entity_hurt_temp，不经过 multiply_base；Phase 1 无镜武技能"},
    {"id": "su_feng",     "name": "素锋", "max": 12, "status": "deferred",
     "why": "没有持久的“武器技增益已激活”标记；skill_success 只在施放瞬间存在，镜武 rare:7 不触发本体技能"},
    {"id": "shuang_zhao", "name": "双照", "max": 15, "status": "target",
     "why": "目标同时有 >=2 种负面效果时 +15%（10 个 DLC 谓词 + slowness/weakness）"},
    {"id": "jing_shu",    "name": "镜熟", "max": 12, "status": "target",
     "why": "对同一目标累计命中 >=10 后 +12%（mirror_xy_total）"},
]

FX = [
    {"id": "jing_hen",   "name": "镜痕", "max": 5,  "status": "deferred",
     "why": "不在 recon.recommendedScope；需要 3 次命中留痕 + 下一击目标条件，Phase 1 只保留 objective 与目标计数"},
    {"id": "zhe_guang",  "name": "折光", "max": 15, "status": "deferred",
     "why": "when_damaged 无 source/damage；投射物类型可判但伤害量/攻击者不可得"},
    {"id": "jie_ying",   "name": "借影", "max": 10, "status": "deferred",
     "why": "player_killed_entity reward 拿不到死者实体，无法读取/复制 ActiveEffects"},
    {"id": "zhao_xi",    "name": "照隙", "max": 15, "status": "deferred",
     "why": "不在 recon.recommendedScope；发光可做，但“下一次受伤 +5%”需要逐目标标记"},
    {"id": "shi_ying",   "name": "拾影", "max": 20, "status": "active",
     "why": "击杀事件 + 10s 冷却 + 20%×val 概率掉 1 影尘；不依赖死者"},
    {"id": "jing_xi",    "name": "镜息", "max": 5,  "status": "active",
     "why": "20t tick：脱战 3s 后每次 0.5%×val/100 最大生命，5s 一轮；直接读写 Health"},
    {"id": "fan_zhao",   "name": "反照", "max": 20, "status": "deferred",
     "why": "when_damaged 无攻击者；只能打最近怪，且 reduce_health 会双触发"},
    {"id": "shuang_ying","name": "双影", "max": 10, "status": "deferred",
     "why": "不在 recommendedScope；需要逐目标下一次攻击标记，箭矢侧无命中 tag"},
    {"id": "ying_sheng", "name": "映声", "max": 15, "status": "deferred",
     "why": "Phase 1 无镜武技能，减的是本体共享冷却，语义不对"},
    {"id": "jing_jing",  "name": "镜径", "max": 8,  "status": "active",
     "why": "walk_one_cm 每 4 格留 2s 镜影；6 个 marker + -8% movement_speed 修饰符（近似固定 8%）"},
]

BASE = [
    {"id": "base_zhao_xin",     "name": "照心·反射", "max": 0,  "status": "deferred",
     "why": "照心只给剑/斧；受击无攻击者/伤害量，只能近似最近怪"},
    {"id": "base_lie_ying",     "name": "裂影·影伤", "max": 0,  "status": "active",
     "why": "裂影只给剑/斧；命中 5% 概率追加 10% 影伤（与词条追加伤害合并为一次）"},
    {"id": "base_jing_hua",     "name": "镜花·绽放", "max": 0,  "status": "deferred",
     "why": "镜花只给弓/弩；箭矢命中无 tag 钩子，需 carrier effect 轮询"},
    {"id": "base_can_ying",     "name": "残影·弩机", "max": 0,  "status": "deferred",
     "why": "残影只给弓/弩；命中/射击时机不可精确观测"},
    {"id": "base_shuang_sheng","name": "双生·倒影阵", "max": 0, "status": "deferred",
     "why": "双生只给炉子；zfmain 可挂但主阵伤害直写 Health，无法复用实际伤害"},
    {"id": "base_ta_yin",       "name": "拓印·显影", "max": 0,  "status": "deferred",
     "why": "拓印只给炉子；zf 击杀不 credit 玩家，player_killed_entity 不触发"},
]

SKL = [
    # 照心镜剑
    ("ying_xin", 25), ("chi_jing", 15), ("fen_ying_ji", 25),
    ("fen_ying_shi", 15), ("ming_jing_zao", 3), ("jing_xin_su", 50),
    # 裂影镜斧
    ("lie_shen", 25), ("ying_zhong", 12), ("ying_chi", 5),
    ("lie_xu", 20), ("chong_ying_xu", 60), ("ying_sui_zhi", 8),
    # 镜花境弓
    ("jing_hua_tan", 40), ("jing_hua_bao", 8), ("shui_yue_kuan", 20),
    ("shui_yue_jiu", 50), ("hua_ying_su", 50), ("ying_shui_qiang", 15),
    # 残影镜弩
    ("liu_ying_jiu", 40), ("liu_ying_su", 25), ("ying_sui_duo", 40),
    ("ying_sui_qiang", 8), ("lian_ying_yi", 50), ("chong_ying_chuan", 20),
    # 双生镜炉
    ("dao_ying_qiang", 15), ("dao_ying_kuai", 30), ("jing_xia_jiu", 120),
    ("gong_ming_shang", 50), ("gong_ming_xiao", 15), ("shuang_sheng_qi", 12),
    # 拓印镜炉
    ("ta_yin_cheng", 15), ("ta_pian_shang", 30), ("ta_pian_qiang", 15),
    ("xian_ying_jiu", 30), ("zhao_yao_shen", 80), ("he_yin_sheng", 40),
]

DMG_IDS = [x["id"] for x in DMG]
FX_IDS = [x["id"] for x in FX]
BASE_IDS = [x["id"] for x in BASE]
SKL_IDS = [x[0] for x in SKL]

DEBUFF_PREDICATES = [
    ("poison", "minecraft:poison"),
    ("wither", "minecraft:wither"),
    ("blindness", "minecraft:blindness"),
    ("mining_fatigue", "minecraft:mining_fatigue"),
    ("nausea", "minecraft:nausea"),
    ("hunger", "minecraft:hunger"),
    ("levitation", "minecraft:levitation"),
    ("darkness", "minecraft:darkness"),
    ("bad_omen", "minecraft:bad_omen"),
    ("unluck", "minecraft:unluck"),
]


# ---------------------------------------------------------------------------
# 1. 记分板 / 常量
# ---------------------------------------------------------------------------
def gen_load_combat():
    lines = ["# 战斗上下文新增 objective（只在此文件 add；重复 add 会报错）"]
    objs = [
        ("mirror_game_time", "dummy"),
        ("mirror_tick20", "dummy"),
        ("mirror_last_combat", "dummy"),
        ("mirror_last_kill", "dummy"),
        ("mirror_fx_shi_ying_cd", "dummy"),
        ("mirror_fx_jing_xi_until", "dummy"),
        ("mirror_fx_jing_xi_done", "dummy"),
        ("mirror_fx_jing_xi_next", "dummy"),
        ("mirror_hit_seq", "dummy"),
        ("mirror_ctx_extra", "dummy"),
        ("mirror_ctx_hit", "dummy"),
        ("mirror_parse_ok", "dummy"),
        ("mirror_form", "dummy"),
        ("mirror_walk_stat", "minecraft.custom:minecraft.walk_one_cm"),
        ("mirror_walk_last", "dummy"),
        ("mirror_trail_until", "dummy"),
        ("mirror_trail_slow_until", "dummy"),
        ("mirror_trail_next", "dummy"),
        ("mirror_arrow_crit", "dummy"),
        ("mirror_arrow_damage", "dummy"),
        ("mirror_skill_until", "dummy"),
        ("mirror_last_hitter", "dummy"),
        ("mirror_xy_streak", "dummy"),
        ("mirror_xy_total", "dummy"),
        ("mirror_uid", "dummy"),
        ("mirror_uid_next", "dummy"),
        ("mirror_xu_target", "dummy"),
        ("mirror_xu_streak", "dummy"),
        ("mirror_last_wslot", "dummy"),
        ("mirror_hit_total", "dummy"),
        ("mirror_last_hit", "dummy"),
        ("mirror_jinghen_until", "dummy"),
        ("mirror_zhaoxi_until", "dummy"),
        ("wp_max", "dummy"),
        ("mirror_calc", "dummy"),
        ("wp_added", "dummy"),
        ("wp_cap", "dummy"),
        ("wp_full", "dummy"),
        ("wp_rr_n", "dummy"),
    ]
    objs += [("mirror_wtmp" if i == 1 else "mirror_wtmp%d" % i, "dummy") for i in range(1, 13)]
    for name, crit in objs:
        lines.append("scoreboard objectives add %s %s" % (name, crit))
    lines += [
        "",
        "# 战斗上下文临时值统一用 #wp 假玩家；12 个 mirror_wtmp 足够覆盖背照/镜径计算。",
        "# scoreboard players operation 的源必须是 <holder> <objective>，不能写数字字面量；常量放 mirror_calc。",
        "scoreboard players set #const2 mirror_calc 2",
        "scoreboard players set #const3 mirror_calc 3",
        "scoreboard players set #const4 mirror_calc 4",
        "scoreboard players set #const25 mirror_calc 25",
        "scoreboard players set #const6 mirror_calc 6",
        "scoreboard players set #const10 mirror_calc 10",
        "scoreboard players set #const100 mirror_calc 100",
        "scoreboard players set #const1000 mirror_calc 1000",
        "",
        "# 镜径轮转与目标 uid 的全局初值（未置 0 时第一次采样/第一次命中会被跳过）",
        "scoreboard players set #sys mirror_trail_next 0",
        "# uid 计数器不能在 /reload 时归零，否则新目标会与旧目标的 uid 冲突；只在未设置时初始化。",
        "execute unless score #sys mirror_uid_next matches -2147483648.. run scoreboard players set #sys mirror_uid_next 0",
    ]
    write_mc("load/combat.mcfunction", lines)


def gen_config_affix():
    lines = ["# 五纹 max 常量（设计文档 §6）。常规 actual×10 = max*val/10；jing_xi 的特例见 parse/apply。"]
    for cat, table in (("dmg", DMG), ("skl", [{"id": i, "max": m} for i, m in SKL]), ("fx", FX)):
        lines.append("")
        lines.append("# ---- %s ----" % cat.upper())
        for row in table:
            lines.append("scoreboard players set #max_%s_%s wp_max %d" % (cat, row["id"], row["max"]))
    write_mc("config/affix.mcfunction", lines)


# ---------------------------------------------------------------------------
# 2. parse / clear
# ---------------------------------------------------------------------------
def gen_parse_clear():
    lines = ["# 清零五纹解析结果。不重置 mirror_hit_seq / 冷却 / 目标计数（refresh 每 5t 会调用本函数）。"]
    for obj in ("wp_temper", "wp_set", "wp_dmg0", "wp_dmg1", "wp_dmg2",
                "wp_skl0", "wp_skl1", "wp_skl2", "wp_fx0",
                "wp_dmg_n", "wp_skl_n", "wp_fx_n",
                "mirror_temper", "mirror_set", "mirror_parse_ok", "mirror_ctx_extra"):
        lines.append("scoreboard players set @s %s 0" % obj)
    lines.append("scoreboard players set @s mirror_form -1")
    lines.append("")
    lines.append("# ---- 58 条词条 objective ----")
    for cat, ids in (("dmg", DMG_IDS), ("skl", SKL_IDS), ("fx", FX_IDS)):
        for aid in ids:
            lines.append("scoreboard players set @s wp_affix_%s_%s 0" % (cat, aid))
    write_mc("parse/clear.mcfunction", lines)


def gen_parse_form():
    lines = [
        "# 器形编码：0 剑 / 1 斧 / 2 弓 / 3 弩 / 4 双生炉 / 5 拓印炉 / -1 未知",
        "scoreboard players set @s mirror_form -1",
    ]
    for item, code in (
        ("panling:mirror_sword7", 0),
        ("panling:mirror_axe7", 1),
        ("panling:mirror_bow7", 2),
        ("panling:mirror_crossbow7", 3),
        ("panling:mirror_furnace_twin7", 4),
        ("panling:mirror_furnace_rub7", 5),
    ):
        lines.append('execute if data storage plm:weapon item.tag{id:"%s"} run scoreboard players set @s mirror_form %d' % (item, code))
    write_mc("parse/form.mcfunction", lines)


def _affix_line(cat, aid):
    return ('execute if data storage plm:weapon item.tag.mirror_%s[{id:"%s"}] '
            'store result score @s wp_affix_%s_%s '
            'run data get storage plm:weapon item.tag.mirror_%s[{id:"%s"}].val'
            % (cat, aid, cat, aid, cat, aid))


def _affix_convert(cat, aid):
    # 常规：actual×10 = max * val / 10
    # jing_xi 的 max 是 0.5%/s，无法用整数百分点表示：max 常量取 5（=0.5%×10），
    # 因此 conversion 用 /100 得到 5（val=100），而非常规 /10（会得到 50 = 5%）。
    div = 100 if (cat == "fx" and aid == "jing_xi") else 10
    const = "#const100" if div == 100 else "#const10"
    return [
        "execute if score @s wp_affix_%s_%s matches 1.. run scoreboard players operation @s wp_affix_%s_%s *= #max_%s_%s wp_max"
        % (cat, aid, cat, aid, cat, aid),
        "execute if score @s wp_affix_%s_%s matches 1.. run scoreboard players operation @s wp_affix_%s_%s /= %s mirror_calc"
        % (cat, aid, cat, aid, const),
    ]


def gen_parse_apply():
    lines = [
        "# 输入：storage plm:weapon item（完整物品 compound，含 tag）",
        "# 输出：@s 的 wp_* / wp_affix_* / mirror_form / mirror_temper / mirror_set / mirror_parse_ok",
        "function plm:weapon/parse/clear",
        "execute unless data storage plm:weapon item.tag{mirror:1} run return 0",
        "execute unless data storage plm:weapon item.tag{mirror_ver:2} run return 0",
        "",
        "execute store result score @s wp_temper run data get storage plm:weapon item.tag.mirror_temper",
        "execute store result score @s wp_set run data get storage plm:weapon item.tag.mirror_set",
        "scoreboard players operation @s mirror_temper = @s wp_temper",
        "scoreboard players operation @s mirror_set = @s wp_set",
        "function plm:weapon/parse/form",
        "",
        "# ---- 条数 ----",
    ]
    for cat, n in (("dmg", 3), ("skl", 3), ("fx", 1)):
        for i in range(n):
            lines.append("execute if data storage plm:weapon item.tag.mirror_%s[%d] run scoreboard players add @s wp_%s_n 1" % (cat, i, cat))
    lines.append("")
    lines.append("# ---- 原始 val（50..100，用于 lore/身份）----")
    for cat, n in (("dmg", 3), ("skl", 3), ("fx", 1)):
        for i in range(n):
            lines.append("execute if data storage plm:weapon item.tag.mirror_%s[%d] store result score @s wp_%s%d run data get storage plm:weapon item.tag.mirror_%s[%d].val" % (cat, i, cat, i, cat, i))
    lines.append("")
    lines.append("# ---- 58 条：存在则写 val，再转 actual×10 ----")
    for cat, ids in (("dmg", DMG_IDS), ("skl", SKL_IDS), ("fx", FX_IDS)):
        lines.append("# %s" % cat.upper())
        for aid in ids:
            lines.append(_affix_line(cat, aid))
            lines.extend(_affix_convert(cat, aid))
        lines.append("")
    lines += [
        "scoreboard players set @s mirror_parse_ok 1",
        "tag @s add mirror_weapon_active",
        "",
        "# 续影状态只在未设置时初始化；parse/apply 会被 refresh 反复调用，不能在这里清零。",
        "execute unless score @s mirror_xu_streak matches -2147483648.. run scoreboard players set @s mirror_xu_streak 0",
        "execute unless score @s mirror_xu_target matches -2147483648.. run scoreboard players set @s mirror_xu_target 0",
        "",
        "# 记录本次解析对应的武器槽；tick/refresh 只在该槽变化时重解析（设计 §10.3 parse 只做一次）。",
        "execute if score @s WeaponSlot matches -2147483648.. run scoreboard players operation @s mirror_last_wslot = @s WeaponSlot",
    ]
    write_mc("parse/apply.mcfunction", lines)


def gen_parse():
    lines = [
        "# 激活入口。上下文：@s=玩家，位置在玩家，待激活物品在本体 equipment_lock 的 ~ 255 ~ chest Items[0]。",
        "# 本体在 enable/main.mcfunction:22 无条件调用 #pld:weapon_unlock/enchant（type:1），本函数挂在那个标签里。",
        "data modify storage plm:weapon item set value {}",
        "execute if data block ~ 255 ~ Items[0] run data modify storage plm:weapon item set from block ~ 255 ~ Items[0]",
        "execute unless data storage plm:weapon item.tag{mirror:1} run function plm:weapon/clear",
        "# 激活的是非镜武时，不要把玩家另一槽位仍生效的镜武一并清掉：按当前 WeaponSlot 重解析。",
        "execute unless data storage plm:weapon item.tag{mirror:1} run function plm:weapon/refresh",
        "execute if data storage plm:weapon item.tag{mirror:1} run function plm:weapon/parse/apply",
        "",
        "# 重新激活时把镜径采样基准对齐到当前 walk_one_cm",
        "execute if data storage plm:weapon item.tag{mirror:1} run scoreboard players set @s mirror_walk_last 0",
        "execute if data storage plm:weapon item.tag{mirror:1} run execute store result score @s mirror_walk_last run scoreboard players get @s mirror_walk_stat",
    ]
    write_mc("parse.mcfunction", lines)


def gen_parse_hand():
    lines = [
        "# 开发/测试：解析主手 SelectedItem → 玩家记分板（与 parse/apply 共用同一实现）",
        "data modify storage plm:weapon item set value {}",
        "execute if data entity @s SelectedItem run data modify storage plm:weapon item set from entity @s SelectedItem",
        "execute unless data storage plm:weapon item.tag{mirror:1} run function plm:weapon/clear",
        "# 激活的是非镜武时，不要把玩家另一槽位仍生效的镜武一并清掉：按当前 WeaponSlot 重解析。",
        "execute unless data storage plm:weapon item.tag{mirror:1} run function plm:weapon/refresh",
        "execute if data storage plm:weapon item.tag{mirror:1} run function plm:weapon/parse/apply",
        "execute if data storage plm:weapon item.tag{mirror:1} run scoreboard players set @s mirror_walk_last 0",
        "execute if data storage plm:weapon item.tag{mirror:1} run execute store result score @s mirror_walk_last run scoreboard players get @s mirror_walk_stat",
    ]
    write_mc("parse_hand.mcfunction", lines)


def gen_clear():
    lines = [
        "# 卸下/非镜武：清空五纹解析并移除激活标记。保留全局击杀/战斗时间戳。",
        "function plm:weapon/parse/clear",
        "tag @s remove mirror_weapon_active",
        "tag @s remove mirror_skill_active",
        "scoreboard players set @s mirror_hit_seq 0",
        "scoreboard players set @s mirror_ctx_extra 0",
        "scoreboard players set @s mirror_walk_last 0",
        "# 续影是「对同一玩家连续命中」的状态；换下武器即中断连击。",
        "scoreboard players set @s mirror_xu_streak 0",
        "scoreboard players set @s mirror_xu_target 0",
        "# 镜息是武器特效：换下武器后重置本轮窗口，重新装备不会继承 done=1。",
        "scoreboard players set @s mirror_fx_jing_xi_until 0",
        "scoreboard players set @s mirror_fx_jing_xi_done 0",
        "scoreboard players set @s mirror_fx_jing_xi_next 0",
    ]
    write_mc("clear.mcfunction", lines)


def gen_refresh():
    lines = [
        "# 事件驱动的重解析：由 activation、WeaponSlot 变化、镜武 inventory_changed 触发。",
        "# 本函数自己不做周期性节流；tick/refresh 只在槽位变化时调用它。",
        "data modify storage plm:weapon item set value {}",
    ]
    for slot in range(1, 10):
        lines.append("execute if score @s WeaponSlot matches %d run data modify storage plm:weapon item set from entity @s Inventory[{Slot:%db}]" % (slot, slot - 1))
    lines.append("execute if score @s WeaponSlot matches -1 run data modify storage plm:weapon item set from entity @s Inventory[{Slot:-106b}]")
    lines.append("execute unless score @s WeaponSlot matches -1..9 run data modify storage plm:weapon item set from entity @s SelectedItem")
    lines += [
        "execute unless data storage plm:weapon item.tag{mirror:1,act:1} run function plm:weapon/clear",
        "execute if data storage plm:weapon item.tag{mirror:1,act:1} run function plm:weapon/parse/apply",
        "# 记录已解析的槽位；下次 tick/refresh 只有 WeaponSlot 变化才重解析。",
        "execute if score @s WeaponSlot matches -2147483648.. run scoreboard players operation @s mirror_last_wslot = @s WeaponSlot",
    ]
    write_mc("refresh.mcfunction", lines)


def gen_refresh_check():
    lines = [
        "# 每 5t 检查当前生效槽位。丢出最后一把镜武时 inventory_changed 不会触发",
        "# （conditions.items 要求仍有 mirror 物品），所以必须直接读槽位物品并 clear。",
        "data modify storage plm:weapon item set value {}",
    ]
    for slot in range(1, 10):
        lines.append("execute if score @s WeaponSlot matches %d run data modify storage plm:weapon item set from entity @s Inventory[{Slot:%db}]" % (slot, slot - 1))
    lines.append("execute if score @s WeaponSlot matches -1 run data modify storage plm:weapon item set from entity @s Inventory[{Slot:-106b}]")
    lines.append("execute unless score @s WeaponSlot matches -1..9 run data modify storage plm:weapon item set from entity @s SelectedItem")
    lines += [
        "execute unless data storage plm:weapon item.tag{mirror:1,act:1} run function plm:weapon/clear",
        "execute if score @s WeaponSlot matches -2147483648.. if data storage plm:weapon item.tag{mirror:1,act:1} unless score @s mirror_last_wslot = @s WeaponSlot run function plm:weapon/refresh",    ]
    write_mc("refresh/check.mcfunction", lines)


def gen_refresh_hook():
    lines = [
        "# 挂在 plm:weapon/inventory_changed 进度 reward：镜武进入/离开/改写了玩家背包时标记重解析。",
        "# 不在这里直接 refresh：inventory_changed 可能在磨镜台 item replace 命令内部同步触发，",
        "# 此时 storage plm:weapon 正被台子流程使用；延迟 1t 到 pending 里处理，避免重入覆盖。",
        "advancement revoke @s only plm:weapon/inventory_changed",
        "tag @s add mirror_refresh_pending",
        "schedule function plm:weapon/refresh/pending 1t replace",
    ]
    write_mc("refresh/hook.mcfunction", lines)

    lines = [
        "# 1t 后统一处理被 inventory_changed 标记的玩家（schedule replace 会合并同一 tick 的多次变化）。",
        "execute as @a[tag=mirror_refresh_pending] run function plm:weapon/refresh",
        "tag @a[tag=mirror_refresh_pending] remove mirror_refresh_pending",
    ]
    write_mc("refresh/pending.mcfunction", lines)


def gen_bootstrap():
    lines = [
        "# 20t 一次：吸收“DLC 加入前就已激活/ghost tag 丢失”的镜武，避免必须重新换装。",
        "execute as @a[tag=!mirror_weapon_active] if data entity @s SelectedItem.tag{mirror:1,act:1} run function plm:weapon/parse_hand",
    ]
    write_mc("tick/bootstrap.mcfunction", lines)


# ---------------------------------------------------------------------------
# 3. 战斗上下文
# ---------------------------------------------------------------------------
def gen_ctx_melee():
    lines = [
        "# 挂在 #pld:attack_damage/multiply_base（body multiply_base 之后）。",
        "# 上下文：@s=攻击玩家；warrior_tag 已被 check.mcfunction:2-5 标出；伤害尚未结算（check:26 才结算）。",
        "# 这里只做三件事：",
        "#   1) 自状态词条直接加 #attack_damage_multiply_base（同类相加）",
        "#   2) 目标条件词条在伤害结算前读取目标状态，把“本次追加百分比×10”存进 @s mirror_ctx_extra",
        "#   3) on_hit 用 mirror_ctx_extra 做一次带 mirror_affix_damage 的追加伤害",
        "execute unless entity @s[tag=mirror_weapon_active] run return 0",
        "execute unless score @s mirror_parse_ok matches 1 run return 0",
        "execute unless score @s mirror_form matches 0..1 run return 0",
        "execute unless data entity @s SelectedItem.tag{mirror:1,act:1} run return 0",
        "# 本体 attribute/update 对所有职业调用 multiply_base，但 job0/on_hit 只在 job=0 执行；这里显式守卫。",
        "execute unless score @s job matches 0 run return 0",
        "execute unless entity @e[tag=warrior_tag,limit=1] run return 0",
        "",
        "# 目标选择 API：warrior_tag 优先；伤害路径不许走 fallback，故这里先确认 warrior_tag 存在。",
        "function plm:weapon/ctx/target",
        "",
        "# 续影：在伤害结算前确定本次目标；切换目标立即清零，避免新目标第一击吃到旧层数。",
        "execute if entity @e[tag=plm_ctx_target,limit=1] unless score @e[tag=plm_ctx_target,limit=1] mirror_uid matches 1.. run scoreboard players add #sys mirror_uid_next 1",
        "execute if entity @e[tag=plm_ctx_target,limit=1] unless score @e[tag=plm_ctx_target,limit=1] mirror_uid matches 1.. run scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_uid = #sys mirror_uid_next",
        "execute if entity @e[tag=plm_ctx_target,limit=1] unless score @s mirror_xu_target = @e[tag=plm_ctx_target,limit=1] mirror_uid run scoreboard players set @s mirror_xu_streak 0",
        "execute if entity @e[tag=plm_ctx_target,limit=1] run scoreboard players operation @s mirror_xu_target = @e[tag=plm_ctx_target,limit=1] mirror_uid",
        "",
        "scoreboard players set @s mirror_ctx_extra 0",
        "scoreboard players set @e[tag=plm_ctx_target,limit=1] mirror_ctx_hit 0",
    ]
    for row in DMG:
        lines.append("function plm:weapon/dmg/melee/%s" % row["id"])
    write_mc("ctx/melee.mcfunction", lines)


def gen_ctx_archer():
    lines = [
        "# 挂在 #pld:archer_damage/multiply_base（射出时、archer_damage/update 内）。",
        "# 此时没有目标，只能接自状态词条：逆鳞、余响。目标条件词条在弓/弩侧 Phase 1 deferred。",
        "# 显式 job=1 守卫：本体 archer_damage/update 本身不检查职业，不能只依赖 mirror_form。",
        "execute unless score @s job matches 1 run return 0",
        "execute unless entity @s[tag=mirror_weapon_active] run return 0",
        "execute unless score @s mirror_parse_ok matches 1 run return 0",
        "execute unless score @s mirror_form matches 2..3 run return 0",
        "execute unless data entity @s SelectedItem.tag{mirror:1,act:1} run return 0",
        "function plm:weapon/dmg/archer/ni_lin",
        "function plm:weapon/dmg/archer/yu_xiang",
    ]
    write_mc("ctx/archer.mcfunction", lines)


def gen_ctx_arrow():
    lines = [
        "# 挂在 #pld:archer/the_arrow（set_damage.mcfunction:22）。",
        "# 上下文：@s=箭，@p[tag=shooter]=射手。set_damage:6-10 已写 damage 并按 weapon_arrow_crit 处理 crit。",
        "# Phase 1 只做上下文快照（暴击/箭伤标记），不实现镜隙 DMG（设计 v1 停用）。",
        "execute unless entity @p[tag=shooter] run return 0",
        "execute unless entity @p[tag=shooter,tag=mirror_weapon_active] run return 0",
        "execute unless score @p[tag=shooter] mirror_form matches 2..3 run return 0",
        "execute unless data entity @p[tag=shooter] SelectedItem.tag{mirror:1,act:1} run return 0",
        "tag @s add mirror_arrow",
        "scoreboard players set @p[tag=shooter] mirror_arrow_crit 0",
        "execute store result score @p[tag=shooter] mirror_arrow_crit run data get entity @s crit",
        "execute store result score @p[tag=shooter] mirror_arrow_damage run data get entity @s damage 100",
        "scoreboard players operation @p[tag=shooter] mirror_last_combat = #sys mirror_game_time",
    ]
    write_mc("ctx/arrow.mcfunction", lines)


def gen_ctx_skill():
    lines = [
        "# 挂在 #pld:equipment_lock/when_weapon_skill_enable（本体技能/阵法启用瞬间）。",
        "# Phase 1 没有镜武技能；这里只记录上下文，供 Phase 2 的映刃/素锋使用，不产生任何伤害或 buff。",
        "execute unless entity @s[tag=mirror_weapon_active] run return 0",
        "execute unless data entity @s SelectedItem.tag{mirror:1,act:1} run return 0",
        "tag @s add mirror_skill_active",
        "scoreboard players operation @s mirror_skill_until = #sys mirror_game_time",
        "scoreboard players add @s mirror_skill_until 20",
    ]
    write_mc("ctx/skill.mcfunction", lines)



def gen_ctx_target():
    lines = [
        "# 目标选择 API：warrior_tag 优先；否则 5 格内最近 tag=monster，再否则 tag=mirror_boss。",
        "# 结果写在实体 tag plm_ctx_target 上；ctx/melee、on_hit、target_hp、target_behind 都消费它。",
        "# 注意：伤害路径（ctx/melee、on_hit）在调用前先要求 warrior_tag 存在，因此不会用到 fallback；",
        "# fallback 只服务于非伤害的上下文查询（Phase 2 FX/技能）。",
        "tag @e[tag=plm_ctx_target] remove plm_ctx_target",
        "execute if entity @e[tag=warrior_tag,limit=1] run tag @e[tag=warrior_tag,limit=1] add plm_ctx_target",
        "execute unless entity @e[tag=plm_ctx_target] at @s run tag @e[tag=monster,distance=..5,sort=nearest,limit=1] add plm_ctx_target",
        "execute unless entity @e[tag=plm_ctx_target] at @s run tag @e[tag=mirror_boss,distance=..5,sort=nearest,limit=1] add plm_ctx_target",
    ]
    write_mc("ctx/target.mcfunction", lines)

def gen_target_hp():
    lines = [
        "# 输出 #wp mirror_wtmp = 目标生命百分比（0..100，整数）。@s=玩家，目标为 plm_ctx_target。",
        "scoreboard players set #wp mirror_wtmp 0",
        "execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0",
        "scoreboard players set #wp mirror_wtmp2 0",
        "scoreboard players set #wp mirror_wtmp3 0",
        "execute store result score #wp mirror_wtmp2 run data get entity @e[tag=plm_ctx_target,limit=1] Health 1000",
        "execute store result score #wp mirror_wtmp3 run attribute @e[tag=plm_ctx_target,limit=1] generic.max_health get 1000",
        "execute if entity @e[tag=plm_ctx_target,tag=mirror_arena_boss,limit=1] run scoreboard players operation #wp mirror_wtmp2 = #boss mirror_boss_hp",
        "execute if entity @e[tag=plm_ctx_target,tag=mirror_arena_boss,limit=1] run scoreboard players operation #wp mirror_wtmp3 = #boss mirror_boss_max",
        "execute unless score #wp mirror_wtmp3 matches 1.. run return 0",
        "scoreboard players operation #wp mirror_wtmp = #wp mirror_wtmp2",
        "scoreboard players operation #wp mirror_wtmp *= #const100 mirror_calc",
        "scoreboard players operation #wp mirror_wtmp /= #wp mirror_wtmp3",
    ]
    write_mc("ctx/target_hp.mcfunction", lines)


def gen_target_behind():
    lines = [
        "# 输出 #wp mirror_wtmp10 = 1 表示「攻击者位于目标的水平背后 120° 锥内」（设计 §6.1 背照）。",
        "# 参考系是目标：origin=目标位置，facing=目标朝向；比较 facing 与 (玩家-目标) 的夹角。",
        "# 条件等价于 dot<0 且 cos<-0.5：4*dot^2 > |f|^2*dist^2；坐标用 0.1 格定点（scale 10），忽略 Y。",
        "scoreboard players set #wp mirror_wtmp10 0",
        "execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0",
        "kill @e[type=minecraft:marker,tag=plm_weapon_calc,distance=..64]",
        "# 在目标前方 1 格（水平）放 marker：用目标的 yaw，pitch 归零。",
        "execute at @e[tag=plm_ctx_target,limit=1] rotated as @e[tag=plm_ctx_target,limit=1] rotated ~ 0 run summon minecraft:marker ~ ~ ~ {Tags:[\"plm_weapon_calc\"]}",
        "execute at @e[tag=plm_ctx_target,limit=1] rotated as @e[tag=plm_ctx_target,limit=1] rotated ~ 0 run tp @e[type=minecraft:marker,tag=plm_weapon_calc,distance=..64,limit=1] ^ ^ ^1",
        "",
        "# 原点 = 目标坐标",
        "execute store result score #wp mirror_wtmp2 run data get entity @e[tag=plm_ctx_target,limit=1] Pos[0] 10",
        "execute store result score #wp mirror_wtmp3 run data get entity @e[tag=plm_ctx_target,limit=1] Pos[2] 10",
        "# 目标前方向量 = marker - 目标",
        "execute store result score #wp mirror_wtmp4 run data get entity @e[type=minecraft:marker,tag=plm_weapon_calc,distance=..64,limit=1] Pos[0] 10",
        "execute store result score #wp mirror_wtmp5 run data get entity @e[type=minecraft:marker,tag=plm_weapon_calc,distance=..64,limit=1] Pos[2] 10",
        "scoreboard players operation #wp mirror_wtmp4 -= #wp mirror_wtmp2",
        "scoreboard players operation #wp mirror_wtmp5 -= #wp mirror_wtmp3",
        "kill @e[type=minecraft:marker,tag=plm_weapon_calc,distance=..64]",
        "",
        "# 玩家相对目标的向量",
        "execute store result score #wp mirror_wtmp6 run data get entity @s Pos[0] 10",
        "execute store result score #wp mirror_wtmp7 run data get entity @s Pos[2] 10",
        "scoreboard players operation #wp mirror_wtmp6 -= #wp mirror_wtmp2",
        "scoreboard players operation #wp mirror_wtmp7 -= #wp mirror_wtmp3",
        "",
        "# dot = fx*dx + fz*dz",
        "scoreboard players operation #wp mirror_wtmp = #wp mirror_wtmp4",
        "scoreboard players operation #wp mirror_wtmp *= #wp mirror_wtmp6",
        "scoreboard players operation #wp mirror_wtmp8 = #wp mirror_wtmp5",
        "scoreboard players operation #wp mirror_wtmp8 *= #wp mirror_wtmp7",
        "scoreboard players operation #wp mirror_wtmp += #wp mirror_wtmp8",
        "",
        "# dist2 = dx*dx + dz*dz",
        "scoreboard players operation #wp mirror_wtmp8 = #wp mirror_wtmp6",
        "scoreboard players operation #wp mirror_wtmp8 *= #wp mirror_wtmp6",
        "scoreboard players operation #wp mirror_wtmp9 = #wp mirror_wtmp7",
        "scoreboard players operation #wp mirror_wtmp9 *= #wp mirror_wtmp7",
        "scoreboard players operation #wp mirror_wtmp8 += #wp mirror_wtmp9",
        "",
        "# 条件：dot<0 且 4*dot^2 > |f|^2 * dist2 = 100 * dist2（|f|=10）",
        "execute if score #wp mirror_wtmp matches ..-1 run scoreboard players operation #wp mirror_wtmp11 = #wp mirror_wtmp",
        "execute if score #wp mirror_wtmp matches ..-1 run scoreboard players operation #wp mirror_wtmp11 *= #wp mirror_wtmp",
        "execute if score #wp mirror_wtmp matches ..-1 run scoreboard players operation #wp mirror_wtmp11 *= #const4 mirror_calc",
        "execute if score #wp mirror_wtmp matches ..-1 run scoreboard players operation #wp mirror_wtmp8 *= #const100 mirror_calc",
        "execute if score #wp mirror_wtmp matches ..-1 if score #wp mirror_wtmp11 > #wp mirror_wtmp8 run scoreboard players set #wp mirror_wtmp10 1",
        "kill @e[type=minecraft:marker,tag=plm_weapon_calc,distance=..64]",
    ]
    write_mc("ctx/target_behind.mcfunction", lines)


# ---------------------------------------------------------------------------
# 4. DMG 分支
# ---------------------------------------------------------------------------
def _add_self_mult(aid):
    return [
        "scoreboard players operation #wp mirror_wtmp = @s wp_affix_dmg_%s" % aid,
        "scoreboard players operation #wp mirror_wtmp /= #const10 mirror_calc",
        "scoreboard players operation #attack_damage_multiply_base int += #wp mirror_wtmp",
    ]


def _add_archer_mult(aid):
    return [
        "scoreboard players operation #wp mirror_wtmp = @s wp_affix_dmg_%s" % aid,
        "scoreboard players operation #wp mirror_wtmp /= #const10 mirror_calc",
        "scoreboard players operation @s archer_damage_l6 += #wp mirror_wtmp",
    ]


def _add_ctx(aid):
    return [
        "scoreboard players operation @s mirror_ctx_extra += @s wp_affix_dmg_%s" % aid,
    ]


def gen_dmg_melee():
    out = {}
    for row in DMG:
        aid = row["id"]
        lines = ["# %s（%s）— %s" % (row["name"], aid, row["status"]), "# " + row["why"]]
        if row["status"] == "self":
            lines += [
                "execute unless score @s wp_affix_dmg_%s matches 1.. run return 0" % aid,
            ]
            if aid == "ni_lin":
                lines += ["execute unless score @s hp_precent matches ..39 run return 0"]
            elif aid == "yu_xiang":
                lines += [
                    "execute unless score @s mirror_last_kill matches 1.. run return 0",
                    "scoreboard players operation #wp mirror_wtmp2 = #sys mirror_game_time",
                    "scoreboard players operation #wp mirror_wtmp2 -= @s mirror_last_kill",
                    "execute unless score #wp mirror_wtmp2 matches 0..60 run return 0",
                ]
            elif aid == "lian_xing":
                lines += [
                    "execute unless score @s mirror_hit_seq matches 2 run return 0",
                ]
            lines += _add_self_mult(aid)
        elif row["status"] == "target":
            lines += [
                "execute unless score @s wp_affix_dmg_%s matches 1.. run return 0" % aid,
            ]
            if aid == "po_xiao":
                lines += [
                    "function plm:weapon/ctx/target_hp",
                    "execute unless score #wp mirror_wtmp matches 90.. run return 0",
                ]
            elif aid == "xu_ying":
                lines += [
                    "# 续影层数按玩家记录（mirror_xu_streak），由 on_hit 在命中后维护；",
                    "# 切换目标时 on_hit 会把层数清零，因此 A→B→A 不会保留 A 的旧层数。",
                    "scoreboard players set #wp mirror_wtmp 0",
                    "scoreboard players operation #wp mirror_wtmp = @s mirror_xu_streak",
                    "scoreboard players operation #wp mirror_wtmp *= @s wp_affix_dmg_xu_ying",
                    "scoreboard players operation @s mirror_ctx_extra += #wp mirror_wtmp",
                ]
                out[aid] = lines
                continue
            elif aid == "zhui_ying":
                lines += [
                    "scoreboard players set @e[tag=plm_ctx_target,limit=1] mirror_ctx_hit 0",
                    "execute as @e[tag=plm_ctx_target,limit=1] if predicate pld:effect_check/slowness run scoreboard players set @s mirror_ctx_hit 1",
                    "# 本体 sword3 的眩晕状态：vertigo_5ticks（warrior_attack/load.mcfunction:3 声明）。",
                    "execute if entity @e[tag=plm_ctx_target,limit=1,scores={vertigo_5ticks=1..}] run scoreboard players set @e[tag=plm_ctx_target,limit=1] mirror_ctx_hit 1",
                    "# 「被标记」在 Phase 1 没有来源（镜痕/照隙均 deferred），不再保留死分支。",
                    "execute unless score @e[tag=plm_ctx_target,limit=1] mirror_ctx_hit matches 1 run return 0",
                ]
            elif aid == "bei_zhao":
                lines += [
                    "function plm:weapon/ctx/target_behind",
                    "execute unless score #wp mirror_wtmp10 matches 1 run return 0",
                ]
            elif aid == "shuang_zhao":
                lines += [
                    "scoreboard players set #wp mirror_wtmp 0",
                    "execute as @e[tag=plm_ctx_target,limit=1] if predicate pld:effect_check/slowness run scoreboard players add #wp mirror_wtmp 1",
                    "execute as @e[tag=plm_ctx_target,limit=1] if predicate pld:effect_check/weakness run scoreboard players add #wp mirror_wtmp 1",
                ]
                for key, _ in DEBUFF_PREDICATES:
                    lines.append("execute as @e[tag=plm_ctx_target,limit=1] if predicate plm:effect/%s run scoreboard players add #wp mirror_wtmp 1" % key)
                lines.append("execute unless score #wp mirror_wtmp matches 2.. run return 0")
            elif aid == "jing_shu":
                lines += [
                    "execute unless score @e[tag=plm_ctx_target,limit=1] mirror_xy_total matches 10.. run return 0",
                ]
            lines += _add_ctx(aid)
        else:
            lines += ["# deferred/disabled：不产生任何效果。", "return 0"]
        out[aid] = lines
    for aid, lines in out.items():
        write_mc("dmg/melee/%s.mcfunction" % aid, lines)


def gen_dmg_archer():
    for row in DMG:
        aid = row["id"]
        if row["status"] == "self" and aid in ("ni_lin", "yu_xiang"):
            lines = ["# %s（%s）— 弓/弩自状态词条" % (row["name"], aid), "# " + row["why"]]
            lines.append("execute unless score @s wp_affix_dmg_%s matches 1.. run return 0" % aid)
            if aid == "ni_lin":
                lines.append("execute unless score @s hp_precent matches ..39 run return 0")
            else:
                lines += [
                    "execute unless score @s mirror_last_kill matches 1.. run return 0",
                    "scoreboard players operation #wp mirror_wtmp2 = #sys mirror_game_time",
                    "scoreboard players operation #wp mirror_wtmp2 -= @s mirror_last_kill",
                    "execute unless score #wp mirror_wtmp2 matches 0..60 run return 0",
                ]
            lines += _add_archer_mult(aid)
        else:
            why = row["why"]
            if row["status"] == "target":
                why += "；弓/弩射出时没有目标，命中侧无 tag 钩子 → Phase 1 deferred（见 recon.deferred）。"
            elif row["status"] == "self":
                why += "；弓/弩侧只能在射出时计数，射出不等于命中 → Phase 1 deferred。"
            lines = ["# %s（%s）— deferred（弓/弩侧）" % (row["name"], aid), "# " + why, "return 0"]
        write_mc("dmg/archer/%s.mcfunction" % aid, lines)


# ---------------------------------------------------------------------------
# 5. 命中后追加伤害
# ---------------------------------------------------------------------------
def gen_on_hit():
    lines = [
        "# 挂在 #pld:warrior/when_hurt_entity（job0.mcfunction:18）。",
        "# 上下文：@s=玩家；warrior_tag 仍在（check:37 才清）；#temp player_cause_1damage = attack_damage1（×10 定点）。",
        "# 目标条件词条已在 ctx/melee 里按伤害结算前的目标状态累加进 @s mirror_ctx_extra（百分比×10）。",
        "execute if entity @s[tag=mirror_affix_damage] run return 0",
        "execute unless entity @s[tag=mirror_weapon_active] run return 0",
        "execute unless score @s mirror_parse_ok matches 1 run return 0",
        "execute unless data entity @s SelectedItem.tag{mirror:1,act:1} run return 0",
        "execute unless entity @e[tag=warrior_tag,limit=1] run return 0",
        "",
        "# 目标选择 API（warrior_tag 优先；伤害路径的 fallback 被上面的守卫排除）",
        "function plm:weapon/ctx/target",
        "execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0",
        "",
        "# 裂影基底：5% 概率 +10% 影伤（与五纹追加伤害合并成一次，避免多次触发 when_cause_damage）",
        "function plm:weapon/base/base_lie_ying",
        "",
        "# 追加伤害：mirror_ctx_extra 单位 = 百分点×10；extra_apply 内部换算成 100/HP 定点。",
        "execute if score @s mirror_ctx_extra matches 1.. run function plm:weapon/dmg/extra_apply",
        "scoreboard players set @s mirror_ctx_extra 0",
        "",
        "# 目标计数（续影/镜熟；镜痕/照隙的 objective 先留好，Phase 1 不消费）",
        "scoreboard players operation #wp mirror_wtmp = @s player_uid",
        "execute as @e[tag=plm_ctx_target,limit=1] run function plm:weapon/on_hit/mark",
        "",
        "# 续影：切换目标清零。以目标 mirror_uid 判定「同一目标」；层数在本次命中后递增。",
        "# 目标被追加伤害击杀时实体已不存在，必须清空玩家状态，否则下一击会把旧层数带过去。",
        "execute unless entity @e[tag=plm_ctx_target,limit=1] run scoreboard players set @s mirror_xu_streak 0",
        "execute unless entity @e[tag=plm_ctx_target,limit=1] run scoreboard players set @s mirror_xu_target 0",
        "execute if entity @e[tag=plm_ctx_target,limit=1] run scoreboard players operation #wp mirror_wtmp2 = @e[tag=plm_ctx_target,limit=1] mirror_uid",
        "execute if entity @e[tag=plm_ctx_target,limit=1] unless score @s mirror_xu_target = #wp mirror_wtmp2 run scoreboard players set @s mirror_xu_streak 0",
        "execute if entity @e[tag=plm_ctx_target,limit=1] run scoreboard players operation @s mirror_xu_target = #wp mirror_wtmp2",
        "execute if entity @e[tag=plm_ctx_target,limit=1] if score @s mirror_xu_streak matches ..2 run scoreboard players add @s mirror_xu_streak 1",
        "",
        "# 连星：每次成功近战 +1，3 次一循环（ctx 读 seq==2 时为第 3 击）",
        "scoreboard players add @s mirror_hit_seq 1",
        "execute if score @s mirror_hit_seq matches 3.. run scoreboard players set @s mirror_hit_seq 0",
        "scoreboard players operation @s mirror_last_combat = #sys mirror_game_time",
        "",
        "# 裂影斧：裂痕层数 + 重影影伤队列",
        "execute if score @s mirror_form matches 1 run function plm:weapon/axe/lie_hit",
        "execute if score @s mirror_form matches 1 if score @s mirror_chongying_5ticks matches 1.. run function plm:weapon/axe/chongying/on_hit",
        "# 照心剑：踏影 buff 期间的额外镜伤 / 加成",
        "execute if score @s mirror_form matches 0 if score @s mirror_taying_buff matches 1.. run function plm:mirror/skill/sword/on_hit",
    ]
    write_mc("on_hit.mcfunction", lines)


def gen_on_hit_mark():
    lines = [
        "# @s=被命中目标；#wp mirror_wtmp=攻击者 player_uid。",
        "# 目标 uid 单调递增，用于「同一目标」判定（续影）；已设置过的目标不重复分配。",
        "execute unless score @s mirror_uid matches 1.. run scoreboard players add #sys mirror_uid_next 1",
        "execute unless score @s mirror_uid matches 1.. run scoreboard players operation @s mirror_uid = #sys mirror_uid_next",
        "scoreboard players add @s mirror_xy_total 1",
        "scoreboard players add @s mirror_hit_total 1",
        "scoreboard players operation @s mirror_last_hit = #sys mirror_game_time",
    ]
    write_mc("on_hit/mark.mcfunction", lines)


def gen_extra():
    lines = [
        "# 输入：@s=玩家，@s mirror_ctx_extra=目标条件词条合计（百分点×10），",
        "#       #temp player_cause_1damage=attack_damage1（×10，已含 multiply_base），",
        "#       attack_multiplier（本体攻速/冷却倍率，100=满速），#attack_damage_multiply_base（百分点）。",
        "# 设计 §6.1 要求「同类相加 1+Σ」：main hit 已含 (1+M)，追加部分只能按 base×P 计，",
        "# 因此先除以 (100+M) 还原 base，再乘 P/1000，最后乘 cooldown 倍率 attack_multiplier/100。",
        "# 输出：#temp entity_hurt_temp（2 位小数，100=1HP）。",
        "execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0",
        "execute unless score #temp player_cause_1damage matches 1.. run return 0",
        "execute unless score @s mirror_ctx_extra matches 1.. run return 0",
        "",
        "# base = attack_damage1 * 100 / (100+M)；extra = base * P/1000 = attack_damage1*P/(100+M)",
        "scoreboard players set #wp mirror_wtmp2 0",
        "scoreboard players operation #wp mirror_wtmp2 = #const100 mirror_calc",
        "scoreboard players operation #wp mirror_wtmp2 += #attack_damage_multiply_base int",
        "execute if score #wp mirror_wtmp2 matches ..1 run scoreboard players set #wp mirror_wtmp2 1",
        "scoreboard players operation #temp entity_hurt_temp = #temp player_cause_1damage",
        "scoreboard players operation #temp entity_hurt_temp *= @s mirror_ctx_extra",
        "scoreboard players operation #temp entity_hurt_temp /= #wp mirror_wtmp2",
        "",
        "# 与本体主伤害同样乘攻速/冷却倍率（get_multiplier：0/20/50/100）",
        "scoreboard players operation #temp entity_hurt_temp *= attack_multiplier int",
        "scoreboard players operation #temp entity_hurt_temp /= #const100 mirror_calc",
        "execute if score #temp entity_hurt_temp matches 1.. run function plm:weapon/dmg/extra_hit",
    ]
    write_mc("dmg/extra_apply.mcfunction", lines)

    lines = [
        "# 真正追加一次伤害。mirror_affix_damage 防止本系统再次进入 on-hit；",
        "# 本体 when_cause_damage 的套装函数自带 armor_set_bonus_cool_4_tick 冷却（metal/40、fire/40 内设置），",
        "# 同一 tick 的第二次调用会被冷却拦截；advancement 本身仍会再跑一次（零覆盖约束下无法屏蔽，见 notes）。",
        "tag @s add if_death_count",
        "tag @s add mirror_affix_damage",
        "tag @e[tag=plm_ctx_target,limit=1] add mirror_affix_damage",
        "execute as @e[tag=plm_ctx_target,limit=1,tag=!mirror_arena_boss] run function pld:pre/damage/public_damage_entity",
        "tag @s add mirror_arena_damage_owner",
        "execute as @e[tag=plm_ctx_target,limit=1,tag=mirror_arena_boss] run function plm:arena/hit/skill_armor",
        "tag @s remove mirror_arena_damage_owner",
        "tag @e[tag=plm_ctx_target,limit=1] remove mirror_affix_damage",
        "tag @s remove mirror_affix_damage",
        "tag @s remove if_death_count",
    ]
    write_mc("dmg/extra_hit.mcfunction", lines)


# ---------------------------------------------------------------------------
# 6. FX
# ---------------------------------------------------------------------------
def gen_fx():
    # shi_ying
    write_mc("fx/shi_ying.mcfunction", [
        "# 拾影（20%×val/100，10s 冷却）：在击杀事件里调用。不需要死者。",
        "execute unless score @s wp_affix_fx_shi_ying matches 1.. run return 0",
        "execute if score @s mirror_fx_shi_ying_cd > #sys mirror_game_time run return 0",
        "function plm:weapon/util/rand100",
        "scoreboard players operation #t wp_rand *= #const10 mirror_calc",
        "execute if score #t wp_rand > @s wp_affix_fx_shi_ying run return 0",
        "scoreboard players operation @s mirror_fx_shi_ying_cd = #sys mirror_game_time",
        "scoreboard players add @s mirror_fx_shi_ying_cd 200",
        "function plm:weapon/fx/shi_ying/drop",
    ])
    write_mc("fx/shi_ying/drop.mcfunction", [
        "# 掉 1 个影尘（DLC 现有 id：panling:mirror_dust）",
        "summon item ~ ~0.5 ~ {Item:{id:\"minecraft:gunpowder\",Count:1b,tag:{id:\"panling:mirror_dust\",CustomModelData:390,display:{Name:'{\"translate\":\"pl.item.name.mirror_dust\"}'}}},PickupDelay:10s,Tags:[\"plm_fx_drop\"]}",
    ])

    # jing_xi
    write_mc("fx/jing_xi/tick.mcfunction", [
        "# 镜息：脱战 3s 后开 100t（5s）窗口，每 20t 回复一次，共 5 次；每次 0.5%×val/100 最大生命。",
        "# 用 mirror_fx_jing_xi_next 逐次推进，保证窗口内恰好 5 次，而不是只回一次。",
        "execute unless score @s wp_affix_fx_jing_xi matches 1.. run return 0",
        "# 新玩家/旧存档可能从未受伤，三个分数未设置；未设置时 if score 永远失败，镜息不会启动。",
        "execute unless score @s mirror_last_combat matches -2147483648.. run scoreboard players operation @s mirror_last_combat = #sys mirror_game_time",
        "execute unless score @s mirror_fx_jing_xi_until matches -2147483648.. run scoreboard players set @s mirror_fx_jing_xi_until 0",
        "execute unless score @s mirror_fx_jing_xi_done matches -2147483648.. run scoreboard players set @s mirror_fx_jing_xi_done 0",
        "execute unless score @s mirror_fx_jing_xi_next matches -2147483648.. run scoreboard players set @s mirror_fx_jing_xi_next 0",
        "scoreboard players operation #wp mirror_wtmp = #sys mirror_game_time",
        "scoreboard players operation #wp mirror_wtmp -= @s mirror_last_combat",
        "execute if score #wp mirror_wtmp matches ..59 run scoreboard players set @s mirror_fx_jing_xi_until 0",
        "execute if score #wp mirror_wtmp matches ..59 run scoreboard players set @s mirror_fx_jing_xi_done 0",
        "execute if score #wp mirror_wtmp matches ..59 run scoreboard players set @s mirror_fx_jing_xi_next 0",
        "",
        "# 开窗：用 #wp mirror_wtmp2 作一次性标志，避免先写 until 后条件立刻失效。",
        "scoreboard players set #wp mirror_wtmp2 0",
        "execute if score #wp mirror_wtmp matches 60.. if score @s mirror_fx_jing_xi_done matches 0 if score @s mirror_fx_jing_xi_until matches 0 run scoreboard players set #wp mirror_wtmp2 1",
        "execute if score #wp mirror_wtmp2 matches 1 run scoreboard players operation @s mirror_fx_jing_xi_until = #sys mirror_game_time",
        "execute if score #wp mirror_wtmp2 matches 1 run scoreboard players add @s mirror_fx_jing_xi_until 100",
        "execute if score #wp mirror_wtmp2 matches 1 run scoreboard players operation @s mirror_fx_jing_xi_next = #sys mirror_game_time",
        "",
        "# 窗口内每 20t 回复一次；5 次后 next > until，自然停止。",
        "execute if score @s mirror_fx_jing_xi_until matches 1.. if score #sys mirror_game_time < @s mirror_fx_jing_xi_until if score #sys mirror_game_time >= @s mirror_fx_jing_xi_next run function plm:weapon/fx/jing_xi/heal",
        "execute if score @s mirror_fx_jing_xi_until matches 1.. if score #sys mirror_game_time < @s mirror_fx_jing_xi_until if score #sys mirror_game_time >= @s mirror_fx_jing_xi_next run scoreboard players add @s mirror_fx_jing_xi_next 20",
        "execute if score @s mirror_fx_jing_xi_until matches 1.. if score #sys mirror_game_time >= @s mirror_fx_jing_xi_until run scoreboard players set @s mirror_fx_jing_xi_until 0",
        "execute if score @s mirror_fx_jing_xi_until matches 0 if score @s mirror_fx_jing_xi_done matches 0 if score #wp mirror_wtmp matches 60.. run scoreboard players set @s mirror_fx_jing_xi_done 1",
    ])
    write_mc("fx/jing_xi/heal.mcfunction", [
        "# 回复 = max_hp(×100) * wp_affix_fx_jing_xi / 1000；jing_xi 的 wp_affix=5 表示 0.5%（val=100）。",
        "scoreboard players set #wp mirror_wtmp2 0",
        "scoreboard players set #wp mirror_wtmp3 0",
        "scoreboard players set #wp mirror_wtmp4 0",
        "scoreboard players set #wp mirror_wtmp5 0",
        "execute store result score #wp mirror_wtmp2 run data get entity @s Health 100",
        "execute store result score #wp mirror_wtmp3 run attribute @s generic.max_health get 100",
        "execute unless score #wp mirror_wtmp3 matches 1.. run return 0",
        "# 用已读出的 Health×100 判断存活；nbt={Health:0.1..} 对 float Health 不匹配（1.20.1 实测）。",
        "execute if score #wp mirror_wtmp2 matches ..0 run return 0",
        "scoreboard players operation #wp mirror_wtmp5 = #wp mirror_wtmp3",
        "scoreboard players operation #wp mirror_wtmp5 *= @s wp_affix_fx_jing_xi",
        "scoreboard players operation #wp mirror_wtmp5 /= #const1000 mirror_calc",
        "scoreboard players operation #wp mirror_wtmp4 = #wp mirror_wtmp2",
        "scoreboard players operation #wp mirror_wtmp4 += #wp mirror_wtmp5",
        "execute if score #wp mirror_wtmp4 > #wp mirror_wtmp3 run scoreboard players operation #wp mirror_wtmp4 = #wp mirror_wtmp3",
        "execute if score #wp mirror_wtmp4 matches 1.. run execute store result entity @s Health double 0.01 run scoreboard players get #wp mirror_wtmp4",
    ])

    # jing_jing
    write_mc("fx/jing_jing/tick.mcfunction", [
        "# 镜径：每 4 格（walk_one_cm >=400）留一个 2s 镜影；用 marker 承载位置（1.20.1 无 macro，storage 不能直接喂 positioned）。",
        "execute unless score @s wp_affix_fx_jing_jing matches 1.. run scoreboard players set @s mirror_walk_last 0",
        "execute unless score @s wp_affix_fx_jing_jing matches 1.. run return 0",
        "scoreboard players set #wp mirror_wtmp 0",
        "scoreboard players set #wp mirror_wtmp2 0",
        "execute store result score #wp mirror_wtmp run scoreboard players get @s mirror_walk_stat",
        "scoreboard players operation #wp mirror_wtmp2 = #wp mirror_wtmp",
        "scoreboard players operation #wp mirror_wtmp -= @s mirror_walk_last",
        "scoreboard players operation @s mirror_walk_last = #wp mirror_wtmp2",
        "execute unless score #wp mirror_wtmp matches 400.. run return 0",
        "execute at @s run function plm:weapon/fx/jing_jing/point",
        "execute at @s run function plm:weapon/trail/tick_dim",
        "execute at @s as @e[tag=monster,distance=..1.5,tag=!plm_trail_slow] run function plm:weapon/fx/jing_jing/slow",
        "execute at @s as @e[tag=mirror_boss,distance=..1.5,tag=!plm_trail_slow] run function plm:weapon/fx/jing_jing/slow",
        "execute as @e[tag=plm_trail_slow,distance=..30000000] if score @s mirror_trail_slow_until <= #sys mirror_game_time run function plm:weapon/fx/jing_jing/unspeed",
    ])
    lines = ["# 轮转 6 个 trail marker，把当前点放到 @s 脚下并设置 40t 有效。"]
    lines.append("# 服务器来源的 @e 无 distance 时会跨维度选择，因此所有 marker 选择器都带 distance；")
    lines.append("# 若玩家维度/区块里没有可选的 marker（跨维度或预生成点在未加载区块），就地补一个。")
    for i in range(6):
        sel = "@e[type=minecraft:marker,tag=plm_trail_%d,limit=1]" % i
        lines += [
            "execute if score #sys mirror_trail_next matches %d unless entity %s run summon minecraft:marker ~ ~ ~ {Tags:[\"plm_trail\",\"plm_trail_%d\"]}" % (i, sel, i),
            "execute if score #sys mirror_trail_next matches %d run tp %s ~ ~ ~" % (i, sel),
            "execute if score #sys mirror_trail_next matches %d run scoreboard players operation %s mirror_trail_until = #sys mirror_game_time" % (i, sel),
            "execute if score #sys mirror_trail_next matches %d run scoreboard players add %s mirror_trail_until 40" % (i, sel),
        ]
    lines += [
        "scoreboard players add #sys mirror_trail_next 1",
        "scoreboard players operation #sys mirror_trail_next %= #const6 mirror_calc",
    ]
    write_mc("fx/jing_jing/point.mcfunction", lines)
    write_mc("fx/jing_jing/apply.mcfunction", [
        "# @s=trail marker。只对 tag=monster / tag=mirror_boss 的实体生效。",
        "execute as @e[tag=monster,distance=..1.5,tag=!plm_trail_slow] run function plm:weapon/fx/jing_jing/slow",
        "execute as @e[tag=mirror_boss,distance=..1.5,tag=!plm_trail_slow] run function plm:weapon/fx/jing_jing/slow",
    ])
    write_mc("fx/jing_jing/slow.mcfunction", [
        "# -8% movement_speed，2s 后由 trail/tick 清理。固定用 max 8%（val 只作为开关）。",
        "tag @s add plm_trail_slow",
        "scoreboard players operation @s mirror_trail_slow_until = #sys mirror_game_time",
        "scoreboard players add @s mirror_trail_slow_until 40",
        'attribute @s generic.movement_speed modifier add 00000000-0000-0000-0000-0000000000a1 "plm_trail_slow" -0.08 multiply',
    ])
    write_mc("fx/jing_jing/unspeed.mcfunction", [
        "# @s=带 plm_trail_slow 的实体",
        'attribute @s generic.movement_speed modifier remove 00000000-0000-0000-0000-0000000000a1',
        "tag @s remove plm_trail_slow",
        "scoreboard players set @s mirror_trail_slow_until 0",
    ])

    # 顶层入口（一条 FX 一个文件；tick 只调入口）
    write_mc("fx/jing_xi.mcfunction", [
        "# 镜息入口（20t 由 plm:weapon/tick/20t 调用）",
        "function plm:weapon/fx/jing_xi/tick",
    ])
    write_mc("fx/jing_jing.mcfunction", [
        "# 镜径入口（5t 由 plm:weapon/tick/5t 调用）",
        "function plm:weapon/fx/jing_jing/tick",
    ])

    # 其余 FX 占位
    for row in FX:
        if row["status"] == "active":
            continue
        write_mc("fx/%s.mcfunction" % row["id"], [
            "# %s（%s）— deferred" % (row["name"], row["id"]),
            "# " + row["why"],
            "return 0",
        ])


def gen_trail():
    # 每个维度一套 marker：@e 选择器只作用于执行维度，单套 overworld marker 在主世界之外会失灵。
    dims = ("minecraft:overworld", "minecraft:the_nether", "minecraft:the_end")
    lines = ["# 6 个专用 marker（每个维度一套；先清掉旧的 plm_trail_*）"]
    for d in dims:
        lines.append("execute in %s run function plm:weapon/trail/load_dim" % d)
    write_mc("trail/load.mcfunction", lines)

    lines = ["# 6 个专用 marker（env 里已有的 plm_trail_* 先清掉；distance 限定在本维度）",
             "kill @e[type=minecraft:marker,tag=plm_trail,distance=..30000000]"]
    for i in range(6):
        lines.append('summon minecraft:marker ~ ~ ~ {Tags:["plm_trail","plm_trail_%d"]}' % i)
    write_mc("trail/load_dim.mcfunction", lines)

    lines = ["# 每 5t：有效的 trail 点对 1.5 格内敌人施加减速；过期的减速修饰符清理。",
             "# 服务器来源的 @e 无 distance 时会跨维度选择，所有选择器都带 distance 限定本维度。"]
    for i in range(6):
        lines.append("execute as @e[type=minecraft:marker,tag=plm_trail_%d,distance=..30000000,limit=1] at @s if score @s mirror_trail_until >= #sys mirror_game_time run function plm:weapon/fx/jing_jing/apply" % i)
    lines.append("execute as @e[tag=plm_trail_slow,distance=..30000000] if score @s mirror_trail_slow_until <= #sys mirror_game_time run function plm:weapon/fx/jing_jing/unspeed")
    write_mc("trail/tick_dim.mcfunction", lines)

    lines = ["# 每 5t：对三个原版维度分别处理（marker/slow 都只存在于各自维度）。"]
    for d in dims:
        lines.append("execute in %s run function plm:weapon/trail/tick_dim" % d)
    write_mc("trail/tick.mcfunction", lines)


# ---------------------------------------------------------------------------
# 7. BASE
# ---------------------------------------------------------------------------
def gen_base():
    write_mc("base/base_lie_ying.mcfunction", [
        "# 裂影基底：造成伤害时 5% 概率追加一次 10% 影伤。",
        "# 只给剑/斧（mirror_set=1 裂影；mirror_form 0/1）。与五纹追加伤害合并为一次。",
        "execute unless score @s wp_set matches 1 run return 0",
        "execute unless score @s mirror_form matches 0..1 run return 0",
        "execute if predicate plm:chance/5 run scoreboard players add @s mirror_ctx_extra 100",
    ])
    for row in BASE:
        if row["status"] == "active":
            continue
        write_mc("base/%s.mcfunction" % row["id"], [
            "# %s（%s）— deferred" % (row["name"], row["id"]),
            "# " + row["why"],
            "return 0",
        ])


# ---------------------------------------------------------------------------
# 8. SKL 占位
# ---------------------------------------------------------------------------
def gen_skl():
    for aid, mx in SKL:
        write_mc("skl/%s.mcfunction" % aid, [
            "# SKL %s（max %d）— deferred" % (aid, mx),
            "# 六把镜武武器技尚未编码；Phase 1 只 parse 出 wp_affix_skl_%s（actual×10），不消费。" % aid,
            "return 0",
        ])


# ---------------------------------------------------------------------------
# 9. tick / 事件
# ---------------------------------------------------------------------------
def gen_ticks():
    write_mc("tick/5t.mcfunction", [
        "execute as @a[tag=mirror_weapon_active] at @s run function plm:weapon/fx/jing_jing",
        "execute as @a[tag=mirror_skill_active] if score @s mirror_skill_until <= #sys mirror_game_time run tag @s remove mirror_skill_active",
        "execute if entity @a[tag=mirror_weapon_active] run function plm:weapon/trail/tick",
    ])
    write_mc("tick/20t.mcfunction", [
        "execute as @a[tag=mirror_weapon_active] run function plm:weapon/fx/jing_xi",
        "function plm:weapon/tick/bootstrap",
        "",
        "# 已存在的影商随玩家接近时升级，兼容重载时尚未加载的区块。",
        "execute at @a as @e[type=villager,tag=plm_merchant,tag=!plm_heart_trades,distance=..32] run function plm:mirror/hub/heart_trades",
    ])
    write_mc("tick/refresh.mcfunction", [
        "# 每 5t 检查当前生效槽位；丢出最后一把镜武/切到非镜武/act:0 都会在 5t 内 clear。",
        "# 全量 parse 仍只在 activation / inventory_changed / 槽位变化时发生。",
        "execute as @a[tag=mirror_weapon_active] run function plm:weapon/refresh/check",
    ])
    write_mc("event/damaged.mcfunction", [
        "# 挂在 #pld:equipment_lock/when_damaged（@s=受伤玩家）。只更新时间戳/取消镜息，不产生伤害。",
        "scoreboard players operation @s mirror_last_combat = #sys mirror_game_time",
        "scoreboard players set @s mirror_fx_jing_xi_until 0",
        "scoreboard players set @s mirror_fx_jing_xi_done 0",
        "scoreboard players set @s mirror_fx_jing_xi_next 0",
    ])
    write_mc("event/kill.mcfunction", [
        "# DLC 自建 player_killed_entity 进度 reward。@s=击杀玩家；reward 里拿不到死者，故只做玩家侧计时/掉落。",
        "advancement revoke @s only plm:weapon/kill",
        "# 余响只看「玩家击杀后 3s」，与击杀时手里拿什么无关：先记时间戳，再决定是否触发拾影。",
        "scoreboard players operation @s mirror_last_kill = #sys mirror_game_time",
        "execute unless data entity @s SelectedItem.tag{mirror:1} run return 0",
        "execute if entity @s[tag=mirror_weapon_active] run function plm:weapon/fx/shi_ying",
    ])


# ---------------------------------------------------------------------------
# 10. 谓词 / 进度 / pld 标签
# ---------------------------------------------------------------------------
def gen_json_assets():
    for key, eff in DEBUFF_PREDICATES:
        write_json("data/plm/predicates/effect/%s.json" % key, {
            "condition": "minecraft:entity_properties",
            "entity": "this",
            "predicate": {"effects": {eff: {}}},
        })
    write_json("data/plm/predicates/chance/5.json", {
        "condition": "minecraft:random_chance",
        "chance": 0.05,
    })
    write_json("data/plm/advancements/weapon/kill.json", {
        "criteria": {"killed": {"trigger": "minecraft:player_killed_entity"}},
        "rewards": {"function": "plm:weapon/event/kill"},
    })
    # 事件驱动 parse：只有带 tag.mirror:1 的物品进入/离开/改写背包时才触发重解析。
    # 1.20.1 的 inventory_changed conditions.items 是 ItemPredicate 列表；nbt 匹配物品的 tag 复合（不是 stack 根）。
    write_json("data/plm/advancements/weapon/inventory_changed.json", {
        "criteria": {"changed": {
            "trigger": "minecraft:inventory_changed",
            "conditions": {"items": [{"nbt": "{mirror:1}"}]},
        }},
        "rewards": {"function": "plm:weapon/refresh/hook"},
    })

    tags = {
        "weapon_unlock/enchant.json": ["plm:mirror/enable/weapon", "plm:weapon/parse"],
        "warrior/when_hurt_entity.json": ["plm:weapon/on_hit"],
        "attack_damage/multiply_base.json": ["plm:weapon/ctx/melee"],
        "archer_damage/multiply_base.json": ["plm:weapon/ctx/archer"],
        "archer/the_arrow.json": ["plm:weapon/ctx/arrow"],
        "equipment_lock/when_damaged.json": ["plm:weapon/event/damaged"],
        "equipment_lock/when_weapon_skill_enable.json": ["plm:weapon/ctx/skill"],
    }
    for rel, values in tags.items():
        write_json("data/pld/tags/functions/" + rel, {"replace": False, "values": values})


# ---------------------------------------------------------------------------
def remove_stale():
    """删除已废弃的生成物：设计 §10.3 明确禁止的 id_check 挂点。"""
    stale = [
        os.path.join(W, "parse", "id_check.mcfunction"),
        os.path.join(PDL_TAGS, "equipment_lock", "weapon", "enhance", "id_check.json"),
    ]
    for p in stale:
        if os.path.isfile(p):
            os.remove(p)


def main():
    remove_stale()
    for fn in (
        gen_load_combat, gen_config_affix, gen_parse_clear, gen_parse_form,
        gen_parse_apply, gen_parse, gen_parse_hand,
        gen_clear, gen_refresh, gen_refresh_check, gen_refresh_hook, gen_bootstrap,
        gen_ctx_melee, gen_ctx_archer, gen_ctx_arrow, gen_ctx_skill, gen_ctx_target,
        gen_target_hp, gen_target_behind,
        gen_dmg_melee, gen_dmg_archer, gen_on_hit, gen_on_hit_mark, gen_extra,
        gen_fx, gen_trail, gen_base, gen_skl, gen_ticks, gen_json_assets,
    ):
        fn()

    n_mc = 0
    for dp, dn, fn in os.walk(W):
        for f in fn:
            if f.endswith(".mcfunction"):
                n_mc += 1
    print("[gen] weapon functions:", n_mc)
    print("[gen] DMG:", len(DMG), "FX:", len(FX), "BASE:", len(BASE), "SKL:", len(SKL))


if __name__ == "__main__":
    main()
