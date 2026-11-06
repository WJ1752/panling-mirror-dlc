# villager_trade event proves the matching price/result completed. Never infer payment from clearing a paper token.
scoreboard players set @s shadow_tp 0
function plm:shadow/town_return/teleport
execute if score @s shadow_tp matches 1 run tag @s add plm_shadow_active
execute if score @s shadow_tp matches 1 run scoreboard players add @s shadow_died 0
execute if score @s shadow_tp matches 1 run scoreboard players add @s shadow_died_seen 0
execute if score @s shadow_tp matches 1 run scoreboard players add @s mirror_leave 0
execute if score @s shadow_tp matches 1 run scoreboard players add @s shadow_leave_seen 0
execute if score @s shadow_tp matches 1 run scoreboard players operation @s shadow_died_seen = @s shadow_died
execute if score @s shadow_tp matches 1 run scoreboard players operation @s shadow_leave_seen = @s mirror_leave
execute if score @s shadow_tp matches 1 run function plm:arena/reward/recover
execute if score @s shadow_tp matches 1 run tellraw @s {"text":"通行已确认，已传送至影域。","color":"aqua"}
execute if score @s shadow_tp matches 0 run function plm:shadow/trade/refund
clear @s minecraft:paper{plm_shadow_pass:"dust"} 1
clear @s minecraft:paper{plm_shadow_pass:"silver"} 1
