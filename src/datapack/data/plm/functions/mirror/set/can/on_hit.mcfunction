# 残影 2 件套：远程命中 10% 概率留下 1s 残影，向最近敌人射一箭（20% 强度）
# 共享 plm:mirror/set/on_hit 是近战入口；这里用 #can_ranged 标记只让远程命中进入。
# 远程调用方：plm:mirror/skill/crossbow/lian/hit、plm:mirror/skill/crossbow/arrow/hit_check。
execute unless score #can_ranged mirror_skill_tmp matches 1 run return 0
scoreboard players set #can_ranged mirror_skill_tmp 0
function plm:mirror/set/can/ranged_proc
