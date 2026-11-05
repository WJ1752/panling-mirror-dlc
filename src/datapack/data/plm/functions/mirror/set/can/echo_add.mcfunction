# 残影 2 件套：1s 残影视觉入队（@s=玩家）
# storage plm:mirror can_echo = [{due,pos,dim}]；can/tick 每 5t 处理，due 4→3→2→1→0 共 4 次粒子。
execute unless data storage plm:mirror can_echo run data modify storage plm:mirror can_echo set value []
# 上限 16，超出丢最旧
execute if data storage plm:mirror can_echo[15] run data remove storage plm:mirror can_echo[0]
data modify storage plm:mirror can_echo append value {due:4,pos:[0.0d,0.0d,0.0d],dim:0,owner:0}
data modify storage plm:mirror can_echo[-1].pos set from entity @s Pos
scoreboard players set #can_dim mirror_zf_tmp 0
execute if dimension minecraft:the_nether run scoreboard players set #can_dim mirror_zf_tmp 1
execute if dimension minecraft:the_end run scoreboard players set #can_dim mirror_zf_tmp 2
execute store result storage plm:mirror can_echo[-1].dim int 1 run scoreboard players get #can_dim mirror_zf_tmp
execute store result storage plm:mirror can_echo[-1].owner int 1 run scoreboard players get @s player_uid
