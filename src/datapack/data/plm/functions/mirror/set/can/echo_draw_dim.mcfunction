# 入队维度内的临时 anchor：先按主人当前位置 summon（已加载区块），再设到残影 pos
kill @e[tag=mirror_can_anchor]
summon minecraft:marker ~ ~ ~ {Tags:["mirror_can_anchor","mirror_can_anchor_new"]}
data modify entity @e[tag=mirror_can_anchor_new,limit=1] Pos set from storage plm:mirror can_echo[0].pos
execute at @e[tag=mirror_can_anchor_new,limit=1] run function plm:mirror/set/can/echo_particles
kill @e[tag=mirror_can_anchor_new]
