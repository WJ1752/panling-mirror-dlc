# 测试夹具：原子地开启残影 4 件套 QC buff 窗口（先写 until，再写 bonus）。
# 分开写时 5t tick 可能在两条命令之间看到 bonus=102/until=0 并提前还原。
scoreboard players operation @s mirror_crossbow_4_until = #sys mirror_game_time
scoreboard players add @s mirror_crossbow_4_until 100
scoreboard players set @s mirror_crossbow_4_bonus 102
