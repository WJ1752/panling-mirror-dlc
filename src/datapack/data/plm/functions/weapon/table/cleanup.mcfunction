# 操作后反馈
execute if score #t wp_success matches 1 run playsound minecraft:block.amethyst_block.chime master @s ~ ~ ~ 1 1.4
execute if score #t wp_success matches 0 run playsound minecraft:block.glass.break master @s ~ ~ ~ 0.6 0.8
scoreboard players set #t wp_success 0
scoreboard players set #t wp_msg 0
scoreboard players set #t wp_abort 0
