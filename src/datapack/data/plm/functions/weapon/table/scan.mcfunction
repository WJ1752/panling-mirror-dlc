# 扫描磨镜台：槽 0 主材料 / 槽 1 副材料 / 槽 3 核心 / 槽 8 影尘
# 只读，不扣料、不改物品
scoreboard players set #t wp_mat 0
scoreboard players set #t wp_have0 0
scoreboard players set #t wp_have1 0
scoreboard players set #t wp_have3 0
scoreboard players set #t wp_have8 0
scoreboard players set #t wp_edge_set -1
scoreboard players set #t wp_edge_set1 -1
scoreboard players set #t wp_sub_sand 0
scoreboard players set #t wp_core_kind 0
scoreboard players set #t wp_form 0
scoreboard players set #t wp_temper 0
scoreboard players set #t wp_mset 0
scoreboard players set #t wp_old_ver 0

# ---- 槽 0 主材料 ----
execute store result score #t wp_have0 run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t wp_mat 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t wp_mat 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t wp_mat 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t wp_mat 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t wp_mat 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t wp_mat 2
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t wp_mat 3
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t wp_mat 4
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t wp_edge_set 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t wp_mat 4
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t wp_edge_set 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t wp_mat 4
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t wp_edge_set 2
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t wp_mat 4
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t wp_edge_set 3
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t wp_mat 4
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t wp_edge_set 4
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t wp_mat 4
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t wp_edge_set 5
execute if data block ~ ~ ~ Items[{Slot:0b,id:"minecraft:flint"}] unless data block ~ ~ ~ Items[{Slot:0b}].tag.id run scoreboard players set #t wp_mat 5

# ---- 槽 1 副材料 ----
execute store result score #t wp_have1 run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t wp_sub_sand 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t wp_edge_set1 0
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t wp_edge_set1 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t wp_edge_set1 2
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t wp_edge_set1 3
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t wp_edge_set1 4
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t wp_edge_set1 5

# ---- 影尘：槽 8 为主，槽 7/6/4/2 可补足（单格上限 64）----
scoreboard players set #t wp_have8 0
scoreboard players set #t wp_dust8 0
execute store result score #t wp_dust8 run data get block ~ ~ ~ Items[{Slot:8b}].Count
execute unless data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t wp_dust8 0
scoreboard players operation #t wp_have8 += #t wp_dust8
scoreboard players set #t wp_dust7 0
execute store result score #t wp_dust7 run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute unless data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t wp_dust7 0
scoreboard players operation #t wp_have8 += #t wp_dust7
scoreboard players set #t wp_dust6 0
execute store result score #t wp_dust6 run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute unless data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t wp_dust6 0
scoreboard players operation #t wp_have8 += #t wp_dust6
scoreboard players set #t wp_dust4 0
execute store result score #t wp_dust4 run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute unless data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t wp_dust4 0
scoreboard players operation #t wp_have8 += #t wp_dust4
scoreboard players set #t wp_dust2 0
execute store result score #t wp_dust2 run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute unless data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t wp_dust2 0
scoreboard players operation #t wp_have8 += #t wp_dust2

# ---- 槽 3 核心：镜胚 / 镜武 ----
execute store result score #t wp_have3 run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t wp_core_kind 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t wp_form 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t wp_core_kind 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t wp_form 2
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t wp_core_kind 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t wp_form 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t wp_core_kind 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t wp_form 4
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t wp_core_kind 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t wp_form 5
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t wp_core_kind 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t wp_form 6
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,mirror_ver:2}}] run scoreboard players set #t wp_core_kind 2
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,mirror_ver:1}}] run scoreboard players set #t wp_old_ver 1
execute if score #t wp_core_kind matches 2 if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_sword7"}}] run scoreboard players set #t wp_form 1
execute if score #t wp_core_kind matches 2 if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_axe7"}}] run scoreboard players set #t wp_form 2
execute if score #t wp_core_kind matches 2 if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_bow7"}}] run scoreboard players set #t wp_form 3
execute if score #t wp_core_kind matches 2 if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_crossbow7"}}] run scoreboard players set #t wp_form 4
execute if score #t wp_core_kind matches 2 if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_furnace_twin7"}}] run scoreboard players set #t wp_form 5
execute if score #t wp_core_kind matches 2 if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_furnace_rub7"}}] run scoreboard players set #t wp_form 6
execute if score #t wp_core_kind matches 2 store result score #t wp_temper run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_temper
execute if score #t wp_core_kind matches 2 store result score #t wp_mset run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_set
