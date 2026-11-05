# 脚下 48×48 内的所有区块都须可读，避免在边角区块未加载时建场或清场。
scoreboard players set #arena mirror_tmp 0
execute unless loaded ~-24 ~ ~-24 run return 0
execute unless loaded ~-24 ~ ~-8 run return 0
execute unless loaded ~-24 ~ ~8 run return 0
execute unless loaded ~-24 ~ ~23 run return 0
execute unless loaded ~-8 ~ ~-24 run return 0
execute unless loaded ~-8 ~ ~-8 run return 0
execute unless loaded ~-8 ~ ~8 run return 0
execute unless loaded ~-8 ~ ~23 run return 0
execute unless loaded ~8 ~ ~-24 run return 0
execute unless loaded ~8 ~ ~-8 run return 0
execute unless loaded ~8 ~ ~8 run return 0
execute unless loaded ~8 ~ ~23 run return 0
execute unless loaded ~23 ~ ~-24 run return 0
execute unless loaded ~23 ~ ~-8 run return 0
execute unless loaded ~23 ~ ~8 run return 0
execute unless loaded ~23 ~ ~23 run return 0
scoreboard players set #arena mirror_tmp 1
