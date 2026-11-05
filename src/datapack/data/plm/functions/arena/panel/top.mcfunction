# 顶部 9x9：1 白 / 2 赤 / 3 青
execute if score #arena mirror_top_color matches 1 run fill ~-5 ~24 ~-5 ~3 ~24 ~3 minecraft:white_wool
execute if score #arena mirror_top_color matches 2 run fill ~-5 ~24 ~-5 ~3 ~24 ~3 minecraft:red_wool
execute if score #arena mirror_top_color matches 3 run fill ~-5 ~24 ~-5 ~3 ~24 ~3 minecraft:cyan_wool
