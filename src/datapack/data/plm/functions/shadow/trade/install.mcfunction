# @s为影域主城专用NPC；两项交易的结果item各自触发VillagerTrade advancement。
execute if entity @s[tag=plm_shadow_trade_installed] run return 0
data modify entity @s Offers.Recipes set value []
data modify entity @s Offers.Recipes append value {buy:{id:"minecraft:gunpowder",Count:1b,tag:{id:"panling:mirror_dust",CustomModelData:390,display:{Name:'{"translate":"pl.item.name.mirror_dust"}'}}},sell:{id:"minecraft:paper",Count:1b,tag:{plm_shadow_pass:"dust",display:{Name:'{"text":"前往影域 · 即时传送","color":"dark_purple","italic":false}'}}},maxUses:999999,rewardExp:0b}
data modify entity @s Offers.Recipes append value {buy:{id:"minecraft:iron_ingot",Count:1b,tag:{id:"panling:silver_ticket",display:{Name:'{"translate":"pl.item.name.silver"}'} }},sell:{id:"minecraft:paper",Count:1b,tag:{plm_shadow_pass:"silver",display:{Name:'{"text":"前往影域 · 即时传送","color":"dark_purple","italic":false}'}}},maxUses:999999,rewardExp:0b}
tag @s add plm_shadow_trade_installed
