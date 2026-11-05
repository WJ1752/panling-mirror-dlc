# 照心套装上限：2 件套（防具件数≥2）上限 3；4 件套（四件映度≥3，武器可当第 4 件）上限 5。
# @s=玩家。
# 防具件数 = mirror_set_a - (武器镜统==照心 ? mirror_set_weapon : 0)。
# mirror_set_weapon 是“武器已计入”的全局标记；只有武器镜统属于本套时才从本套件数里减。
scoreboard players set @s mirror_set_count 0
scoreboard players operation @s mirror_set_count = @s mirror_set_a
execute if score @s mirror_set matches 0 run scoreboard players operation @s mirror_set_count -= @s mirror_set_weapon
scoreboard players set @s mirror_heart_max 0
execute if score @s mirror_set_count matches 2.. run scoreboard players set @s mirror_heart_max 3
# 4 件套映度门槛：四件照心防具 ≥3；3 防具 + 同套满锻武器时武器视为满足
scoreboard players set #t mirror_set_tmp 0
function plm:mirror/set/tier_gate
execute if score #t ok matches 1 run scoreboard players set @s mirror_heart_max 5
