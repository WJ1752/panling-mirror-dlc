# 射线 16 格内没有目标/方块：按设计「无目标则脚下」
execute at @s run function plm:mirror/skill/furnace/twin/box_cast
tag @s add mirror_box_done
