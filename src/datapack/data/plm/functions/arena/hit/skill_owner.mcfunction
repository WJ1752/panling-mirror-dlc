# 独立飞行的齐射/弩机箭由已核验 UUID 的 owner 调用。
execute if entity @s[tag=mirror_arena_skill_arrow] run function plm:arena/hit/ranged
execute unless entity @s[tag=mirror_arena_skill_arrow] run function plm:arena/hit/damage
