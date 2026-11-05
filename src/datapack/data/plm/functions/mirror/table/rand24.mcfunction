# 生成 1..24 随机数到 #t rand
# 在投掷器上方 3 格生成掉落物，同 tick 读取 count 后立即清掉；不修改世界方块
execute positioned ~ ~3 ~ run loot spawn ~ ~ ~ loot plm:rand24
execute positioned ~ ~3 ~ store result score #t rand run data get entity @e[type=minecraft:item,distance=..1,sort=nearest,limit=1] Item.Count
execute positioned ~ ~3 ~ run kill @e[type=minecraft:item,distance=..1]
