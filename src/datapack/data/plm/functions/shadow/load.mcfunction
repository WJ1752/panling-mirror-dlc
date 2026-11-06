# Shadow gameplay scoreboards; ids remain in this namespace to avoid the generated domain objectives.
scoreboard objectives add shadow_died deathCount
scoreboard objectives add shadow_died_seen dummy
scoreboard objectives add shadow_leave_seen dummy
scoreboard objectives add shadow_trade_kind dummy
scoreboard objectives add shadow_tp dummy
scoreboard objectives add shadow_tmp dummy
scoreboard objectives add shadow_clock dummy
scoreboard objectives add shadow_mob_count dummy
scoreboard objectives add shadow_spawn_cd dummy
scoreboard objectives add shadow_player_spawn_cd dummy
scoreboard objectives add shadow_spawn_dir dummy
scoreboard objectives add shadow_arena_built dummy
scoreboard objectives add shadow_loaded dummy
scoreboard players set #shadow shadow_clock 0
scoreboard players set #shadow shadow_loaded 1
execute unless score #shadow shadow_arena_built matches 0.. run scoreboard players set #shadow shadow_arena_built 0

# Main city, town/signature, and underground arena are three independently loaded chunks.
execute in minecraft:overworld run forceload add 183 22
execute in minecraft:overworld run forceload add -704 -1450
execute in minecraft:overworld run forceload add -712 -1442
