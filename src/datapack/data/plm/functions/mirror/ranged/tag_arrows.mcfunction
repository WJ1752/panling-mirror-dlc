# 射击时给普通弓/弩真实箭打 mirror_arrow + owner 分数。
# 不依赖本体 set_shooter 的 5 格窗口：按箭自身 Owner UUID 在 32 格内匹配。
# @s=射手（tag=shooter 仍由 #pld:archer/when_shoot 的调用方保留）。
# 镜花箭（mirror_bloom_arrow）由 bow/route 自己处理，这里跳过。
execute unless score @s job matches 1 run return 0
execute unless entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1}}}] run return 0
execute unless score @s mirror_form matches 2..3 run return 0
scoreboard players operation #rng_uid0 mirror_calc = @s player_uuid0
scoreboard players operation #rng_uid1 mirror_calc = @s player_uuid1
scoreboard players operation #rng_uid2 mirror_calc = @s player_uuid2
scoreboard players operation #rng_uid3 mirror_calc = @s player_uuid3
execute at @s as @e[type=arrow,nbt={OnGround:0b},distance=..32] unless entity @s[tag=mirror_bloom_arrow] run function plm:mirror/ranged/owner_match_tag
