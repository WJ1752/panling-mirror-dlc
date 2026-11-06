# 主动离开本次影域范围即结束付费会话；死亡和重登在tick前段先行恢复。
function plm:shadow/leave
execute if score @s shadow_tp matches 1 run tellraw @s {"text":"已返回主城，本次影域行程结束。","color":"gray"}
