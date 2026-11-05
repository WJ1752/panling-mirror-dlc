# 逐格检查边缘，保留墙、阴阳面板与边界外地板。
execute positioned ~-1 ~ ~-1 run function plm:arena/poison/clear_tile
execute positioned ~-1 ~ ~ run function plm:arena/poison/clear_tile
execute positioned ~-1 ~ ~1 run function plm:arena/poison/clear_tile
execute positioned ~ ~ ~-1 run function plm:arena/poison/clear_tile
execute positioned ~ ~ ~ run function plm:arena/poison/clear_tile
execute positioned ~ ~ ~1 run function plm:arena/poison/clear_tile
execute positioned ~1 ~ ~-1 run function plm:arena/poison/clear_tile
execute positioned ~1 ~ ~ run function plm:arena/poison/clear_tile
execute positioned ~1 ~ ~1 run function plm:arena/poison/clear_tile
