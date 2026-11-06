scoreboard players set #temp mirror_tmp 0
scoreboard players operation #temp mirror_tmp = #boss mirror_boss_max
scoreboard players operation #temp mirror_tmp *= 2 int
scoreboard players operation #temp mirror_tmp /= 100 int
scoreboard players operation #boss mirror_boss_hp += #temp mirror_tmp
function plm:arena/boss/health/clamp
execute at @e[tag=mirror_boss,limit=1] run particle minecraft:heart ~ ~1 ~ 0.5 0.5 0.5 0.1 8
execute at @e[tag=mirror_boss,limit=1] run playsound minecraft:block.beacon.power_select master @a[tag=mirror_arena_inside,distance=0..] ~ ~ ~ 1 1.4
tellraw @a[tag=mirror_arena_inside,distance=0..] [{"text":"[镜中倒影] ","color":"gray"},{"text":"击杀禁攻颜色 · 影主回复 2% 最大生命","color":"red"}]
