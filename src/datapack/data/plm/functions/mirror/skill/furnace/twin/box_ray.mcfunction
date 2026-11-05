# 镜匣准星射线：@s=玩家；执行位置=当前射线点；旋转=玩家视线。
# 每 0.5 格一步，最多 32 步（16 格）；遇到白名单实体或非空气/可替换方块停下。
execute if entity @s[tag=mirror_box_done] run return 0
scoreboard players add #tw_ray mirror_box_ray 1
execute if score #tw_ray mirror_box_ray matches 33.. run function plm:mirror/skill/furnace/twin/box_ray_end
execute if entity @s[tag=mirror_box_done] run return 0

# 实体：取最近 1 个白名单目标，落在目标位置
# 注意：这里不能写 `execute at @s`，那会把执行位置重置到玩家脚下；
# 函数当前的位置就是射线点。
tag @e[tag=mirror_box_hit] remove mirror_box_hit
tag @e[tag=monster,distance=..0.7] add mirror_box_hit
tag @e[tag=mirror_boss,distance=..0.7] add mirror_box_hit
tag @e[tag=mirror_summon,distance=..0.7] add mirror_box_hit
execute if entity @e[tag=mirror_box_hit] at @e[tag=mirror_box_hit,sort=nearest,limit=1] run function plm:mirror/skill/furnace/twin/box_cast
execute if entity @e[tag=mirror_box_hit] run tag @s add mirror_box_done
execute if entity @e[tag=mirror_box_hit] run tag @e[tag=mirror_box_hit] remove mirror_box_hit
execute if entity @s[tag=mirror_box_done] run return 0

# 方块：空气/洞穴空气/水/岩浆/可替换方块不挡；其它方块在上一格落阵
execute unless block ~ ~ ~ air unless block ~ ~ ~ cave_air unless block ~ ~ ~ water unless block ~ ~ ~ lava unless block ~ ~ ~ #minecraft:replaceable run function plm:mirror/skill/furnace/twin/box_ray_block
execute if entity @s[tag=mirror_box_done] run return 0

# 继续前进
execute positioned ^ ^ ^0.5 run function plm:mirror/skill/furnace/twin/box_ray
