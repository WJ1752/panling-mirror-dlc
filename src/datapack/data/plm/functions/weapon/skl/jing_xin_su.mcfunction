# SKL 镜心·速（max 50）：获得镜心时，有 actual% 概率额外 +1 层。
# 由 plm:mirror/set/zhao/heart_add 调用；@s=玩家。
# wp_affix_skl_jing_xin_su 已在 weapon/parse/apply 中解析为 actual×10（0..500），/10 得到 0..50 的百分比。
# 这是 jing_xin_su 的实际消费点；不再 return 0。
execute unless score @s wp_affix_skl_jing_xin_su matches 1.. run return 0
scoreboard players set #jx mirror_calc 0
scoreboard players operation #jx mirror_calc = @s wp_affix_skl_jing_xin_su
scoreboard players operation #jx mirror_calc /= #const10 mirror_calc
execute if score #jx mirror_calc matches 1.. run function plm:weapon/util/rand100
execute if score #jx mirror_calc matches 1.. if score #t wp_rand matches 1.. if score #t wp_rand <= #jx mirror_calc run scoreboard players add @s mirror_heart 1
