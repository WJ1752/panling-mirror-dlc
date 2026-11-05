scoreboard players set #mountain ds_cd 100
scoreboard players operation #heal ds_hp = #mountain ds_max
scoreboard players operation #heal ds_hp /= #20 ds_hp
scoreboard players operation #mountain ds_hp += #heal ds_hp
scoreboard players operation #mountain ds_hp < #mountain ds_max
tellraw @a[tag=plm_d_mountain] {"text":"踏错祭坛，映主恢复了生命。"}
