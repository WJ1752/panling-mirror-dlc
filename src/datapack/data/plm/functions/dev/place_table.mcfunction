# 在玩家面前搭一座磨镜台：命令方块(底) + 按钮(侧) + 投掷器(南侧高一格，避开按钮供电范围)
# 用法：站在空地上执行 /function plm:dev/place_table
execute at @s run setblock ~ ~ ~ minecraft:command_block{Command:"execute positioned ~1 ~ ~ as @p[gamemode=!spectator,distance=..5] positioned ~-1 ~1 ~2 run function plm:mirror/table/main",auto:0b} replace
execute at @s run setblock ~ ~1 ~2 minecraft:dropper[facing=down] replace
execute at @s run setblock ~1 ~ ~ minecraft:stone_button[face=wall,facing=east] replace
execute at @s run setblock ~ ~ ~3 minecraft:oak_sign{front_text:{messages:['{"text":"磨镜台"}','{"text":"南侧投掷器放材料"}','{"text":"侧面按钮=执行"}','{"text":"按钮可连按"}']}} replace
tellraw @s {"text":"[镜中倒影] 磨镜台已搭建：投掷器(南侧) 放材料，右键按钮执行。","color":"aqua"}
tellraw @s {"text":"  拼镜：槽3镜胚 + 槽6镜心×3 + 槽0镜片×4 + 槽8影尘×20","color":"gray"}
tellraw @s {"text":"  磨镜：槽3镜装 + 槽0砺镜砂 + 槽8影尘×10","color":"gray"}
tellraw @s {"text":"  定影：槽3镜装 + 槽1定影符 + 槽8影尘×10","color":"gray"}
tellraw @s {"text":"  映度：槽3镜装 + 槽0倒影核×N + 槽8影尘×10","color":"gray"}
tellraw @s {"text":"  分解：槽3镜装（回收材料）","color":"gray"}
