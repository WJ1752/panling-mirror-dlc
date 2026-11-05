# 映声（ying_sheng）— 武器技命中概率减少 1s 冷却。
# 由 plm:weapon/dmg/skill_hit 在技能伤害结算时调用（tag=mirror_skill 窗口内）。
# 冷却统一是 5t 单位：1s = 4 个 5t。mirror_cd_a/b/int 都是共享冷却 objective。
execute unless score @s wp_affix_fx_ying_sheng matches 1.. run return 0
scoreboard players set #wp mirror_wtmp 0
scoreboard players operation #wp mirror_wtmp = @s wp_affix_fx_ying_sheng
scoreboard players operation #wp mirror_wtmp /= #const10 mirror_calc
function plm:weapon/util/rand100
execute if score #t wp_rand > #wp mirror_wtmp run return 0
execute if score @s mirror_cd_a matches 5.. run scoreboard players remove @s mirror_cd_a 4
execute if score @s mirror_cd_a matches 1..4 run scoreboard players set @s mirror_cd_a 0
execute if score @s mirror_cd_b matches 5.. run scoreboard players remove @s mirror_cd_b 4
execute if score @s mirror_cd_b matches 1..4 run scoreboard players set @s mirror_cd_b 0
execute if score @s mirror_cd_int matches 5.. run scoreboard players remove @s mirror_cd_int 4
execute if score @s mirror_cd_int matches 1..4 run scoreboard players set @s mirror_cd_int 0
