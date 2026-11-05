scoreboard players operation #pct ds_hp = #valley ds_hp
scoreboard players operation #pct ds_hp *= #100 ds_hp
scoreboard players operation #pct ds_hp /= #valley ds_max
execute if score #pct ds_hp matches ..70 if score #valley ds_hold matches 0 run scoreboard players set #valley ds_hold 1
execute if score #pct ds_hp matches ..35 if score #valley ds_hold matches 1 run function plm:domains/valley/dry
scoreboard players operation #old ds_seq = #valley ds_seq
execute if score #valley ds_hold matches 1 if score #old ds_seq matches 0 if score #valley ds_cd matches 0 run function plm:domains/valley/rotate0
execute if score #valley ds_hold matches 1 if score #old ds_seq matches 1 if score #valley ds_cd matches 0 run function plm:domains/valley/rotate1
execute if score #valley ds_hold matches 1 if score #old ds_seq matches 2 if score #valley ds_cd matches 0 run function plm:domains/valley/rotate2
