# 槽 3 是否武器五纹上下文：武器胚 / mirror_ver:2 镜武
scoreboard players set #t wp_ctx 0
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t wp_ctx 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t wp_ctx 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t wp_ctx 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t wp_ctx 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t wp_ctx 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t wp_ctx 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,mirror_ver:2}}] run scoreboard players set #t wp_ctx 1
