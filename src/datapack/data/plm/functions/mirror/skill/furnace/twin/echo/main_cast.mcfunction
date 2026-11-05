# 主阵 → 倒映（内部冷却已确认 0）：@s = 玩家；位置 = 主阵位置。
# 强度 20% + dao_ying_qiang（objective = 实际百分点×10，满值 150 → +15pp）。
# 镜匣记忆：30s 内用过镜匣时，这一次倒映用镜匣元素（mirror_box_el）而不是自动相克；用掉即清。
execute if score @s mirror_box_remember matches 1 if score @s mirror_box_5ticks matches 1.. run scoreboard players operation @s mirror_zf_el = @s mirror_box_el
execute if score @s mirror_box_5ticks matches 1.. if score @s mirror_box_remember matches 1 run scoreboard players set @s mirror_box_5ticks 0
execute if score @s mirror_box_remember matches 1 run scoreboard players set @s mirror_box_remember 0

# 强度百分比×10：200 + dao_ying_qiang（0..150）；双生 2 件套 +15pp（+150）= 350
scoreboard players set #t mirror_set_tmp 4
function plm:mirror/set/can/tier
scoreboard players set #tw_ratio mirror_skill_ratio 200
scoreboard players operation #tw_ratio mirror_skill_ratio += @s wp_affix_skl_dao_ying_qiang
execute if score @s mirror_set_count matches 2.. run scoreboard players add #tw_ratio mirror_skill_ratio 150

# 写 marker 的入参：用「不含共鸣」的实际主阵伤害；共鸣由 echo/hit 的 #tw_mult 乘
scoreboard players set #tw_base mirror_skill_tmp 0
scoreboard players operation #tw_base mirror_skill_tmp = @s mirror_zf_raw_dmg
scoreboard players set #tw_el mirror_skill_tmp3 0
scoreboard players operation #tw_el mirror_skill_tmp3 = @s mirror_zf_el
scoreboard players set #tw_due mirror_zf_tmp 2
function plm:mirror/skill/furnace/twin/echo/spawn

# 内部冷却：40 个 5t（10s）− dao_ying_kuai/25（满值 300 → −12 个 5t = 3s，最低 28 = 7s）
scoreboard players set #tw_cd mirror_zf_tmp 40
scoreboard players set #tw_cd2 mirror_zf_tmp 0
scoreboard players operation #tw_cd2 mirror_zf_tmp = @s wp_affix_skl_dao_ying_kuai
scoreboard players operation #tw_cd2 mirror_zf_tmp /= #const25 mirror_calc
scoreboard players operation #tw_cd mirror_zf_tmp -= #tw_cd2 mirror_zf_tmp
execute if score #tw_cd mirror_zf_tmp matches ..28 run scoreboard players set #tw_cd mirror_zf_tmp 28
# 真影律：倒映内部冷却固定 7s（28 个 5t）
scoreboard players set #t mirror_set_tmp 4
function plm:mirror/set/can/tier
execute if score @s mirror_true_law matches 1 run scoreboard players set #tw_cd mirror_zf_tmp 28
scoreboard players operation @s mirror_cd_int = #tw_cd mirror_zf_tmp
