# 地板状态保存毒格，一个游标只用于读写扩散队列的坐标。
data modify storage plm:arena frontier set value []
summon minecraft:marker ~ ~ ~ {Tags:["mirror_arena_cursor"]}
scoreboard players set #arena mirror_poison_i 0
scoreboard players set #arena mirror_poison_need 8
function plm:arena/poison/init_loop
