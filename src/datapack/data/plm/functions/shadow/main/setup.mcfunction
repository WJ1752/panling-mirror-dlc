# NPC/返程锚需要等主城chunk完成forceload后创建；自恢复交易并保持永久可用。
execute in minecraft:overworld if loaded 183 43 22 unless entity @e[type=villager,tag=plm_shadow_entry_trader,limit=1] run summon villager 183.5 43 22.5 {VillagerData:{profession:"minecraft:cleric",level:5,type:"minecraft:plains"},CustomName:'{"text":"影域引路人","color":"dark_purple"}',CustomNameVisible:1b,Invulnerable:1b,PersistenceRequired:1b,NoAI:1b,Silent:1b,Tags:["panling","plm_shadow_entry_trader"]}
execute in minecraft:overworld if loaded 183 43 22 unless entity @e[type=marker,tag=plm_shadow_main_return,limit=1] run summon marker 179.5 43 19.5 {Tags:["plm_shadow_main_return"]}
execute in minecraft:overworld as @e[type=villager,tag=plm_shadow_entry_trader,tag=!plm_shadow_trade_installed] run function plm:shadow/trade/install
