# 裂痕逐层过期（@s=目标实体）
# 设计 §2.2.1：3 层、每层独立 6s（120 tick）。不用单一 mirror_lie_until 刷新全部层。
scoreboard players operation #lie_now mirror_wtmp = #sys mirror_game_time

# slot 1
execute if score @s mirror_lie_t1 matches 1.. run scoreboard players operation #lie_age mirror_wtmp2 = #lie_now mirror_wtmp
execute if score @s mirror_lie_t1 matches 1.. run scoreboard players operation #lie_age mirror_wtmp2 -= @s mirror_lie_t1
execute if score @s mirror_lie_t1 matches 1.. if score #lie_age mirror_wtmp2 matches 120.. run scoreboard players operation @s mirror_lie_dmg -= @s mirror_lie_w1
execute if score @s mirror_lie_t1 matches 1.. if score #lie_age mirror_wtmp2 matches 120.. run scoreboard players set @s mirror_lie_t1 0
execute if score @s mirror_lie_t1 matches 1.. if score #lie_age mirror_wtmp2 matches 120.. run scoreboard players set @s mirror_lie_w1 0

# slot 2
execute if score @s mirror_lie_t2 matches 1.. run scoreboard players operation #lie_age mirror_wtmp2 = #lie_now mirror_wtmp
execute if score @s mirror_lie_t2 matches 1.. run scoreboard players operation #lie_age mirror_wtmp2 -= @s mirror_lie_t2
execute if score @s mirror_lie_t2 matches 1.. if score #lie_age mirror_wtmp2 matches 120.. run scoreboard players operation @s mirror_lie_dmg -= @s mirror_lie_w2
execute if score @s mirror_lie_t2 matches 1.. if score #lie_age mirror_wtmp2 matches 120.. run scoreboard players set @s mirror_lie_t2 0
execute if score @s mirror_lie_t2 matches 1.. if score #lie_age mirror_wtmp2 matches 120.. run scoreboard players set @s mirror_lie_w2 0

# slot 3
execute if score @s mirror_lie_t3 matches 1.. run scoreboard players operation #lie_age mirror_wtmp2 = #lie_now mirror_wtmp
execute if score @s mirror_lie_t3 matches 1.. run scoreboard players operation #lie_age mirror_wtmp2 -= @s mirror_lie_t3
execute if score @s mirror_lie_t3 matches 1.. if score #lie_age mirror_wtmp2 matches 120.. run scoreboard players operation @s mirror_lie_dmg -= @s mirror_lie_w3
execute if score @s mirror_lie_t3 matches 1.. if score #lie_age mirror_wtmp2 matches 120.. run scoreboard players set @s mirror_lie_t3 0
execute if score @s mirror_lie_t3 matches 1.. if score #lie_age mirror_wtmp2 matches 120.. run scoreboard players set @s mirror_lie_w3 0

# 层数 = 仍有效的槽位数
scoreboard players set @s mirror_lie 0
execute if score @s mirror_lie_t1 matches 1.. run scoreboard players add @s mirror_lie 1
execute if score @s mirror_lie_t2 matches 1.. run scoreboard players add @s mirror_lie 1
execute if score @s mirror_lie_t3 matches 1.. run scoreboard players add @s mirror_lie 1
execute if score @s mirror_lie_dmg matches ..-1 run scoreboard players set @s mirror_lie_dmg 0
execute if score @s mirror_lie matches 0 run scoreboard players set @s mirror_lie_until 0
