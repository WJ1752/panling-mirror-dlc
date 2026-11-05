# 倒影阵 AoE 结算：@s = 主人玩家；执行位置 = 阵中心（resolve 用 at @s 保留）。
# 目标只允许 tag=monster / mirror_boss / mirror_summon；4 格内最多结算 8 个。
# 伤害走 plm:mirror/damage/armor（2 位小数，100 = 1 HP），不吃 on-hit/裂痕。

# 2/4 件套分档：2 件套 = 任意阵法命中叠共鸣；4 件套 = 满共鸣时附加「相克」
scoreboard players set #t mirror_set_tmp 4
function plm:mirror/set/can/tier
scoreboard players set #tw_2pc mirror_resonance_max 0
execute if score @s mirror_set_count matches 2.. run scoreboard players set #tw_2pc mirror_resonance_max 1
scoreboard players set #tw_4pc mirror_twin_4_until 0
execute if score @s mirror_set_4 matches 1 run scoreboard players set #tw_4pc mirror_twin_4_until 1

# gong_ming_shang：50% 额外 +1 层。每个倒影阵只判定一次（objective 满值 500 → 50%）。
scoreboard players set #tw_shang mirror_resonance_extra 0
# #tw_any：本阵是否至少命中一个带共鸣标记的目标；stack 每阵只执行一次（#63）
scoreboard players set #tw_any mirror_resonance_extra 0
execute if score @s wp_affix_skl_gong_ming_shang matches 1.. run function plm:weapon/util/rand100
scoreboard players set #tw_chance mirror_zf_tmp 0
scoreboard players operation #tw_chance mirror_zf_tmp = @s wp_affix_skl_gong_ming_shang
scoreboard players operation #tw_chance mirror_zf_tmp /= #const10 mirror_calc
execute if score #tw_chance mirror_zf_tmp matches 1.. if score #t wp_rand <= #tw_chance mirror_zf_tmp run scoreboard players set #tw_shang mirror_resonance_extra 1

# 候选目标（4 格）
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
tag @e[tag=mirror_zf_hit] remove mirror_zf_hit
tag @e[tag=monster,distance=..4] add mirror_zf_hit
tag @e[tag=mirror_boss,distance=..4] add mirror_zf_hit
tag @e[tag=mirror_summon,distance=..4] add mirror_zf_hit

# 相克元素颜色 + 音效
function plm:mirror/skill/furnace/twin/echo/fx

# 上限 8 个，避免测试场叠怪时递归过深
scoreboard players set #tw_n mirror_furnace_cast 8
function plm:mirror/skill/furnace/twin/echo/hit

# 共鸣每阵只叠一次（#63）：放在逐目标循环之后，本阵所有目标都按加层前的层数结算；
# 触发共鸣的这一发倒影不吃自己刚加的新层（设计）。gong_ming_shang 的 #tw_shang 同样只生效一次。
execute if score #tw_any mirror_resonance_extra matches 1 run function plm:mirror/skill/furnace/twin/resonance/stack

# 超出上限的候选与临时 tag 清理
tag @e[tag=mirror_zf_hit] remove mirror_zf_hit
tag @e[tag=mirror_zf_cur] remove mirror_zf_cur
