# 播放反馈音效（成功/失败）
execute if score #t success matches 1 run playsound minecraft:block.amethyst_block.chime master @s ~ ~ ~ 1 1.4
execute if score #t success matches 0 run playsound minecraft:block.glass.break master @s ~ ~ ~ 0.6 0.8
scoreboard players set #t success 0
