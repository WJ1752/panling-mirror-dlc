# @s=影伤 marker；到期后让 owner 对 5 格内最近敌人结算
# 目标存活时就在命中点（marker 与命中点同坐标）；目标死亡/移动时按 5 格内最近敌人转移。
# 主人离线/换维度：owner 找不到 → 丢弃；clear 也会直接杀掉 owner 的 marker。
scoreboard players operation #ch_owner mirror_skill_tmp = @s mirror_shadow_hit_owner
scoreboard players operation #ch_dmg mirror_skill_tmp2 = @s mirror_shadow_hit_dmg
tag @a remove mirror_ch_owner
execute as @a if score @s player_uid = #ch_owner mirror_skill_tmp run tag @s add mirror_ch_owner
execute unless entity @a[tag=mirror_ch_owner,limit=1] run function plm:mirror/skill/axe/chongying/drop
execute unless entity @a[tag=mirror_ch_owner,limit=1] run return 0

# 5 格内最近白名单目标（monster / mirror_boss / mirror_summon）
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
execute at @s run tag @e[tag=monster,distance=..5,sort=nearest,limit=1] add mirror_dmg_target
execute at @s unless entity @e[tag=mirror_dmg_target] run tag @e[tag=mirror_boss,distance=..5,sort=nearest,limit=1] add mirror_dmg_target
execute at @s unless entity @e[tag=mirror_dmg_target] run tag @e[tag=mirror_summon,distance=..5,sort=nearest,limit=1] add mirror_dmg_target
execute unless entity @e[tag=mirror_dmg_target] run function plm:mirror/skill/axe/chongying/drop
execute unless entity @e[tag=mirror_dmg_target] run return 0

# 以 owner 为攻击者走护甲包装；#skill mirror_skill_tmp 与 #temp 由 damage 子函数设置
scoreboard players operation #skill mirror_skill_tmp = #ch_dmg mirror_skill_tmp2
execute as @a[tag=mirror_ch_owner,limit=1] run function plm:mirror/skill/axe/chongying/damage
tag @a remove mirror_ch_owner
# 正常结算也归还队列计数（drop 路径已在 drop 里归还）
kill @s
execute as @a if score @s player_uid = #ch_owner mirror_skill_tmp run scoreboard players remove @s mirror_ch_queue 1
execute as @a if score @s player_uid = #ch_owner mirror_skill_tmp if score @s mirror_ch_queue matches ..-1 run scoreboard players set @s mirror_ch_queue 0
