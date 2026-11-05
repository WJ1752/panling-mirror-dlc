# 开发用：发放本体的金币（panling:gold），用于影商测试
give @s minecraft:gold_ingot{id:"panling:gold",display:{Name:'{"translate":"pl.item.name.gold"}'}} 64
tellraw @s {"text":"[镜中倒影] 已发放 64 枚金币（panling:gold）。","color":"aqua"}
