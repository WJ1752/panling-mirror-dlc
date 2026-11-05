scoreboard objectives add dm_run dummy
scoreboard objectives add dm_state dummy
scoreboard objectives add dm_time dummy
scoreboard objectives add dm_depth dummy
scoreboard objectives add dm_party dummy
scoreboard objectives add dm_age dummy
scoreboard objectives add dm_paid dummy
scoreboard objectives add dm_back dummy
scoreboard objectives add dm_score dummy
scoreboard objectives add dm_deaths dummy
scoreboard objectives add dm_dead dummy
scoreboard objectives add dm_leave dummy
scoreboard objectives add dm_home dummy
scoreboard objectives add dm_died deathCount
execute in plm:domains run forceload add 0 0 31 31
scoreboard objectives add ds_stage dummy
scoreboard objectives add ds_count dummy
scoreboard objectives add ds_lamps dummy
scoreboard objectives add ds_hold dummy
scoreboard objectives add ds_cd dummy
scoreboard objectives add ds_window dummy
scoreboard objectives add ds_clock dummy
scoreboard objectives add ds_seq dummy
scoreboard objectives add ds_hp dummy
scoreboard objectives add ds_max dummy
scoreboard objectives add ds_wick dummy
scoreboard objectives add ds_phase dummy
scoreboard players set #base ds_hp 4200
scoreboard players set #unit ds_hp 10000
scoreboard players set #scale ds_hp 12
scoreboard players set #100 ds_hp 100
scoreboard players set #20 ds_hp 20
scoreboard players set #four ds_seq 4
scoreboard players set #five dm_score 5
scoreboard players set #ten dm_score 10
scoreboard players set #600 dm_score 600
scoreboard objectives add dm_max_fire dummy
scoreboard players add #fire dm_state 0
scoreboard objectives add dm_max_tomb dummy
scoreboard players add #tomb dm_state 0
scoreboard objectives add dm_max_tower dummy
scoreboard players add #tower dm_state 0
scoreboard objectives add dm_max_valley dummy
scoreboard players add #valley dm_state 0
scoreboard objectives add dm_max_mountain dummy
scoreboard players add #mountain dm_state 0
