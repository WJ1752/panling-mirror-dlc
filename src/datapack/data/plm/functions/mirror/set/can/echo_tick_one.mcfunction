# 残影队列循环体；#can_n = 本轮剩余条目
execute unless data storage plm:mirror can_echo[0] run return 0
execute store result score #can_due mirror_zf_tmp run data get storage plm:mirror can_echo[0].due
scoreboard players remove #can_due mirror_zf_tmp 1
execute store result storage plm:mirror can_echo[0].due int 1 run scoreboard players get #can_due mirror_zf_tmp

# due < 0：结束
execute if score #can_due mirror_zf_tmp matches ..-1 run data remove storage plm:mirror can_echo[0]
# due == 0：最后一次绘制并删除
execute if score #can_due mirror_zf_tmp matches 0 run function plm:mirror/set/can/echo_draw
execute if score #can_due mirror_zf_tmp matches 0 run data remove storage plm:mirror can_echo[0]
# due >= 1：绘制后移到队尾
execute if score #can_due mirror_zf_tmp matches 1.. run function plm:mirror/set/can/echo_draw
execute if score #can_due mirror_zf_tmp matches 1.. run data modify storage plm:mirror can_echo append from storage plm:mirror can_echo[0]
execute if score #can_due mirror_zf_tmp matches 1.. run data remove storage plm:mirror can_echo[0]

scoreboard players remove #can_n mirror_zf_tmp 1
execute if score #can_n mirror_zf_tmp matches 1.. run function plm:mirror/set/can/echo_tick_one
