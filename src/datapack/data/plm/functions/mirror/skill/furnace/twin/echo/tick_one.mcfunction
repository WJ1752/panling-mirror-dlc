# 处理队首条目（echo/tick 的循环体）；#tw_n = 本轮剩余条目数。
execute unless data storage plm:mirror echo[0] run return 0
execute store result score #tw_due mirror_zf_tmp run data get storage plm:mirror echo[0].due
scoreboard players remove #tw_due mirror_zf_tmp 1
execute store result storage plm:mirror echo[0].due int 1 run scoreboard players get #tw_due mirror_zf_tmp
execute if score #tw_due mirror_zf_tmp matches ..0 run function plm:mirror/skill/furnace/twin/echo/resolve
execute if score #tw_due mirror_zf_tmp matches 1.. run function plm:mirror/skill/furnace/twin/echo/rotate
scoreboard players remove #tw_n mirror_zf_tmp 1
execute if score #tw_n mirror_zf_tmp matches 1.. run function plm:mirror/skill/furnace/twin/echo/tick_one
