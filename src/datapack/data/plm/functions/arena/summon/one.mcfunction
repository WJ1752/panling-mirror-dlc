# 1-3=皇陵（色池 白/赤/青，随机）；4-5=妖塔（色池 黑/白，随机）
# 颜色池随机，再由 tag_color 按当前顶部/底部色判定 forbidden/allowed
function plm:arena/rand/1_5
scoreboard players operation #arena mirror_summon_type = #rng mirror_rand
# 皇陵：从 白(1)/赤(2)/青(3) 随机
execute if score #arena mirror_summon_type matches 1..3 run function plm:arena/rand/1_3
execute if score #arena mirror_summon_type matches 1..3 run scoreboard players operation #arena mirror_summon_color = #rng mirror_rand
# 妖塔：从 黑/白 随机 -> 黑(4) / 白(1)
execute if score #arena mirror_summon_type matches 4..5 run function plm:arena/rand/1_2
execute if score #arena mirror_summon_type matches 4..5 if score #rng mirror_rand matches 1 run scoreboard players set #arena mirror_summon_color 4
execute if score #arena mirror_summon_type matches 4..5 if score #rng mirror_rand matches 2 run scoreboard players set #arena mirror_summon_color 1
function plm:arena/summon/place
