# 只在准入时检查 46×46 的内圈，发现已占用的毒格材质立即停止。
scoreboard players set #arena mirror_poison_need 0
function plm:arena/poison/check_tile
scoreboard players add #arena mirror_poison_i 1
execute if score #arena mirror_tmp matches 0 if score #arena mirror_poison_i matches ..45 positioned ~ ~ ~1 run function plm:arena/poison/check_row
