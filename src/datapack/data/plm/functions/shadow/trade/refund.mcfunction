# 交易凭证只由NPC贸易回调消费。入口无marker时退款；成功的交易不会产生可转交入场物。
execute if score @s shadow_trade_kind matches 1 run give @s minecraft:gunpowder{id:"panling:mirror_dust",CustomModelData:390,display:{Name:'{"translate":"pl.item.name.mirror_dust"}'}} 1
execute if score @s shadow_trade_kind matches 2 run give @s minecraft:iron_ingot{id:"panling:silver_ticket",display:{Name:'{"translate":"pl.item.name.silver"}'}} 1
execute if score @s shadow_trade_kind matches 1 run tellraw @s {"text":"影域落点暂不可用，影尘已退还。","color":"yellow"}
execute if score @s shadow_trade_kind matches 2 run tellraw @s {"text":"影域落点暂不可用，银票已退还。","color":"yellow"}
