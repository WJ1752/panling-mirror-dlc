bossbar set plm:mirror_boss visible true
execute store result bossbar plm:mirror_boss value run scoreboard players get #boss mirror_boss_hp
execute if score #arena mirror_boss_phase matches 1 run bossbar set plm:mirror_boss name {"text":"影主","color":"white"}
execute if score #arena mirror_boss_phase matches 1 run bossbar set plm:mirror_boss color white
execute if score #arena mirror_boss_phase matches 2 run bossbar set plm:mirror_boss name {"text":"镜主","color":"white"}
execute if score #arena mirror_boss_phase matches 2 run bossbar set plm:mirror_boss color white
execute if score #arena mirror_boss_phase matches 3..4 run bossbar set plm:mirror_boss name {"text":"镜中倒影","color":"light_purple"}
execute if score #arena mirror_boss_phase matches 3 run bossbar set plm:mirror_boss color purple
execute if score #arena mirror_boss_phase matches 4 run bossbar set plm:mirror_boss color red
