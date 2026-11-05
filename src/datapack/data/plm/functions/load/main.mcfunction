# 镜中倒影 · 加载入口
function plm:load/objectives
function plm:load/const
# tick 入口统一走 #minecraft:tick → plm:tick/main（DLC 排在 panling 本体之后）。
# 旧版 plm:tick/loop 自循环已停用，避免每 tick 跑两次；空函数保留用于吸收旧 schedule。
tellraw @a {"text":"[镜中倒影] 数据包已加载（tick 由 #minecraft:tick 驱动）","color":"gray"}
# 武器五纹系统
function plm:weapon/load
