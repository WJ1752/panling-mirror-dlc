# 扣：镜胚1 镜心2 镜片2 镜缘1 影尘20
execute if score #t cnt_mold_helmet matches 1 run function plm:mirror/table/take/mold_helmet
execute if score #t cnt_mold_chest matches 1 run function plm:mirror/table/take/mold_chest
execute if score #t cnt_mold_legs matches 1 run function plm:mirror/table/take/mold_legs
execute if score #t cnt_mold_boots matches 1 run function plm:mirror/table/take/mold_boots
execute if score #t elem matches 0 run function plm:mirror/table/take/heart_metal_2
execute if score #t elem matches 1 run function plm:mirror/table/take/heart_wood_2
execute if score #t elem matches 2 run function plm:mirror/table/take/heart_water_2
execute if score #t elem matches 3 run function plm:mirror/table/take/heart_fire_2
execute if score #t elem matches 4 run function plm:mirror/table/take/heart_earth_2
execute if score #t elem matches 0 run function plm:mirror/table/take/shard_metal_2
execute if score #t elem matches 1 run function plm:mirror/table/take/shard_wood_2
execute if score #t elem matches 2 run function plm:mirror/table/take/shard_water_2
execute if score #t elem matches 3 run function plm:mirror/table/take/shard_fire_2
execute if score #t elem matches 4 run function plm:mirror/table/take/shard_earth_2
execute if score #t edge matches 0 run function plm:mirror/table/take/edge_zhao
execute if score #t edge matches 1 run function plm:mirror/table/take/edge_lie
execute if score #t edge matches 2 run function plm:mirror/table/take/edge_jing
execute if score #t edge matches 3 run function plm:mirror/table/take/edge_can
execute if score #t edge matches 4 run function plm:mirror/table/take/edge_twin
execute if score #t edge matches 5 run function plm:mirror/table/take/edge_rub
function plm:mirror/table/take/dust_20
