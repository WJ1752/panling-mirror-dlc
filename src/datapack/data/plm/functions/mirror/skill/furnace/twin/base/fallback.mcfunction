# 主阵伤害快照兜底：zf_str / zf_raw 拿不到时才走这里。
# 镜炉物品 mirror_base.base.atk_pt 是 double（双生炉 18.7）；scale 10 得到 187（×10，0.1 HP）。
# 本体金属阵伤害 = zf_str ×250%，所以实际伤害 ×10 定点 = 187 × 25 / 10 = 467。
# 只有金属主阵造成伤害；其它元素主阵是治疗/增益，快照保持 0。
execute unless score @s mirror_zf_el matches 1 run return 0
scoreboard players set @s mirror_zf_raw 0
execute if score #tw_hand mirror_zf_tmp matches 1 store result score @s mirror_zf_raw run data get entity @s Inventory[{Slot:-106b}].tag.mirror_base.base.atk_pt 10
execute if score #tw_hand mirror_zf_tmp matches -1 store result score @s mirror_zf_raw run data get entity @s SelectedItem.tag.mirror_base.base.atk_pt 10
scoreboard players operation @s mirror_zf_raw_dmg = @s mirror_zf_raw
scoreboard players operation @s mirror_zf_raw_dmg *= #const25 mirror_calc
scoreboard players operation @s mirror_zf_raw_dmg /= #const10 mirror_calc
execute unless score @s mirror_zf_mult matches 1.. run scoreboard players set @s mirror_zf_mult 1000
scoreboard players operation @s mirror_zf_base = @s mirror_zf_raw_dmg
scoreboard players operation @s mirror_zf_base *= @s mirror_zf_mult
scoreboard players operation @s mirror_zf_base /= #const1000 mirror_calc
