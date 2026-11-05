# 倒影阵 storage 队列 5t 处理入口（由 twin/tick 每 5t 调用一次）
# 不扫实体：只读 storage 列表长度，然后逐条处理（单次上限 32）。
# 每条：due -= 1；due<=0 -> resolve 并删除；due>0 -> 移到队尾，等下一轮。
scoreboard players set #tw_n mirror_zf_tmp 0
execute store result score #tw_n mirror_zf_tmp run data get storage plm:mirror echo
execute if score #tw_n mirror_zf_tmp matches 33.. run scoreboard players set #tw_n mirror_zf_tmp 32
execute if score #tw_n mirror_zf_tmp matches 1.. run function plm:mirror/skill/furnace/twin/echo/tick_one
