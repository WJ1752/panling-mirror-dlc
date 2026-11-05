execute store result score #settle dm_age run data get storage plm:domains scan[0].age
execute store result score #settle dm_depth run data get storage plm:domains scan[0].depth
execute store result score #settle dm_deaths run data get storage plm:domains scan[0].deaths
function plm:domains/tower/reward
execute store result score #pending dm_party run data get storage plm:domains scan[0].pending
scoreboard players remove #pending dm_party 1
execute store result storage plm:domains scan[0].pending int 1 run scoreboard players get #pending dm_party
execute if score #pending dm_party matches 1.. run data modify storage plm:domains scanned append from storage plm:domains scan[0]
data remove storage plm:domains scan[0]
data modify storage plm:domains scanned append from storage plm:domains scan[]
data modify storage plm:domains tower_wins set from storage plm:domains scanned
