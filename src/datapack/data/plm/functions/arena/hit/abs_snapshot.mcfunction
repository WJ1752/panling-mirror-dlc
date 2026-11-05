scoreboard players set @s mirror_abs_seen 0
execute if score @s mirror_abs_dealt matches 1.. run scoreboard players operation @s mirror_abs_seen = @s mirror_abs_dealt
