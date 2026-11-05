# 从候选地面格反查同维度锚点，绝不在 46×46 内圈以外改方块。
execute positioned ~-22.5 ~-0.5 ~-22.5 unless entity @e[type=minecraft:marker,tag=mirror_arena_anchor,dx=45,dy=0,dz=45] run return 0
execute unless block ~ ~ ~ minecraft:air run return 0
execute unless block ~ ~-1 ~ minecraft:white_wool run return 0
function plm:arena/poison/place
