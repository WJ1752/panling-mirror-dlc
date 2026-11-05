# 战士公共管线已选中 warrior_tag。每次串行命中先结清前一次的本体 Health 写入。
execute unless score #arena mirror_arena_active matches 1 run return 0
execute unless entity @e[tag=mirror_arena_boss,tag=warrior_tag,limit=1] run return 0
execute as @e[tag=mirror_arena_boss,tag=warrior_tag,limit=1] run function plm:arena/hit/base_flush
function plm:arena/hit/check_member
execute unless entity @s[tag=mirror_arena_inside] run tag @e[tag=mirror_arena_boss,tag=warrior_tag] remove warrior_tag
execute unless entity @s[tag=mirror_arena_inside] run return 0
execute unless score #arena mirror_invuln matches 0 run tag @e[tag=mirror_arena_boss,tag=warrior_tag] remove warrior_tag
execute unless score #arena mirror_invuln matches 0 run return 0
execute if score @s mirror_is_ranged = #sys mirror_game_time run tag @e[tag=mirror_arena_boss,tag=warrior_tag] remove warrior_tag
execute if score @s mirror_is_ranged = #sys mirror_game_time run return 0
tag @s add mirror_arena_base_owner
tag @e[tag=mirror_arena_boss,tag=warrior_tag,limit=1] add mirror_arena_base_pending
scoreboard players set #base_override mirror_boss_damage 0
# 普通近战交给本体处理。只有可能越过 1024 实体血量的攻击才预演本体同一条计算链。
execute if score @s attack_damage1 matches 10240.. run function plm:arena/hit/base_limit
