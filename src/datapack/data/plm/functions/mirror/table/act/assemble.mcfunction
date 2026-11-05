# 拼镜：需要 1 个镜胚 + 镜心(3武器/2防具) + 镜片(4武器/2防具) + 影尘≥20
# 判定是否有镜胚
scoreboard players set #t has_mold 0
execute if score #t cnt_mold_sword matches 1 run scoreboard players set #t has_mold 1
execute if score #t cnt_mold_axe matches 1 run scoreboard players set #t has_mold 1
execute if score #t cnt_mold_bow matches 1 run scoreboard players set #t has_mold 1
execute if score #t cnt_mold_crossbow matches 1 run scoreboard players set #t has_mold 1
execute if score #t cnt_mold_twin matches 1 run scoreboard players set #t has_mold 1
execute if score #t cnt_mold_rub matches 1 run scoreboard players set #t has_mold 1
execute if score #t cnt_mold_helmet matches 1 run scoreboard players set #t has_mold 1
execute if score #t cnt_mold_chest matches 1 run scoreboard players set #t has_mold 1
execute if score #t cnt_mold_legs matches 1 run scoreboard players set #t has_mold 1
execute if score #t cnt_mold_boots matches 1 run scoreboard players set #t has_mold 1
execute unless score #t has_mold matches 1 run return 0

# 拼镜只接受 1 个镜胚；多种镜胚同时放会拒绝，避免 consume_armor 按 cnt_mold_* 扣掉多枚
scoreboard players set #t tmp2 0
execute if score #t cnt_mold_sword matches 1 run scoreboard players add #t tmp2 1
execute if score #t cnt_mold_axe matches 1 run scoreboard players add #t tmp2 1
execute if score #t cnt_mold_bow matches 1 run scoreboard players add #t tmp2 1
execute if score #t cnt_mold_crossbow matches 1 run scoreboard players add #t tmp2 1
execute if score #t cnt_mold_twin matches 1 run scoreboard players add #t tmp2 1
execute if score #t cnt_mold_rub matches 1 run scoreboard players add #t tmp2 1
execute if score #t cnt_mold_helmet matches 1 run scoreboard players add #t tmp2 1
execute if score #t cnt_mold_chest matches 1 run scoreboard players add #t tmp2 1
execute if score #t cnt_mold_legs matches 1 run scoreboard players add #t tmp2 1
execute if score #t cnt_mold_boots matches 1 run scoreboard players add #t tmp2 1
execute if score #t tmp2 matches 2.. run tellraw @s {"text":"[磨镜台] 拼镜一次只能放 1 个镜胚，请先取回多余的镜胚。","color":"red"}
execute if score #t tmp2 matches 2.. run scoreboard players set #t diff 1
execute if score #t tmp2 matches 2.. run return 0

# 判定武器还是防具（有武器胚 → 武器）
scoreboard players set #t is_weapon 0
execute if score #t cnt_mold_sword matches 1 run scoreboard players set #t is_weapon 1
execute if score #t cnt_mold_axe matches 1 run scoreboard players set #t is_weapon 1
execute if score #t cnt_mold_bow matches 1 run scoreboard players set #t is_weapon 1
execute if score #t cnt_mold_crossbow matches 1 run scoreboard players set #t is_weapon 1
execute if score #t cnt_mold_twin matches 1 run scoreboard players set #t is_weapon 1
execute if score #t cnt_mold_rub matches 1 run scoreboard players set #t is_weapon 1

# 武器：设计 v0.1 §2.1 已取消镜心/镜缘，镜胚 + 镜片×4 + 影尘×10 直接走五纹 craft；
# 不能再被下面的旧“2 个镜心”门槛挡住。
execute if score #t is_weapon matches 1 run function plm:mirror/table/act/assemble_weapon
execute if score #t is_weapon matches 1 run return 0

# 以下仅防具：保留旧镜心/镜缘/影尘门槛
# 判定元素（哪种镜心有 2 个以上）
scoreboard players set #t elem -1
execute if score #t num_heart_metal matches 2.. run scoreboard players set #t elem 0
execute if score #t num_heart_wood matches 2.. run scoreboard players set #t elem 1
execute if score #t num_heart_water matches 2.. run scoreboard players set #t elem 2
execute if score #t num_heart_fire matches 2.. run scoreboard players set #t elem 3
execute if score #t num_heart_earth matches 2.. run scoreboard players set #t elem 4
execute unless score #t elem matches 0.. run return 0

execute if score #t is_weapon matches 0 run function plm:mirror/table/act/assemble_armor
