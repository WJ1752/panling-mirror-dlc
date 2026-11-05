# 挂在 #pld:zf/yuansu_main：炉在副手，元素在主手
execute unless score @s zfsuccess matches 1 run return 0
execute unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_twin7",act:1}}]}] unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_rub7",act:1}}]}] run return 0
scoreboard players add @s mirror_furnace_cast 1
scoreboard players operation @s mirror_last_combat = #sys mirror_game_time
# 分派：副手镜炉（双生 / 拓印）；位置用 at @s（主阵位置）
execute at @s if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_twin7",act:1}}]}] run function plm:mirror/skill/furnace/twin/after_main
execute at @s if entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_rub7",act:1}}]}] run function plm:mirror/skill/furnace/rub/after_main
