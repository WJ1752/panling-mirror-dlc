# 双照（shuang_zhao）— target
# 目标同时有 >=2 种负面效果时 +15%（10 个 DLC 谓词 + slowness/weakness）
# 共鸣（照隙 + 双照）：照隙留下的「下一次受伤 +5%」视为一种负面，帮助凑 2 种
execute unless score @s wp_affix_dmg_shuang_zhao matches 1.. run return 0
scoreboard players set #wp mirror_wtmp 0
execute as @e[tag=plm_ctx_target,limit=1] if predicate pld:effect_check/slowness run scoreboard players add #wp mirror_wtmp 1
execute as @e[tag=plm_ctx_target,limit=1] if predicate pld:effect_check/weakness run scoreboard players add #wp mirror_wtmp 1
execute as @e[tag=plm_ctx_target,limit=1] if predicate plm:effect/poison run scoreboard players add #wp mirror_wtmp 1
execute as @e[tag=plm_ctx_target,limit=1] if predicate plm:effect/wither run scoreboard players add #wp mirror_wtmp 1
execute as @e[tag=plm_ctx_target,limit=1] if predicate plm:effect/blindness run scoreboard players add #wp mirror_wtmp 1
execute as @e[tag=plm_ctx_target,limit=1] if predicate plm:effect/mining_fatigue run scoreboard players add #wp mirror_wtmp 1
execute as @e[tag=plm_ctx_target,limit=1] if predicate plm:effect/nausea run scoreboard players add #wp mirror_wtmp 1
execute as @e[tag=plm_ctx_target,limit=1] if predicate plm:effect/hunger run scoreboard players add #wp mirror_wtmp 1
execute as @e[tag=plm_ctx_target,limit=1] if predicate plm:effect/levitation run scoreboard players add #wp mirror_wtmp 1
execute as @e[tag=plm_ctx_target,limit=1] if predicate plm:effect/darkness run scoreboard players add #wp mirror_wtmp 1
execute as @e[tag=plm_ctx_target,limit=1] if predicate plm:effect/bad_omen run scoreboard players add #wp mirror_wtmp 1
execute as @e[tag=plm_ctx_target,limit=1] if predicate plm:effect/unluck run scoreboard players add #wp mirror_wtmp 1
execute if score @s wp_affix_fx_zhao_xi matches 1.. if score @e[tag=plm_ctx_target,limit=1] mirror_zhaoxi_ready matches 1 if score @e[tag=plm_ctx_target,limit=1] mirror_zhaoxi_owner = @s player_uid run scoreboard players add #wp mirror_wtmp 1
execute unless score #wp mirror_wtmp matches 2.. run return 0
scoreboard players operation @s mirror_ctx_extra += @s wp_affix_dmg_shuang_zhao
