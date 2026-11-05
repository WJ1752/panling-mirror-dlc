# 每 8s：4-6 只，场上上限 12
scoreboard players set #arena mirror_summon_timer 8
execute if score #arena mirror_summon_count matches ..11 run function plm:arena/summon/wave/start
