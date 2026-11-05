# 残影 2 件套：残影向 8 格内最近敌人射一箭（@s=玩家，at @s）
# 强度 20%：与影随齐射同一口径，damage NBT×10 = archer_damage_should × 20 /100。
execute unless score @s job matches 1 run return 0
tag @e[tag=mirror_can_target] remove mirror_can_target
execute at @s run tag @e[tag=monster,distance=..8,sort=nearest,limit=1] add mirror_can_target
execute at @s unless entity @e[tag=mirror_can_target,limit=1] run tag @e[tag=mirror_boss,distance=..8,sort=nearest,limit=1] add mirror_can_target
execute at @s unless entity @e[tag=mirror_can_target,limit=1] run tag @e[tag=mirror_summon,distance=..8,sort=nearest,limit=1] add mirror_can_target
execute unless entity @e[tag=mirror_can_target,limit=1] run return 0

# 发射点 = 玩家位置 +1.2
execute store result score #cbpx mirror_wtmp run data get entity @s Pos[0] 100
execute store result score #cbpy mirror_wtmp2 run data get entity @s Pos[1] 100
scoreboard players add #cbpy mirror_wtmp2 120
execute store result score #cbpz mirror_wtmp3 run data get entity @s Pos[2] 100

# 20% 强度；首箭前 archer_damage_should 可能为 0，退到武器攻击基数
scoreboard players set #pct mirror_skill_tmp 20
scoreboard players set #cbdmg mirror_wtmp12 0
scoreboard players operation #cbdmg mirror_wtmp12 = @s archer_damage_should
execute if score #cbdmg mirror_wtmp12 matches ..0 run scoreboard players operation #cbdmg mirror_wtmp12 = @s weapon_atk_pt_base1
execute if score #cbdmg mirror_wtmp12 matches ..0 store result score #cbdmg mirror_wtmp12 run data get entity @s SelectedItem.tag.mirror_base.base.atk_pt 10
scoreboard players operation #cbdmg mirror_wtmp12 *= #pct mirror_skill_tmp
scoreboard players operation #cbdmg mirror_wtmp12 /= #const100 mirror_calc

execute at @s run summon minecraft:arrow ~ ~1.2 ~ {Tags:["mirror_can_arrow","mirror_shot_new"],pickup:2b,crit:0b,Motion:[0.0d,0.0d,0.0d]}
execute store result entity @e[tag=mirror_shot_new,limit=1] Pos[0] double 0.01 run scoreboard players get #cbpx mirror_wtmp
execute store result entity @e[tag=mirror_shot_new,limit=1] Pos[1] double 0.01 run scoreboard players get #cbpy mirror_wtmp2
execute store result entity @e[tag=mirror_shot_new,limit=1] Pos[2] double 0.01 run scoreboard players get #cbpz mirror_wtmp3
# Owner / 归属：直接结算需要反查射手；也防止箭在出膛段命中主人
data modify entity @e[tag=mirror_shot_new,limit=1] Owner set from entity @s UUID
scoreboard players operation @e[tag=mirror_shot_new,limit=1] projectile_owner_uuid0 = @s player_uuid0
scoreboard players operation @e[tag=mirror_shot_new,limit=1] projectile_owner_uuid1 = @s player_uuid1
scoreboard players operation @e[tag=mirror_shot_new,limit=1] projectile_owner_uuid2 = @s player_uuid2
scoreboard players operation @e[tag=mirror_shot_new,limit=1] projectile_owner_uuid3 = @s player_uuid3

# aim 只借用 mirror_dmg_target 定位；结算在 arrow/hit_check
tag @e[tag=mirror_can_target,limit=1] add mirror_dmg_target
function plm:mirror/skill/crossbow/shot/aim
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
tag @e[tag=mirror_can_target] remove mirror_can_target
tag @e[tag=mirror_shot_new] remove mirror_shot_new

execute at @s run particle minecraft:dust 0.55 0.25 0.95 1 ~ ~1.2 ~ 0.3 0.5 0.3 0.01 10
execute at @s run playsound minecraft:item.crossbow.shoot master @a ~ ~ ~ 0.4 1.6
# 1t 直接结算循环：只在有技能箭时运行，无箭自停
schedule function plm:mirror/skill/crossbow/arrow/tick 1t replace
