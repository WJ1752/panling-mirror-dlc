# 残影套装单玩家 5t（@s = 玩家）
scoreboard players set #t mirror_set_tmp 3
function plm:mirror/set/can/tier

# 弩机上限：基础 1；2 件套 +1；真影律额外 +1（2 件套 + 真影律 = 3）
scoreboard players set @s mirror_turret_max 1
execute if score @s mirror_set_count matches 2.. run scoreboard players add @s mirror_turret_max 1
execute if score @s mirror_true_law matches 1 run scoreboard players add @s mirror_turret_max 1

# 4 件套装填 buff：mirror_crossbow_4_bonus = 100 + 原始 Quick Charge 等级
# 100.. 表示“本次 buff 已记录原始等级”，直到 qc_restore 还原后才清 0。
execute if score @s mirror_crossbow_4_bonus matches 100.. if score @s mirror_crossbow_4_until >= #sys mirror_game_time run function plm:mirror/set/can/qc_apply
execute if score @s mirror_crossbow_4_bonus matches 100.. if score @s mirror_crossbow_4_until < #sys mirror_game_time run function plm:mirror/set/can/qc_restore
