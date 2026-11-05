kill @e[tag=ds_prop_tower]
scoreboard players set #tower ds_stage 1
scoreboard players set #tower ds_count 0
tellraw @a[tag=plm_d_tower] {"text": "塌陷楼梯 · 击倒挡路守卫，沿宽阶向上。", "color": "gold"}
summon husk ~18 ~4 ~15 {Tags:["dm_scene_tower","ds_guard_tower","monster"],DeathLootTable:"minecraft:empty",PersistenceRequired:1b}
