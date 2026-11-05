# 残影 2 件套残影队列 5t 处理入口
# 不扫实体：只读 storage 列表长度，单次上限 16。
scoreboard players set #can_n mirror_zf_tmp 0
execute store result score #can_n mirror_zf_tmp run data get storage plm:mirror can_echo
execute if score #can_n mirror_zf_tmp matches 17.. run scoreboard players set #can_n mirror_zf_tmp 16
execute if score #can_n mirror_zf_tmp matches 1.. run function plm:mirror/set/can/echo_tick_one
