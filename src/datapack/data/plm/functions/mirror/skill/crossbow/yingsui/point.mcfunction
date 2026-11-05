# 影随 · 单个残影点（@s=玩家）
# 先射 1 支；再按影随·多（max 40 -> 400 = 40%）决定是否在同一位置再射 1 支（最多 +1）。
function plm:mirror/skill/crossbow/yingsui/arrow
function plm:weapon/util/rand100
scoreboard players operation #t wp_rand *= #const10 mirror_calc
execute if score #t wp_rand <= @s wp_affix_skl_ying_sui_duo run function plm:mirror/skill/crossbow/yingsui/arrow
