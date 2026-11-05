# 每 8s：恶魂/熔岩怪/烈焰人 3-5 只，上限 8
scoreboard players set #arena mirror_summon_timer 8
execute if score #arena mirror_summon_count matches ..7 run function plm:arena/summon/phase3/start
