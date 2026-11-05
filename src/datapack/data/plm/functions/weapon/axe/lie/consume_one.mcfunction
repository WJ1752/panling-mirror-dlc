# 真影律引爆只掉 1 层：@s=目标。清“时间戳最旧”的槽位，保留另外两层。
# 裂痕用环形槽（i=1/2/0 对应 slot1/2/3）；真影律连续引爆时不能用固定 slot1，
# 必须按 t1/t2/t3 找最旧，否则会清到空槽、留下过期层。
scoreboard players set #lie_old mirror_calc 0
scoreboard players set #lie_slot mirror_calc 0
# 候选 slot1
execute if score @s mirror_lie_t1 matches 1.. run scoreboard players operation #lie_old mirror_calc = @s mirror_lie_t1
execute if score @s mirror_lie_t1 matches 1.. run scoreboard players set #lie_slot mirror_calc 1
# 候选 slot2：空候选或更早
execute if score @s mirror_lie_t2 matches 1.. if score #lie_old mirror_calc matches 0 run scoreboard players set #lie_slot mirror_calc 2
execute if score @s mirror_lie_t2 matches 1.. if score #lie_old mirror_calc matches 0 run scoreboard players operation #lie_old mirror_calc = @s mirror_lie_t2
execute if score @s mirror_lie_t2 matches 1.. if score #lie_old mirror_calc matches 1.. if score @s mirror_lie_t2 < #lie_old mirror_calc run scoreboard players set #lie_slot mirror_calc 2
execute if score @s mirror_lie_t2 matches 1.. if score #lie_old mirror_calc matches 1.. if score @s mirror_lie_t2 < #lie_old mirror_calc run scoreboard players operation #lie_old mirror_calc = @s mirror_lie_t2
# 候选 slot3：空候选或更早
execute if score @s mirror_lie_t3 matches 1.. if score #lie_old mirror_calc matches 0 run scoreboard players set #lie_slot mirror_calc 3
execute if score @s mirror_lie_t3 matches 1.. if score #lie_old mirror_calc matches 0 run scoreboard players operation #lie_old mirror_calc = @s mirror_lie_t3
execute if score @s mirror_lie_t3 matches 1.. if score #lie_old mirror_calc matches 1.. if score @s mirror_lie_t3 < #lie_old mirror_calc run scoreboard players set #lie_slot mirror_calc 3
execute if score @s mirror_lie_t3 matches 1.. if score #lie_old mirror_calc matches 1.. if score @s mirror_lie_t3 < #lie_old mirror_calc run scoreboard players operation #lie_old mirror_calc = @s mirror_lie_t3

# 清最旧槽
execute if score #lie_slot mirror_calc matches 1 run scoreboard players operation @s mirror_lie_dmg -= @s mirror_lie_w1
execute if score #lie_slot mirror_calc matches 1 run scoreboard players set @s mirror_lie_w1 0
execute if score #lie_slot mirror_calc matches 1 run scoreboard players set @s mirror_lie_t1 0
execute if score #lie_slot mirror_calc matches 2 run scoreboard players operation @s mirror_lie_dmg -= @s mirror_lie_w2
execute if score #lie_slot mirror_calc matches 2 run scoreboard players set @s mirror_lie_w2 0
execute if score #lie_slot mirror_calc matches 2 run scoreboard players set @s mirror_lie_t2 0
execute if score #lie_slot mirror_calc matches 3 run scoreboard players operation @s mirror_lie_dmg -= @s mirror_lie_w3
execute if score #lie_slot mirror_calc matches 3 run scoreboard players set @s mirror_lie_w3 0
execute if score #lie_slot mirror_calc matches 3 run scoreboard players set @s mirror_lie_t3 0
execute if score @s mirror_lie_dmg matches ..-1 run scoreboard players set @s mirror_lie_dmg 0
scoreboard players remove @s mirror_lie 1
execute if score @s mirror_lie matches ..0 run scoreboard players set @s mirror_lie 0

# 展示用到期时间 = 剩余层里最晚的时间戳 + 120
scoreboard players set #lie_until_max mirror_calc 0
execute if score @s mirror_lie_t1 > #lie_until_max mirror_calc run scoreboard players operation #lie_until_max mirror_calc = @s mirror_lie_t1
execute if score @s mirror_lie_t2 > #lie_until_max mirror_calc run scoreboard players operation #lie_until_max mirror_calc = @s mirror_lie_t2
execute if score @s mirror_lie_t3 > #lie_until_max mirror_calc run scoreboard players operation #lie_until_max mirror_calc = @s mirror_lie_t3
execute if score #lie_until_max mirror_calc matches 1.. run scoreboard players operation @s mirror_lie_until = #lie_until_max mirror_calc
execute if score #lie_until_max mirror_calc matches 1.. run scoreboard players add @s mirror_lie_until 120
execute if score #lie_until_max mirror_calc matches 0 run scoreboard players set @s mirror_lie_until 0
