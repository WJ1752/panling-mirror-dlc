# 残影 2 件套远程命中结算（@s=玩家，远程命中已确认）
# 2 件套 = 防具件数 >= 2（武器不能凑 2 件套）
scoreboard players set #t mirror_set_tmp 3
function plm:mirror/set/can/tier
execute unless score @s mirror_set_count matches 2.. run return 0

# 10%（rand100 = 1..100）
function plm:weapon/util/rand100
scoreboard players set #tw_proc_cap mirror_set_tmp 10
execute if score #t wp_rand > #tw_proc_cap mirror_set_tmp run return 0

# 1s 残影视觉（storage 队列；0 常驻实体）
execute at @s run function plm:mirror/set/can/echo_add
# 向 8 格内最近敌人射一箭（20% 强度；走真实箭视觉 + 直接结算）
execute at @s run function plm:mirror/set/can/shadow_arrow
