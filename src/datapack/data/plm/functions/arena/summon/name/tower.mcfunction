execute if score #arena mirror_summon_color matches 1 run data modify entity @e[tag=mirror_arena_mob,distance=0..,tag=mirror_new,limit=1] CustomName set value '{"text":"白·妖塔","color":"white"}'
execute if score #arena mirror_summon_color matches 2 run data modify entity @e[tag=mirror_arena_mob,distance=0..,tag=mirror_new,limit=1] CustomName set value '{"text":"赤·妖塔","color":"red"}'
execute if score #arena mirror_summon_color matches 3 run data modify entity @e[tag=mirror_arena_mob,distance=0..,tag=mirror_new,limit=1] CustomName set value '{"text":"青·妖塔","color":"aqua"}'
execute if score #arena mirror_summon_color matches 4 run data modify entity @e[tag=mirror_arena_mob,distance=0..,tag=mirror_new,limit=1] CustomName set value '{"text":"黑·妖塔","color":"dark_gray"}'
