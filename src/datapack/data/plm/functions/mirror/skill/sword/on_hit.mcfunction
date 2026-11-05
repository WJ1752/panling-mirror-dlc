# 照心剑 · 踏影命中结算（由 plm:weapon/on_hit 末尾调用）
# 调用上下文：@s=玩家；目标已打 tag=plm_ctx_target；#temp player_cause_1damage=本次直接命中的
# attack_damage1（×10 定点，10=1HP）；@s 仍在 weapon/on_hit 上下文里。
# 倒影是 armor_stand，不经过 weapon/on_hit，所以不吃踏影。

# 防御：调用方已按 buff 过滤，这里再守一次，避免被别处误调
execute unless score @s mirror_taying_buff matches 1.. run return 0
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
execute unless score #temp player_cause_1damage matches 1.. run return 0

# 1) 近战 +12%：mirror_ctx_extra 单位=百分点×10，加 120 后交给现有追加伤害管线。
#    extra_apply→extra_hit 会在玩家/目标上打 mirror_affix_damage，weapon/on_hit 见到它会早退，
#    因此这次追加不会再次触发 on-hit 词条。
scoreboard players add @s mirror_ctx_extra 120
function plm:weapon/dmg/extra_apply
scoreboard players set @s mirror_ctx_extra 0

# +12% 可能已经击杀目标；5% 镜伤只在目标仍存在时结算
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
# 清掉可能残留的标记，确保 armor 包装只打本次目标
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
tag @e[tag=plm_ctx_target,limit=1] add mirror_dmg_target

# 2) 每击 5% 攻击力镜伤。
#    player_cause_1damage 是 1 位小数（10=1HP），entity_hurt_temp 是 2 位小数（100=1HP）；
#    换算：×10 转 2 位，再取 5% → ×10×5/100 = /2。
scoreboard players operation #temp entity_hurt_temp = #temp player_cause_1damage
scoreboard players operation #temp entity_hurt_temp /= #const2 mirror_calc

# 白色镜面碎片：在 armor 包装清掉 mirror_dmg_target 之前，贴着目标发
execute as @e[tag=mirror_dmg_target,limit=1] at @s run particle minecraft:item minecraft:white_stained_glass ~ ~1 ~ 0.3 0.3 0.3 0.1 10

# 护甲路径。包装内部用 magic 伤害类型（属于 #minecraft:bypasses_armor），本体的 attack 进度
# 明确排除 bypasses_armor，所以这次镜伤不会重新进入近战 on-hit，也不加裂痕层。
# 碎镜易伤：目标带 mirror_shatter_until 时本次镜伤 ×1.15。
execute if score #temp entity_hurt_temp matches 1.. run function plm:mirror/set/zhao/vuln
execute if score #temp entity_hurt_temp matches 1.. run function plm:mirror/damage/armor
# 取整为 0 时也要清标记，避免 mirror_dmg_target 残留
execute if score #temp entity_hurt_temp matches ..0 run tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
