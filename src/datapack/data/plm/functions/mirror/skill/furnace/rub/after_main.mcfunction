# 拓印炉 after_main（炉在副手，元素在主手）
# 由共享 plm:mirror/furnace/after_main 在 zfsuccess=1 且副手是拓印炉时调用（at @s）
# 职责：本体阵法成功 → +1 印；写主阵伤害快照（放印的伤害基数）
execute unless score @s zfsuccess matches 1 run return 0
execute unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_rub7",act:1}}]}] run return 0

# 主阵元素（元素在主手）
scoreboard players set #tw_hand mirror_zf_tmp 1
scoreboard players set @s mirror_zf_el 0
function plm:mirror/skill/furnace/twin/element/snapshot
scoreboard players operation @s mirror_zf_main_el = @s mirror_zf_el
execute if score @s mirror_zf_el matches 1.. run scoreboard players set @s mirror_zf_snap 1

# 快照：实际主阵伤害 ×10（0.1 HP），含共鸣。
# 只有金属主阵造成伤害（zf_mp_metal=250%）；木/火/水/土主阵是治疗/增益，快照为 0。
#   优先 raw（×10）×25/10；没有 raw 时退回整数 HP zf_str×25。
scoreboard players set @s mirror_zf_base 0
scoreboard players set @s mirror_zf_raw_dmg 0
execute unless score @s mirror_zf_mult matches 1.. run scoreboard players set @s mirror_zf_mult 1000
execute if score @s mirror_zf_el matches 1 if score @s mirror_zf_raw matches 1.. run scoreboard players operation @s mirror_zf_raw_dmg = @s mirror_zf_raw
execute if score @s mirror_zf_el matches 1 if score @s mirror_zf_raw matches 1.. run scoreboard players operation @s mirror_zf_raw_dmg *= #const25 mirror_calc
execute if score @s mirror_zf_el matches 1 if score @s mirror_zf_raw matches 1.. run scoreboard players operation @s mirror_zf_raw_dmg /= #const10 mirror_calc
execute if score @s mirror_zf_el matches 1 unless score @s mirror_zf_raw matches 1.. run scoreboard players operation @s mirror_zf_raw_dmg = @s zf_str
execute if score @s mirror_zf_el matches 1 unless score @s mirror_zf_raw matches 1.. run scoreboard players operation @s mirror_zf_raw_dmg *= #const25 mirror_calc
execute if score @s mirror_zf_el matches 1 unless score @s mirror_zf_raw matches 1.. run scoreboard players operation @s mirror_zf_raw_dmg *= #const1000 mirror_calc
execute if score @s mirror_zf_el matches 1 unless score @s mirror_zf_raw matches 1.. run scoreboard players operation @s mirror_zf_raw_dmg /= @s mirror_zf_mult
execute if score @s mirror_zf_el matches 1 run scoreboard players operation @s mirror_zf_base = @s mirror_zf_raw_dmg
execute if score @s mirror_zf_el matches 1 run scoreboard players operation @s mirror_zf_base *= @s mirror_zf_mult
execute if score @s mirror_zf_el matches 1 run scoreboard players operation @s mirror_zf_base /= #const1000 mirror_calc
execute if score @s mirror_zf_base matches ..0 run function plm:mirror/skill/furnace/twin/base/fallback

# 本体阵法 +1 印（不含倒影/镜匣/放印；那些不走本函数）
scoreboard players add @s mirror_rub_stack 1
function plm:mirror/skill/furnace/rub/bonus
# 4 件套：放印后 5s 内的下一次本体阵法 +5%。
# 先按本体 metal_main 的同一规则（zf_hold_ldl 5/10 格）标记本次主阵实际目标。
function plm:mirror/skill/furnace/main_target
function plm:mirror/skill/furnace/rub/next_bonus
