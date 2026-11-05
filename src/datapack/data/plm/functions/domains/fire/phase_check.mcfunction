scoreboard players operation #ratio ds_hp = #fire ds_hp
scoreboard players operation #ratio ds_hp *= #100 ds_hp
scoreboard players operation #ratio ds_hp /= #fire ds_max
execute if score #ratio ds_hp matches ..70 if score #fire ds_phase matches 1 run tellraw @a[tag=plm_d_fire] {"text":"炎魔开始重摆宴席。打断供品，再追双心。"}
execute if score #ratio ds_hp matches ..70 if score #fire ds_phase matches 1 run scoreboard players set #fire ds_phase 2
execute if score #ratio ds_hp matches ..35 if score #fire ds_phase matches 2 run function plm:domains/fire/last
