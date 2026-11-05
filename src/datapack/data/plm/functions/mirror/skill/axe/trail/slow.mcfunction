# 影随 · 减速（@s=踩到影迹的敌人）
# 基础 15%：slowness I 1s（20t）。
# 「影随·滞」额外 8pp：wp_affix_skl_ying_sui_zhi 是 actual×10（40..80），
#   用 fixed UUID 的 generic.movement_speed 临时 modifier（multiply，−0.04..−0.08 = 总额 −4%..−8%）。
#   不能写 slowness II（−30% 过强，设计 §2.2.3 明确禁止）。
# 命中刷新：先 remove 同 UUID 的旧 modifier 再 add；到期由 trail/unspeed 清理。
effect give @s minecraft:slowness 1 0 true

execute if score #axe_skl mirror_axe_skl matches 40.. run attribute @s minecraft:generic.movement_speed modifier remove 6c1f0e2a-3b4d-4e5f-8a9b-0c1d2e3f4a5b
execute if score #axe_skl mirror_axe_skl matches 40..49 run attribute @s minecraft:generic.movement_speed modifier add 6c1f0e2a-3b4d-4e5f-8a9b-0c1d2e3f4a5b plm_ying_sui_zhi -0.04 multiply
execute if score #axe_skl mirror_axe_skl matches 50..59 run attribute @s minecraft:generic.movement_speed modifier add 6c1f0e2a-3b4d-4e5f-8a9b-0c1d2e3f4a5b plm_ying_sui_zhi -0.05 multiply
execute if score #axe_skl mirror_axe_skl matches 60..69 run attribute @s minecraft:generic.movement_speed modifier add 6c1f0e2a-3b4d-4e5f-8a9b-0c1d2e3f4a5b plm_ying_sui_zhi -0.06 multiply
execute if score #axe_skl mirror_axe_skl matches 70..79 run attribute @s minecraft:generic.movement_speed modifier add 6c1f0e2a-3b4d-4e5f-8a9b-0c1d2e3f4a5b plm_ying_sui_zhi -0.07 multiply
execute if score #axe_skl mirror_axe_skl matches 80.. run attribute @s minecraft:generic.movement_speed modifier add 6c1f0e2a-3b4d-4e5f-8a9b-0c1d2e3f4a5b plm_ying_sui_zhi -0.08 multiply

execute if score #axe_skl mirror_axe_skl matches 40.. run scoreboard players operation @s mirror_shadow_hit_due = #sys mirror_game_time
execute if score #axe_skl mirror_axe_skl matches 40.. run scoreboard players add @s mirror_shadow_hit_due 20
execute if score #axe_skl mirror_axe_skl matches 40.. run tag @s add mirror_axe_ying_sui

# 视觉：脚下暗红影（不是实体）
particle minecraft:dust 0.25 0.05 0.05 1 ~ ~0.15 ~ 0.25 0.1 0.25 0.01 4
