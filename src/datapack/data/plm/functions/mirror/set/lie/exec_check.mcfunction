# 裂痕 4 件套斩杀判定：@s=玩家；plm_ctx_target=即将引爆的目标。
# 阈值：普通 30%，真影律 40%。
# 结果写 @s mirror_axe_exec：0=不斩杀，1=普通怪斩杀，2=Boss 追加 60%。
# 必须在范围伤害之前判定（范围伤害可能把目标压到阈值以下）。
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
# 4 件套映度门槛：四件裂影防具 ≥3；3 防具 + 同套满锻武器时武器视为满足（主文档 §1）
scoreboard players set #t mirror_set_tmp 1
function plm:mirror/set/tier_gate
execute unless score #t ok matches 1 run return 0
function plm:weapon/ctx/target_hp
scoreboard players operation #lie_pct mirror_calc = #wp mirror_wtmp
scoreboard players set #lie_thr mirror_calc 30
execute if score @s mirror_true_law matches 1 run scoreboard players set #lie_thr mirror_calc 40
scoreboard players set @s mirror_axe_exec 0
execute if score #lie_pct mirror_calc < #lie_thr mirror_calc run scoreboard players set @s mirror_axe_exec 1
execute if score #lie_pct mirror_calc < #lie_thr mirror_calc if entity @e[tag=plm_ctx_target,limit=1,tag=mirror_boss] run scoreboard players set @s mirror_axe_exec 2
