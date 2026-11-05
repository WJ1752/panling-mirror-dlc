# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 拾影（20%×val/100，10s 冷却）：在击杀事件里调用。不需要死者。
execute unless score @s wp_affix_fx_shi_ying matches 1.. run return 0
execute if score @s mirror_fx_shi_ying_cd > #sys mirror_game_time run return 0
function plm:weapon/util/rand100
scoreboard players operation #t wp_rand *= #const10 mirror_calc
execute if score #t wp_rand > @s wp_affix_fx_shi_ying run return 0
scoreboard players operation @s mirror_fx_shi_ying_cd = #sys mirror_game_time
scoreboard players add @s mirror_fx_shi_ying_cd 200
function plm:weapon/fx/shi_ying/drop
