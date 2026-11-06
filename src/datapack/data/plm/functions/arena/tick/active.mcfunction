# 受击盒意外失踪时中止，避免误判为击败。
execute unless entity @e[tag=mirror_arena_boss,distance=..40] run function plm:arena/room/close
execute unless score #arena mirror_arena_active matches 1 run return 0
# hitbox 血量每 tick 重置
function plm:arena/boss/health/reset
# 5s 伤害窗口倒计时
function plm:arena/boss/damage/window_tick
# 2 秒无敌倒计时（tick）
execute if score #arena mirror_invuln matches 1.. run scoreboard players remove #arena mirror_invuln 1
# 统计
execute store result score #arena mirror_summon_count run execute if entity @e[tag=mirror_arena_mob,distance=0..,tag=mirror_summon]
# Bossbar
function plm:arena/boss/health/clamp
execute store result bossbar plm:mirror_boss value run scoreboard players get #boss mirror_boss_hp
# 阶段切换
function plm:arena/phase/check
execute if score #arena mirror_arena_active matches 1 run function plm:arena/boss/attack
# 阶段 tick
execute if score #arena mirror_boss_phase matches 1 run function plm:arena/phase/shadow/tick
execute if score #arena mirror_boss_phase matches 2 run function plm:arena/phase/lord/tick
execute if score #arena mirror_boss_phase matches 3 run function plm:arena/phase/reflection/tick
execute if score #arena mirror_boss_phase matches 4 run function plm:arena/phase/final/tick
# 闪电预警倒计时
execute if score #arena mirror_lightning_warn matches 1.. run function plm:arena/lightning/tick
