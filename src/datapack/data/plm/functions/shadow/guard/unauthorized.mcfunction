# 保留原山屏障，同时拒绝从相邻地形步入或用其他传送方式绕过主城交易。
function plm:shadow/main_return
execute if score @s shadow_tp matches 1 run tellraw @s {"text":"影域须由主城的影域引路人送入：一份影尘或一张银票。","color":"gray"}
