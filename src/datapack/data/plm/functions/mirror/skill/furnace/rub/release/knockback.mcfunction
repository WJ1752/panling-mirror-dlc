# 兽：击退 3 格（@s = 目标）
# 1.20.1 没有 /knockback：先面向施法者，再沿自身朝向后退 3 格（位移实现，不是抛射物式的物理击退）
execute unless entity @a[tag=rub_caster,limit=1] run return 0
execute at @s run tp @s ~ ~ ~ facing entity @a[tag=rub_caster,limit=1] eyes
execute at @s positioned ^ ^ ^-3 run tp @s ~ ~ ~
