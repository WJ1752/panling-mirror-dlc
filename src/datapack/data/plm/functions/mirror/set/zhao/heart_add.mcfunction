# 镜心 +1 层：@s=玩家。
# 入口：受击（when_damaged）、parry/hurt 反射成功、zhao/tick 或 zhao/on_hit 击杀、SKL 镜心·速额外层。
# 每层 +4% 减伤，15s 刷新；2 件套上限 3，4 件套上限 5。
# 4 件套满 5 层时自动消耗并放「碎镜」；2 件套满 3 层只停在上限，不碎镜。
# 同一 tick 只叠 1 层：受击/反射/击杀可能在同一 tick 各调一次，用时间戳去重。
execute if score @s mirror_heart_last_hit = #sys mirror_game_time run return 0
function plm:mirror/set/zhao/max
execute if score @s mirror_heart_max matches ..0 run return 0
# 过期先清，再叠新层
execute if score @s mirror_heart matches 1.. if score @s mirror_heart_until <= #sys mirror_game_time run scoreboard players set @s mirror_heart 0
scoreboard players add @s mirror_heart 1
scoreboard players operation @s mirror_heart_last_hit = #sys mirror_game_time
# SKL 镜心·速：概率额外 +1 层（消费点在本函数；见 plm:weapon/skl/jing_xin_su）
function plm:weapon/skl/jing_xin_su
execute if score @s mirror_heart > @s mirror_heart_max run scoreboard players operation @s mirror_heart = @s mirror_heart_max
scoreboard players operation @s mirror_heart_until = #sys mirror_game_time
scoreboard players add @s mirror_heart_until 300
# 立即初始化受击前 Health 快照，避免第一次受击时 snapshot 还没跑
execute store result score @s mirror_shatter_target run data get entity @s Health 100
execute at @s run particle minecraft:end_rod ~ ~1 ~ 0.35 0.45 0.35 0.01 8
# 4 件套（max=5）满层：自动碎镜
execute if score @s mirror_heart_max matches 5 if score @s mirror_heart >= @s mirror_heart_max run function plm:mirror/set/zhao/shatter
