# 镜花 2 件套：普通弓射击时按当前花影/4 件套窗口改箭的 damage。
# 由 #pld:archer/when_shoot 调用（@s=射手，tag=shooter 仍在；ctx/arrow 已给真实箭打 mirror_arrow）。
# 专属镜花箭仍走 bow/tag_arrow，本函数跳过 mirror_bloom_arrow。
execute unless score @s job matches 1 run return 0
execute unless entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_bow7"}}}] run return 0
execute unless score @s mirror_parse_ok matches 1 run return 0

function plm:mirror/set/jing_hua/max
scoreboard players set #jh_pct mirror_calc 100
execute if score @s mirror_flower_max matches 5 run scoreboard players operation #jh_pct mirror_calc += @s mirror_flower
execute if score @s mirror_flower_max matches 5 run scoreboard players operation #jh_pct mirror_calc += @s mirror_flower

# 4 件套：绽放后 5s 内下一支箭 +20%（普通箭也消费）
scoreboard players set #jh4 mirror_calc 0
execute if score @s mirror_bow_4_until >= #sys mirror_game_time if score @s mirror_bow_4_bonus matches 1.. run scoreboard players set #jh4 mirror_calc 1
execute if score #jh4 mirror_calc matches 1 run scoreboard players operation #jh_pct mirror_calc += @s mirror_bow_4_bonus

# 本次射击的箭（同一 tick、5 格内、owner UUID 匹配）
scoreboard players operation #rng_uid0 mirror_calc = @s player_uuid0
scoreboard players operation #rng_uid1 mirror_calc = @s player_uuid1
scoreboard players operation #rng_uid2 mirror_calc = @s player_uuid2
scoreboard players operation #rng_uid3 mirror_calc = @s player_uuid3
tag @e[tag=mirror_jinghua_shot] remove mirror_jinghua_shot
execute as @e[type=arrow,tag=mirror_arrow,distance=..5] unless entity @s[tag=mirror_bloom_arrow] if score @s projectile_owner_uuid0 = #rng_uid0 mirror_calc if score @s projectile_owner_uuid1 = #rng_uid1 mirror_calc if score @s projectile_owner_uuid2 = #rng_uid2 mirror_calc if score @s projectile_owner_uuid3 = #rng_uid3 mirror_calc run tag @s add mirror_jinghua_shot

# 有箭才消费 4 件套窗口；没有箭（例如空放）保持到下一次
execute if entity @e[tag=mirror_jinghua_shot,limit=1] if score #jh4 mirror_calc matches 1 run scoreboard players set @s mirror_bow_4_until 0
execute if entity @e[tag=mirror_jinghua_shot,limit=1] if score #jh4 mirror_calc matches 1 run scoreboard players set @s mirror_bow_4_bonus 0
execute if entity @e[tag=mirror_jinghua_shot,limit=1] run scoreboard players operation @s mirror_last_jinghua_until = #sys mirror_game_time
execute if entity @e[tag=mirror_jinghua_shot,limit=1] run scoreboard players add @s mirror_last_jinghua_until 40
execute as @e[tag=mirror_jinghua_shot] run function plm:mirror/set/jing_hua/apply_shot
tag @e[tag=mirror_jinghua_shot] remove mirror_jinghua_shot
