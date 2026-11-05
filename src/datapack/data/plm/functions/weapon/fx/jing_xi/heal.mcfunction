# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 回复 = max_hp(×100) * wp_affix_fx_jing_xi / 1000；jing_xi 的 wp_affix=5 表示 0.5%（val=100）。
scoreboard players set #wp mirror_wtmp2 0
scoreboard players set #wp mirror_wtmp3 0
scoreboard players set #wp mirror_wtmp4 0
scoreboard players set #wp mirror_wtmp5 0
execute store result score #wp mirror_wtmp2 run data get entity @s Health 100
execute store result score #wp mirror_wtmp3 run attribute @s generic.max_health get 100
execute unless score #wp mirror_wtmp3 matches 1.. run return 0
# 用已读出的 Health×100 判断存活；nbt={Health:0.1..} 对 float Health 不匹配（1.20.1 实测）。
execute if score #wp mirror_wtmp2 matches ..0 run return 0
scoreboard players operation #wp mirror_wtmp5 = #wp mirror_wtmp3
scoreboard players operation #wp mirror_wtmp5 *= @s wp_affix_fx_jing_xi
scoreboard players operation #wp mirror_wtmp5 /= #const1000 mirror_calc
scoreboard players operation #wp mirror_wtmp4 = #wp mirror_wtmp2
scoreboard players operation #wp mirror_wtmp4 += #wp mirror_wtmp5
execute if score #wp mirror_wtmp4 > #wp mirror_wtmp3 run scoreboard players operation #wp mirror_wtmp4 = #wp mirror_wtmp3
execute if score #wp mirror_wtmp4 matches 1.. run execute store result entity @s Health double 0.01 run scoreboard players get #wp mirror_wtmp4
