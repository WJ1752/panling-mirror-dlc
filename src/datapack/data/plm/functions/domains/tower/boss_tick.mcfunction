scoreboard players add #tower ds_hold 1
execute if score #tower ds_hold matches 1 run function plm:domains/tower/warn
execute if score #tower ds_hold matches 40 positioned ~80 ~13 ~15 as @a[tag=plm_d_tower,distance=..3] run damage @s 4 minecraft:mob_attack
scoreboard players operation #pct ds_hp = #tower ds_hp
scoreboard players operation #pct ds_hp *= #100 ds_hp
scoreboard players operation #pct ds_hp /= #tower ds_max
execute if score #tower ds_seq matches 0..3 if score #tower ds_hold matches 240.. run function plm:domains/tower/crumble
execute if score #pct ds_hp matches ..70 if score #tower ds_seq matches 4..7 if score #tower ds_hold matches 160.. run function plm:domains/tower/crumble
execute if score #pct ds_hp matches ..35 if score #tower ds_seq matches 8.. if score #tower ds_hold matches 300.. run function plm:domains/tower/crumble
execute if score #tower ds_seq matches 13.. if score #tower ds_hp matches 1.. run function plm:domains/tower/abort
