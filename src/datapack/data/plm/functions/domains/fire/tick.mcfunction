scoreboard players add #fire ds_clock 1
execute if score #fire ds_cd matches 1.. run scoreboard players remove #fire ds_cd 1
execute if score #fire ds_stage matches 1 as @e[type=interaction,tag=ds_fire_jar1_0,limit=1] at @s if data entity @s attack run function plm:domains/fire/prop/jar1_0
execute if score #fire ds_stage matches 1 as @e[type=interaction,tag=ds_fire_jar1_1,limit=1] at @s if data entity @s attack run function plm:domains/fire/prop/jar1_1
execute if score #fire ds_stage matches 1 as @e[type=interaction,tag=ds_fire_jar1_2,limit=1] at @s if data entity @s attack run function plm:domains/fire/prop/jar1_2
execute if score #fire ds_stage matches 1 if score #fire ds_count matches 3.. run function plm:domains/fire/stage/2
execute if score #fire ds_stage matches 2 as @e[type=interaction,tag=ds_fire_jar2_0,limit=1] at @s if data entity @s attack run function plm:domains/fire/prop/jar2_0
execute if score #fire ds_stage matches 2 as @e[type=interaction,tag=ds_fire_jar2_1,limit=1] at @s if data entity @s attack run function plm:domains/fire/prop/jar2_1
execute if score #fire ds_stage matches 2 as @e[type=interaction,tag=ds_fire_jar2_2,limit=1] at @s if data entity @s attack run function plm:domains/fire/prop/jar2_2
execute if score #fire ds_stage matches 2 as @e[type=interaction,tag=ds_fire_jar2_3,limit=1] at @s if data entity @s attack run function plm:domains/fire/prop/jar2_3
execute if score #fire ds_stage matches 2 as @e[type=interaction,tag=ds_fire_jar2_4,limit=1] at @s if data entity @s attack run function plm:domains/fire/prop/jar2_4
execute if score #fire ds_stage matches 2 if score #fire ds_count matches 5.. run function plm:domains/fire/stage/3
execute if score #fire ds_stage matches 3 as @e[type=interaction,tag=ds_fire_jar3_0,limit=1] at @s if data entity @s attack run function plm:domains/fire/prop/jar3_0
execute if score #fire ds_stage matches 3 as @e[type=interaction,tag=ds_fire_jar3_1,limit=1] at @s if data entity @s attack run function plm:domains/fire/prop/jar3_1
execute if score #fire ds_stage matches 3 as @e[type=interaction,tag=ds_fire_jar3_2,limit=1] at @s if data entity @s attack run function plm:domains/fire/prop/jar3_2
execute if score #fire ds_stage matches 3 if score #fire ds_count matches 3.. run function plm:domains/fire/stage/4
execute if score #fire ds_stage matches 4.. unless entity @e[type=husk,tag=dm_boss_fire,limit=1] run function plm:domains/fire/abort
execute unless score #fire dm_state matches 2 run return 0
execute if score #fire ds_stage matches 4 as @e[type=interaction,tag=ds_fire_offer_0,limit=1] at @s if data entity @s attack run function plm:domains/fire/prop/offer_0
execute if score #fire ds_stage matches 4 as @e[type=interaction,tag=ds_fire_offer_1,limit=1] at @s if data entity @s attack run function plm:domains/fire/prop/offer_1
execute if score #fire ds_stage matches 4 as @e[type=interaction,tag=ds_fire_offer_2,limit=1] at @s if data entity @s attack run function plm:domains/fire/prop/offer_2
execute if score #fire ds_hold matches 1.. run scoreboard players remove #fire ds_hold 1
execute if score #fire ds_stage matches 4 if score #fire ds_hold matches 0 unless entity @e[tag=ds_prop_fire] run function plm:domains/fire/reset_offer
execute as @e[tag=ds_fire_ember] at @s run function plm:domains/fire/ember
execute if score #fire ds_stage matches 4 if score #fire ds_clock matches 40 if score #fire ds_window matches 0 at @p[tag=plm_d_fire] run summon marker ~ ~ ~ {Tags:["dm_scene_fire","ds_fire_ember"]}
execute if score #fire ds_stage matches 4 run function plm:domains/fire/phase_check
execute if score #fire ds_stage matches 4.. if score #fire ds_hp matches ..0 run function plm:domains/fire/win
execute unless score #fire dm_state matches 2 run return 0
execute if score #fire ds_stage matches 4.. as @e[type=husk,tag=dm_boss_fire,limit=1] run function plm:domains/fire/shield
execute if score #fire ds_window matches 1.. run scoreboard players remove #fire ds_window 1
execute if score #fire ds_stage matches 4.. if score #fire ds_clock matches 40.. run title @a[tag=plm_d_fire] actionbar [{"text":"双心炎魔　"},{"score":{"name":"#fire","objective":"ds_hp"}}]
execute if score #fire ds_clock matches 40.. run scoreboard players set #fire ds_clock 0
