# 双生 2 件套：主阵命中叠 1 层共鸣（共鸣·上仍可 50% 额外 +1）
# @s = 玩家；由 twin/resonance/mark 在金属主阵命中后调用。
scoreboard players set #tw_shang mirror_resonance_extra 0
execute if score @s wp_affix_skl_gong_ming_shang matches 1.. run function plm:weapon/util/rand100
scoreboard players set #tw_chance mirror_zf_tmp 0
scoreboard players operation #tw_chance mirror_zf_tmp = @s wp_affix_skl_gong_ming_shang
scoreboard players operation #tw_chance mirror_zf_tmp /= #const10 mirror_calc
execute if score #tw_chance mirror_zf_tmp matches 1.. if score #t wp_rand <= #tw_chance mirror_zf_tmp run scoreboard players set #tw_shang mirror_resonance_extra 1
function plm:mirror/skill/furnace/twin/resonance/stack
