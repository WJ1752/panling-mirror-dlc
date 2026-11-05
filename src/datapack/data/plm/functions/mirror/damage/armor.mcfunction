# 护甲伤害包装（2 位小数路径）
# 调用约定：
#   @s = 攻击者（玩家）
#   #temp entity_hurt_temp = 伤害 × 100（100 = 1 HP）
#   目标已打 tag mirror_dmg_target（只取 limit=1）
# 作用：给攻击者补 if_death_count，调本体 public_damage_entity，再清 tag。
# 不要在这里写 4 位小数；4 位只走 plm:mirror/damage/true。
# 调用方必须在 add 之前清掉旧的 mirror_dmg_target；这里再用 sort=nearest
# 做一层防御，避免多个残留 tag 时 limit=1 选到更远的旧目标。
tag @s add mirror_arena_damage_owner
tag @s add if_death_count
execute as @e[tag=mirror_dmg_target,limit=1,sort=nearest] if entity @s[tag=mirror_arena_boss] run function plm:arena/hit/skill_armor
execute as @e[tag=mirror_dmg_target,limit=1,sort=nearest] unless entity @s[tag=mirror_arena_boss] run function pld:pre/damage/public_damage_entity
tag @s remove if_death_count
tag @s remove mirror_arena_damage_owner
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
