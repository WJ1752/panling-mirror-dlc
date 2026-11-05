# 自然每 tick 或下一次本体攻击前结清脚本写入。原版攻击单独从吸收值逐击结算。
execute as @e[tag=mirror_arena_boss,limit=1] run function plm:arena/hit/base_flush
execute as @e[tag=mirror_arena_boss,limit=1] unless data entity @s {AbsorptionAmount:2048.0f} run data modify entity @s AbsorptionAmount set value 2048.0f
