# 套装计数：先按防具重算（调用现有函数，不覆盖），再把主手激活镜武算作 1 件
# 由 pld:equipment_lock/armor/set_check 追加调用
function plm:mirror/set/count

execute unless data entity @s SelectedItem.tag.mirror run return 0
execute unless data entity @s SelectedItem.tag.mirror_ver run return 0
scoreboard players set #t wp_sc_ver 0
scoreboard players set #t wp_sc_act 0
scoreboard players set #t wp_sc_set 0
execute store result score #t wp_sc_ver run data get entity @s SelectedItem.tag.mirror_ver
execute unless score #t wp_sc_ver matches 2 run return 0
execute store result score #t wp_sc_act run data get entity @s SelectedItem.tag.act
execute unless score #t wp_sc_act matches 1 run return 0
execute store result score #t wp_sc_set run data get entity @s SelectedItem.tag.mirror_set

# 武器可当第 4 件；真影律仍只认 4 件防具。
# 这是全套计数里唯一的武器 +1 点：mirror/set/count 只数防具。
execute if score #t wp_sc_set matches 0 run scoreboard players add @s mirror_set_a 1
execute if score #t wp_sc_set matches 1 run scoreboard players add @s mirror_set_b 1
execute if score #t wp_sc_set matches 2 run scoreboard players add @s mirror_set_c 1
execute if score #t wp_sc_set matches 3 run scoreboard players add @s mirror_set_d 1
execute if score #t wp_sc_set matches 4 run scoreboard players add @s mirror_set_e 1
execute if score #t wp_sc_set matches 5 run scoreboard players add @s mirror_set_f 1

# 真影律/上限函数用它区分“4 防具”与“3 防具 + 武器”
scoreboard players set @s mirror_set_weapon 0
execute if score #t wp_sc_set matches 0..5 run scoreboard players set @s mirror_set_weapon 1
