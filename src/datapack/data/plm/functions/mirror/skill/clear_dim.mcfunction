# 单维度清理：只杀 owner 匹配的 DLC 实体（由 plm:mirror/skill/clear 按三个维度调用）
# distance=0.. 锚在执行维度；三次调用合起来覆盖所有维度（裸 @e 跨维度，锚点避免误读）。
execute as @e[tag=mirror_shadow,distance=0..] if score @s mirror_shadow_owner = #mirror_clear mirror_skill_tmp run kill @s
execute as @e[tag=mirror_turret,distance=0..] if score @s mirror_turret_owner = #mirror_clear mirror_skill_tmp run kill @s
execute as @e[tag=mirror_shadow_hit,distance=0..] if score @s mirror_shadow_hit_owner = #mirror_clear mirror_skill_tmp run kill @s
execute as @e[tag=mirror_zf_echo,distance=0..] if score @s mirror_zf_owner = #mirror_clear mirror_skill_tmp run kill @s
