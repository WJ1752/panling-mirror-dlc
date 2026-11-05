execute store result score #record dm_run run data get storage plm:domains scan[0].run
execute if score @s dm_run = #record dm_run unless score @s dm_paid = @s dm_run run function plm:domains/tomb/deliver
execute if score @s dm_paid = @s dm_run run return 0
data modify storage plm:domains scanned append from storage plm:domains scan[0]
data remove storage plm:domains scan[0]
execute if data storage plm:domains scan[0] run function plm:domains/tomb/check_receipt
