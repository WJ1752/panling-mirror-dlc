# @s = 倒影；主人 >8 格且 5 格内无敌人时，每 2s（8 个 5t）回到主人身后 2 格
# 用 mirror_shadow_owner + 维度找主人，不再用最近的 @p（多人时不会跟错人）。
function plm:mirror/skill/shadow/owner_mark
execute at @s unless entity @e[tag=monster,distance=..5] unless entity @e[tag=mirror_boss,distance=..5] unless entity @e[tag=mirror_summon,distance=..5] if entity @a[tag=mirror_shadow_owner_ref,distance=8..] at @a[tag=mirror_shadow_owner_ref,limit=1] run tp @s ^ ^ ^-2 ~ ~
tag @a remove mirror_shadow_owner_ref
scoreboard players set @s mirror_shadow_move_timer 8
