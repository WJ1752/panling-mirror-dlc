data modify storage plm:domains receipt set value {}
scoreboard players operation #pending dm_party = #tower dm_party
scoreboard players operation #pending dm_party -= #online dm_party
execute store result storage plm:domains receipt.pending int 1 run scoreboard players get #pending dm_party
execute store result storage plm:domains receipt.run int 1 run scoreboard players get @s dm_run
execute store result storage plm:domains receipt.depth int 1 run scoreboard players get @s dm_depth
execute store result storage plm:domains receipt.age int 1 run scoreboard players get @s dm_age
execute store result storage plm:domains receipt.deaths int 1 run scoreboard players get #tower dm_deaths
data modify storage plm:domains tower_wins append from storage plm:domains receipt
