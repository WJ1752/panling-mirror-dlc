# 防具拼镜：镜心 ≥2，镜片 ≥2，镜缘 1，影尘 ≥20
scoreboard players set #t have_heart 0
scoreboard players set #t have_shard 0
execute if score #t elem matches 0 run scoreboard players operation #t have_heart = #t num_heart_metal
execute if score #t elem matches 1 run scoreboard players operation #t have_heart = #t num_heart_wood
execute if score #t elem matches 2 run scoreboard players operation #t have_heart = #t num_heart_water
execute if score #t elem matches 3 run scoreboard players operation #t have_heart = #t num_heart_fire
execute if score #t elem matches 4 run scoreboard players operation #t have_heart = #t num_heart_earth
execute if score #t elem matches 0 run scoreboard players operation #t have_shard = #t num_shard_metal
execute if score #t elem matches 1 run scoreboard players operation #t have_shard = #t num_shard_wood
execute if score #t elem matches 2 run scoreboard players operation #t have_shard = #t num_shard_water
execute if score #t elem matches 3 run scoreboard players operation #t have_shard = #t num_shard_fire
execute if score #t elem matches 4 run scoreboard players operation #t have_shard = #t num_shard_earth
execute if score #t have_heart matches ..1 run return 0
execute if score #t have_shard matches ..1 run return 0
execute if score #t num_dust matches ..19 run return 0

# 镜缘（必须有一种）
scoreboard players set #t edge -1
execute if score #t cnt_edge_zhao matches 1 run scoreboard players set #t edge 0
execute if score #t cnt_edge_lie matches 1 run scoreboard players set #t edge 1
execute if score #t cnt_edge_jing matches 1 run scoreboard players set #t edge 2
execute if score #t cnt_edge_can matches 1 run scoreboard players set #t edge 3
execute if score #t cnt_edge_twin matches 1 run scoreboard players set #t edge 4
execute if score #t cnt_edge_rub matches 1 run scoreboard players set #t edge 5
execute unless score #t edge matches 0.. run return 0

# 部位
scoreboard players set #t part 0
execute if score #t cnt_mold_helmet matches 1 run scoreboard players set #t part 0
execute if score #t cnt_mold_chest matches 1 run scoreboard players set #t part 1
execute if score #t cnt_mold_legs matches 1 run scoreboard players set #t part 2
execute if score #t cnt_mold_boots matches 1 run scoreboard players set #t part 3

function plm:mirror/table/output/armor
# 拼镜产物落在第 5 格：直接重写槽 5，避免槽 3 有其它镜装时误写
function plm:mirror/table/lore/at5
function plm:mirror/table/consume_armor

scoreboard players set #t success 1
tellraw @s {"text":"[磨镜台] 拼镜完成——镜装已出现在右下角输出格。","color":"aqua"}
