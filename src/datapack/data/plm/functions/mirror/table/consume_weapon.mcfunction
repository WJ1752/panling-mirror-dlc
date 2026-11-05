# 扣：镜胚1 镜心3 镜片4 影尘20（按扫描记录的槽号）
execute if score #t cnt_mold_sword matches 1 run function plm:mirror/table/take/mold_sword
execute if score #t cnt_mold_axe matches 1 run function plm:mirror/table/take/mold_axe
execute if score #t cnt_mold_bow matches 1 run function plm:mirror/table/take/mold_bow
execute if score #t cnt_mold_crossbow matches 1 run function plm:mirror/table/take/mold_crossbow
execute if score #t cnt_mold_twin matches 1 run function plm:mirror/table/take/mold_twin
execute if score #t cnt_mold_rub matches 1 run function plm:mirror/table/take/mold_rub
execute if score #t elem matches 0 run function plm:mirror/table/take/heart_metal_3
execute if score #t elem matches 1 run function plm:mirror/table/take/heart_wood_3
execute if score #t elem matches 2 run function plm:mirror/table/take/heart_water_3
execute if score #t elem matches 3 run function plm:mirror/table/take/heart_fire_3
execute if score #t elem matches 4 run function plm:mirror/table/take/heart_earth_3
execute if score #t elem matches 0 run function plm:mirror/table/take/shard_metal_4
execute if score #t elem matches 1 run function plm:mirror/table/take/shard_wood_4
execute if score #t elem matches 2 run function plm:mirror/table/take/shard_water_4
execute if score #t elem matches 3 run function plm:mirror/table/take/shard_fire_4
execute if score #t elem matches 4 run function plm:mirror/table/take/shard_earth_4
function plm:mirror/table/take/dust_20
