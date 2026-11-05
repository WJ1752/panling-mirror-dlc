# @s 是所在维度临时定位器，无须玩家在线。区块实体未就绪时保留票据重试。
data modify entity @s Pos set from storage plm:arena room.pos
execute at @s run function plm:arena/room/visible
execute if score #arena mirror_tmp matches 1 at @s run function plm:arena/room/close
kill @s
