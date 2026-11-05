# 裂痕三层引爆：@s=玩家；主目标 plm_ctx_target
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0

# 真影律即时判定（4 件裂影防具映度全 5；武器不能替代）
function plm:mirror/set/lie/true_law

# 真影律：同一目标 6s 内只能引爆一次（120 tick）。
# ICD 内直接保留 3 层，不结算、不消耗；下一次命中会继续尝试。
execute if score @s mirror_true_law matches 1 if score @e[tag=plm_ctx_target,limit=1] mirror_lie_icd matches 1.. run scoreboard players operation #lie_age mirror_calc = #sys mirror_game_time
execute if score @s mirror_true_law matches 1 if score @e[tag=plm_ctx_target,limit=1] mirror_lie_icd matches 1.. run scoreboard players operation #lie_age mirror_calc -= @e[tag=plm_ctx_target,limit=1] mirror_lie_icd
execute if score @s mirror_true_law matches 1 if score @e[tag=plm_ctx_target,limit=1] mirror_lie_icd matches 1.. if score #lie_age mirror_calc matches ..119 run return 0

# 伤害 = 本次 3 层累计直接命中 × pct / 1000
# mirror_lie_dmg 是 ×100（材料伤害口径）；pct = 80 + 裂深×8/100（8.0%..10.0%，0.1% 定点）
scoreboard players set #skill mirror_skill_lie 0
scoreboard players operation #skill mirror_skill_lie = @e[tag=plm_ctx_target,limit=1] mirror_lie_dmg
scoreboard players set #skill mirror_skill_lie_pct 80
scoreboard players set #skill mirror_skill_tmp 0
scoreboard players operation #skill mirror_skill_tmp = @s wp_affix_skl_lie_shen
scoreboard players operation #skill mirror_skill_tmp *= #const4 mirror_calc
scoreboard players operation #skill mirror_skill_tmp *= #const2 mirror_calc
scoreboard players operation #skill mirror_skill_tmp /= #const100 mirror_calc
scoreboard players operation #skill mirror_skill_lie_pct += #skill mirror_skill_tmp
scoreboard players operation #skill mirror_skill_lie *= #skill mirror_skill_lie_pct
scoreboard players operation #skill mirror_skill_lie /= #const1000 mirror_calc

# 4 件套斩杀判定必须在范围伤害之前（范围伤害可能把目标压到阈值以下）。
# mirror_axe_exec：0 不斩杀 / 1 普通怪 kill / 2 Boss 追加 60%
scoreboard players set @s mirror_axe_exec 0
execute if score @s mirror_set_b matches 4.. run function plm:mirror/set/lie/exec_check

# 3 格内所有白名单敌人吃一次镜伤（monster / mirror_boss / mirror_summon）
# 用 victim 子函数把 #temp 写好，再以玩家为攻击者走 plm:mirror/damage/armor，
# 这样致死分支能拿到 if_death_count，且不会绕过契约要求的护甲包装。
tag @e[tag=mirror_lie_victim] remove mirror_lie_victim
execute at @e[tag=plm_ctx_target,limit=1] run tag @e[tag=monster,distance=..3] add mirror_lie_victim
execute at @e[tag=plm_ctx_target,limit=1] run tag @e[tag=mirror_boss,distance=..3] add mirror_lie_victim
execute at @e[tag=plm_ctx_target,limit=1] run tag @e[tag=mirror_summon,distance=..3] add mirror_lie_victim
tag @s add mirror_lie_attacker
tag @s add mirror_skill
execute as @e[tag=mirror_lie_victim] run function plm:weapon/axe/lie/victim
tag @s remove mirror_skill
tag @s remove mirror_lie_attacker
tag @e[tag=mirror_lie_victim] remove mirror_lie_victim
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target

# 引爆视觉（目标还活着时贴目标发）
execute at @e[tag=plm_ctx_target,limit=1] run particle minecraft:crit ~ ~1 ~ 0.8 0.6 0.8 0.1 24
execute at @e[tag=plm_ctx_target,limit=1] run playsound minecraft:entity.player.attack.sweep master @a ~ ~ ~ 1 0.8

# 4 件套斩杀：普通怪直接 kill（Boss 走追加 60%）
execute if score @s mirror_axe_exec matches 1 if entity @e[tag=plm_ctx_target,limit=1] run kill @e[tag=plm_ctx_target,limit=1]
execute if score @s mirror_axe_exec matches 2 if entity @e[tag=plm_ctx_target,limit=1] run function plm:mirror/set/lie/boss_exec

# 层数处理：真影律只掉 1 层（清最旧槽）并写 6s ICD；普通引爆清空 3 层
execute if score @s mirror_true_law matches 1 as @e[tag=plm_ctx_target,limit=1] run function plm:weapon/axe/lie/consume_one
execute unless score @s mirror_true_law matches 1 as @e[tag=plm_ctx_target,limit=1] run function plm:weapon/axe/lie/clear_all
execute if score @s mirror_true_law matches 1 if entity @e[tag=plm_ctx_target,limit=1] run scoreboard players operation @e[tag=plm_ctx_target,limit=1] mirror_lie_icd = #sys mirror_game_time

# 眩晕主目标 1s（Boss 无效）
execute as @e[tag=plm_ctx_target,limit=1] unless entity @s[tag=mirror_boss] run effect give @s minecraft:slowness 1 255 true
execute as @e[tag=plm_ctx_target,limit=1] unless entity @s[tag=mirror_boss] run effect give @s minecraft:weakness 1 255 true
