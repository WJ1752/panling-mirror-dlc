# 真伤伤害包装（4 位小数路径）
# 调用约定：
#   @s = 攻击者（玩家）
#   #temp entity_hurt_temp = 伤害 × 10000（10000 = 1 HP）
#   目标已打 tag mirror_dmg_target（只取 limit=1）
# 作用：把 4 位值抄到目标 @s 的 entity_hurt_temp，再调 pass_armor。
# 不要把这个 4 位值写进 #temp 后去调 public_damage_entity（会 ×100）。
tag @s add mirror_arena_damage_owner
tag @s add if_death_count
execute as @e[tag=mirror_dmg_target,limit=1,sort=nearest] if entity @s[tag=mirror_arena_boss] run function plm:arena/hit/skill_true
execute as @e[tag=mirror_dmg_target,limit=1,sort=nearest] unless entity @s[tag=mirror_arena_boss] run function plm:mirror/damage/true_apply
tag @s remove if_death_count
tag @s remove mirror_arena_damage_owner
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
