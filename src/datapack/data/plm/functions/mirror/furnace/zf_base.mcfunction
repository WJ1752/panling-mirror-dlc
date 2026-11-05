# 挂在 #pld:zf/str/base：此时 zf_str 是 ×10（0.1 HP）定点
# 镜炉的 mirror_base.base.atk_pt 是 ×10 定点（18.7 → 187），直接加进 zf_str；
# 本体随后会把 zf_str /10 成整数 HP。
# 注：镜炉若带 multiply_base 五纹，需另挂 #pld:zf/str/multiply_base（当前 0 纹无此项）
scoreboard players set #mirror_zf mirror_zf_tmp 0
execute if score @s zf_hold_ldl matches ..-1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_twin7"}}}] store result score #mirror_zf mirror_zf_tmp run data get entity @s SelectedItem.tag.mirror_base.base.atk_pt 10
execute if score @s zf_hold_ldl matches ..-1 if entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_rub7"}}}] store result score #mirror_zf mirror_zf_tmp run data get entity @s SelectedItem.tag.mirror_base.base.atk_pt 10
execute if score @s zf_hold_ldl matches 1.. if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_twin7"}}]}] store result score #mirror_zf mirror_zf_tmp run data get entity @s Inventory[{Slot:-106b}].tag.mirror_base.base.atk_pt 10
execute if score @s zf_hold_ldl matches 1.. if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_rub7"}}]}] store result score #mirror_zf mirror_zf_tmp run data get entity @s Inventory[{Slot:-106b}].tag.mirror_base.base.atk_pt 10
scoreboard players operation @s zf_str += #mirror_zf mirror_zf_tmp

# 镜炉专属：保存共鸣前的原始 zf_str（×10），再把「共鸣·每层 +4%」应用到主阵强度。
# 只在手持镜炉时生效，避免 DLC 玩家用本体炉也吃到共鸣。
execute unless entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_twin7",act:1}}}] unless entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_rub7",act:1}}}] unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_twin7",act:1}}]}] unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_rub7",act:1}}]}] run return 0
scoreboard players operation @s mirror_zf_raw = @s zf_str
scoreboard players set @s mirror_zf_mult 1000
# 共鸣过期（读取点判定，不做全局 tick）
execute unless score @s mirror_resonance_until >= #sys mirror_game_time run scoreboard players set @s mirror_resonance 0
execute unless score @s mirror_resonance matches 1.. run return 0

# 倍率 = 1000 + 层数×(40 + 共鸣·效/10)，与 echo/hit 的 #tw_mult 同口径
scoreboard players set #tw_mult mirror_zf_tmp 1000
scoreboard players set #tw_stack mirror_zf_tmp2 40
scoreboard players set #tw_gm mirror_zf_tmp3 0
scoreboard players operation #tw_gm mirror_zf_tmp3 = @s wp_affix_skl_gong_ming_xiao
scoreboard players operation #tw_gm mirror_zf_tmp3 /= #const10 mirror_calc
scoreboard players operation #tw_stack mirror_zf_tmp2 += #tw_gm mirror_zf_tmp3
scoreboard players operation #tw_stack mirror_zf_tmp2 *= @s mirror_resonance
scoreboard players operation #tw_mult mirror_zf_tmp += #tw_stack mirror_zf_tmp2
scoreboard players operation @s mirror_zf_mult = #tw_mult mirror_zf_tmp
scoreboard players operation @s zf_str *= #tw_mult mirror_zf_tmp
scoreboard players operation @s zf_str /= #const1000 mirror_calc
