# 折光/照心伤害量近似：快照差 = mirror_hp_last（5t 快照，×100）− 当前 Health（×100）。
# 只接受 10t 内的快照：玩家卸下镜武/切槽期间 5t 不再更新快照，过期就拒绝估值，
# 避免把整段空窗期掉血算成「本次伤害」。
# 输出 #wp mirror_wtmp2；无法估值时保持 0。
execute unless score @s mirror_hp_last matches 1.. run return 0
execute unless score @s mirror_hp_last_t matches -2147483648.. run return 0
scoreboard players operation #wp mirror_wtmp4 = #sys mirror_game_time
scoreboard players operation #wp mirror_wtmp4 -= @s mirror_hp_last_t
execute if score #wp mirror_wtmp4 matches 11.. run return 0
scoreboard players set #wp mirror_wtmp2 0
scoreboard players set #wp mirror_wtmp3 0
execute store result score #wp mirror_wtmp3 run data get entity @s Health 100
scoreboard players operation #wp mirror_wtmp2 = @s mirror_hp_last
scoreboard players operation #wp mirror_wtmp2 -= #wp mirror_wtmp3
execute if score #wp mirror_wtmp2 matches ..0 run scoreboard players set #wp mirror_wtmp2 0
