# 本体近距离箭也可能经过普通攻击追加管线。丢弃同一发触发箭的追加伤害。
scoreboard players operation @s mirror_is_ranged = #sys mirror_game_time
execute if entity @s[tag=mirror_arena_base_owner] run tag @e[tag=mirror_arena_boss] remove mirror_arena_base_pending
execute at @e[tag=mirror_arena_anchor,limit=1] run function plm:arena/phase/lord/enter
