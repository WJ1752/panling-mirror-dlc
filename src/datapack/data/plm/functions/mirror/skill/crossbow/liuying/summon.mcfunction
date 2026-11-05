# 留影 · 召唤弩机（@s=玩家，装填完成 0→1）
# 2/4/真影律分档：2 件套 2 台；真影律额外 +1 台。
execute if score @s mirror_cd_int matches 1.. run return 0

scoreboard players set #t mirror_set_tmp 3
function plm:mirror/set/can/tier
scoreboard players set @s mirror_turret_max 1
execute if score @s mirror_set_count matches 2.. run scoreboard players add @s mirror_turret_max 1
execute if score @s mirror_true_law matches 1 run scoreboard players add @s mirror_turret_max 1

# 归属本玩家的弩机；新的顶掉最旧（剩余寿命最小的那台）
scoreboard players operation #cbown mirror_skill_tmp = @s player_uid
tag @e[tag=mirror_turret] remove mirror_turret_mine
execute as @e[tag=mirror_turret] if score @s mirror_turret_owner = #cbown mirror_skill_tmp run tag @s add mirror_turret_mine
execute if score @s mirror_turret_max matches 1 run kill @e[tag=mirror_turret_mine]
execute if score @s mirror_turret_max matches 2 if entity @e[tag=mirror_turret_mine,limit=2] run function plm:mirror/skill/crossbow/liuying/oldest
execute if score @s mirror_turret_max matches 3 if entity @e[tag=mirror_turret_mine,limit=3] run function plm:mirror/skill/crossbow/liuying/oldest
# 本次召唤前已有本玩家弩机 → 新弩机是第二台及以后（设计 §2.4.1：第二台只继承 60%）
scoreboard players set #second mirror_wtmp 0
execute if score @s mirror_turret_max matches 2.. if entity @e[tag=mirror_turret_mine,limit=1] run scoreboard players set #second mirror_wtmp 1
tag @e[tag=mirror_turret] remove mirror_turret_mine

execute at @s run summon minecraft:armor_stand ~ ~ ~ {Tags:["mirror_turret","mirror_turret_new"],Invisible:1b,NoBasePlate:1b,ShowArms:1b,Invulnerable:1b,NoAI:1b,Silent:1b,NoGravity:1b,HandItems:[{id:"minecraft:crossbow",Count:1b,tag:{id:"panling:mirror_crossbow7",CustomModelData:103}},{}]}
scoreboard players operation @e[tag=mirror_turret_new,limit=1] mirror_turret_owner = @s player_uid
# 弩机所在维度（0 主世界 / 1 下界 / 2 末地）。mark_owner 用它做同维度比较：
# `execute in` 不能用来过滤 @e，纯靠维度展开会把别的维度的弩机也处理掉。
scoreboard players set @e[tag=mirror_turret_new,limit=1] mirror_turret_dim 0
execute if dimension minecraft:the_nether run scoreboard players set @e[tag=mirror_turret_new,limit=1] mirror_turret_dim 1
execute if dimension minecraft:the_end run scoreboard players set @e[tag=mirror_turret_new,limit=1] mirror_turret_dim 2
# 主人死亡快照：DLC 自己的 deathCount objective（本体 player_death 会被每 tick reset）
# deathCount 在没有死亡记录时没有分数；先把 prev 归 0，避免 operation 因源分数缺失而失败。
scoreboard players set @e[tag=mirror_turret_new,limit=1] mirror_turret_prev 0
execute if score @s mirror_death matches 0.. run scoreboard players operation @e[tag=mirror_turret_new,limit=1] mirror_turret_prev = @s mirror_death

# 寿命 32 + 留影·久/25（SKL 实际值×10；max 40 -> 400 -> +16 个 5t = +4s）
scoreboard players set #dur mirror_skill_tmp 32
scoreboard players set #dur2 mirror_skill_tmp2 0
scoreboard players operation #dur2 mirror_skill_tmp2 = @s wp_affix_skl_liu_ying_jiu
scoreboard players operation #dur2 mirror_skill_tmp2 /= #const25 mirror_calc
scoreboard players operation #dur mirror_skill_tmp += #dur2 mirror_skill_tmp2
scoreboard players operation @e[tag=mirror_turret_new,limit=1] mirror_turret_5ticks = #dur mirror_skill_tmp

# 攻击间隔：把 6 → 4.5 个 5t 连续映射到 600 → 450（0.01 单位），
# 再取整数 + 余数；余数 >=50 时用 4/5 或 5/6 交替。这样 150/175 不会比 125 更慢，
# 也不会在 200/225 时跌破设计上限（−25% = 1.125s）。
scoreboard players set #int mirror_skill_tmp3 600
scoreboard players set #r mirror_skill_tmp2 0
scoreboard players operation #r mirror_skill_tmp2 = @s wp_affix_skl_liu_ying_su
scoreboard players operation #r mirror_skill_tmp2 *= #const6 mirror_calc
scoreboard players operation #r mirror_skill_tmp2 /= #const10 mirror_calc
scoreboard players operation #int mirror_skill_tmp3 -= #r mirror_skill_tmp2
# 整数部分
scoreboard players operation #atk mirror_skill_tmp2 = #int mirror_skill_tmp3
scoreboard players operation #atk mirror_skill_tmp2 /= #const100 mirror_calc
execute if score #atk mirror_skill_tmp2 matches ..4 run scoreboard players set #atk mirror_skill_tmp2 4
# 余数 → 交替开关
scoreboard players operation #rem mirror_skill_tmp = #int mirror_skill_tmp3
scoreboard players operation #rem mirror_skill_tmp %= #const100 mirror_calc
scoreboard players set #flag mirror_zf_tmp 0
execute if score #rem mirror_skill_tmp matches 50.. run scoreboard players set #flag mirror_zf_tmp 1
scoreboard players operation @e[tag=mirror_turret_new,limit=1] mirror_turret_atk = #atk mirror_skill_tmp2
scoreboard players operation @e[tag=mirror_turret_new,limit=1] mirror_turret_interval = #atk mirror_skill_tmp2
scoreboard players set @e[tag=mirror_turret_new,limit=1] mirror_turret_shots 0
scoreboard players operation @e[tag=mirror_turret_new,limit=1] mirror_turret_count = #flag mirror_zf_tmp

# 箭伤快照：archer_damage_should × 23%（真影律 40%；第二台只继承 60% → 13）
# 首次装填可能早于第一次射箭，archer_damage_should 还是 0；退到武器攻击基数，
# 再退到镜弩物品的 mirror_base.base.atk_pt（18.7 → 187），避免整台弩机 8s 打 0。
scoreboard players set #k mirror_skill_tmp2 23
execute if score #second mirror_wtmp matches 1 run scoreboard players set #k mirror_skill_tmp2 13
execute if score @s mirror_true_law matches 1 run scoreboard players set #k mirror_skill_tmp2 40
scoreboard players set #dmg mirror_wtmp12 0
scoreboard players operation #dmg mirror_wtmp12 = @s archer_damage_should
execute if score #dmg mirror_wtmp12 matches ..0 run scoreboard players operation #dmg mirror_wtmp12 = @s weapon_atk_pt_base1
execute if score #dmg mirror_wtmp12 matches ..0 store result score #dmg mirror_wtmp12 run data get entity @s SelectedItem.tag.mirror_base.base.atk_pt 10
scoreboard players operation #dmg mirror_wtmp12 *= #k mirror_skill_tmp2
scoreboard players operation #dmg mirror_wtmp12 /= #const100 mirror_calc
scoreboard players operation @e[tag=mirror_turret_new,limit=1] mirror_turret_ratio = #dmg mirror_wtmp12

scoreboard players set @s mirror_cd_int 32
# 2 件套/真影律有多台容量：内部冷却缩到 1 个 5t，让每次装填都能换掉最旧的一台；
# 1 台上限时保留 alpha.50 的 8s 内部冷却。
execute if score @s mirror_turret_max matches 2.. run scoreboard players set @s mirror_cd_int 1
tag @e[tag=mirror_turret_new] remove mirror_turret_new

execute at @s run particle minecraft:dust 0.55 0.25 0.95 1.0 ~ ~1 ~ 0.4 0.6 0.4 0 20
execute at @s run playsound minecraft:block.amethyst_block.chime master @a ~ ~ ~ 1 0.9
