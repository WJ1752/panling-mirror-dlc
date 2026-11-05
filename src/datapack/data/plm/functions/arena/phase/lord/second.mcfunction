# 5s 蓄势倒计时；期间不召唤
execute if score #arena mirror_lord_timer matches 1.. run scoreboard players remove #arena mirror_lord_timer 1
scoreboard players operation #arena mirror_skill_timer = #arena mirror_lord_timer
execute if score #arena mirror_lord_timer matches 4 run bossbar set plm:mirror_boss name {"text":"镜主 · 蓄势 4s","color":"white"}
execute if score #arena mirror_lord_timer matches 3 run bossbar set plm:mirror_boss name {"text":"镜主 · 蓄势 3s","color":"white"}
execute if score #arena mirror_lord_timer matches 2 run bossbar set plm:mirror_boss name {"text":"镜主 · 蓄势 2s","color":"yellow"}
execute if score #arena mirror_lord_timer matches 1 run bossbar set plm:mirror_boss name {"text":"镜主 · 蓄势 1s","color":"red"}
execute if score #arena mirror_lord_timer matches 0 run function plm:arena/phase/lord/end
