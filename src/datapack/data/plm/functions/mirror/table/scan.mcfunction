# 扫描投掷器 9 格，记录各类材料的槽位与数量（0..8）
# mold_sword
scoreboard players set #t cnt_mold_sword 0
scoreboard players set #t num_mold_sword 0
scoreboard players set #t slot_mold_sword -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t slot_mold_sword 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t cnt_mold_sword 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_sword"}}] store result score #t num_mold_sword run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t slot_mold_sword 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t cnt_mold_sword 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_sword"}}] store result score #t num_mold_sword run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t slot_mold_sword 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t cnt_mold_sword 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_sword"}}] store result score #t num_mold_sword run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t slot_mold_sword 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t cnt_mold_sword 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_sword"}}] store result score #t num_mold_sword run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t slot_mold_sword 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t cnt_mold_sword 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_sword"}}] store result score #t num_mold_sword run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t slot_mold_sword 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t cnt_mold_sword 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_sword"}}] store result score #t num_mold_sword run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t slot_mold_sword 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t cnt_mold_sword 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_sword"}}] store result score #t num_mold_sword run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t slot_mold_sword 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t cnt_mold_sword 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_sword"}}] store result score #t num_mold_sword run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t slot_mold_sword 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_sword"}}] run scoreboard players set #t cnt_mold_sword 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_sword"}}] store result score #t num_mold_sword run data get block ~ ~ ~ Items[{Slot:8b}].Count
# mold_axe
scoreboard players set #t cnt_mold_axe 0
scoreboard players set #t num_mold_axe 0
scoreboard players set #t slot_mold_axe -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t slot_mold_axe 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t cnt_mold_axe 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_axe"}}] store result score #t num_mold_axe run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t slot_mold_axe 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t cnt_mold_axe 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_axe"}}] store result score #t num_mold_axe run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t slot_mold_axe 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t cnt_mold_axe 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_axe"}}] store result score #t num_mold_axe run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t slot_mold_axe 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t cnt_mold_axe 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_axe"}}] store result score #t num_mold_axe run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t slot_mold_axe 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t cnt_mold_axe 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_axe"}}] store result score #t num_mold_axe run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t slot_mold_axe 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t cnt_mold_axe 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_axe"}}] store result score #t num_mold_axe run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t slot_mold_axe 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t cnt_mold_axe 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_axe"}}] store result score #t num_mold_axe run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t slot_mold_axe 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t cnt_mold_axe 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_axe"}}] store result score #t num_mold_axe run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t slot_mold_axe 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_axe"}}] run scoreboard players set #t cnt_mold_axe 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_axe"}}] store result score #t num_mold_axe run data get block ~ ~ ~ Items[{Slot:8b}].Count
# mold_bow
scoreboard players set #t cnt_mold_bow 0
scoreboard players set #t num_mold_bow 0
scoreboard players set #t slot_mold_bow -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t slot_mold_bow 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t cnt_mold_bow 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_bow"}}] store result score #t num_mold_bow run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t slot_mold_bow 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t cnt_mold_bow 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_bow"}}] store result score #t num_mold_bow run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t slot_mold_bow 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t cnt_mold_bow 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_bow"}}] store result score #t num_mold_bow run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t slot_mold_bow 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t cnt_mold_bow 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_bow"}}] store result score #t num_mold_bow run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t slot_mold_bow 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t cnt_mold_bow 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_bow"}}] store result score #t num_mold_bow run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t slot_mold_bow 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t cnt_mold_bow 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_bow"}}] store result score #t num_mold_bow run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t slot_mold_bow 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t cnt_mold_bow 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_bow"}}] store result score #t num_mold_bow run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t slot_mold_bow 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t cnt_mold_bow 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_bow"}}] store result score #t num_mold_bow run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t slot_mold_bow 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_bow"}}] run scoreboard players set #t cnt_mold_bow 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_bow"}}] store result score #t num_mold_bow run data get block ~ ~ ~ Items[{Slot:8b}].Count
# mold_crossbow
scoreboard players set #t cnt_mold_crossbow 0
scoreboard players set #t num_mold_crossbow 0
scoreboard players set #t slot_mold_crossbow -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t slot_mold_crossbow 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t cnt_mold_crossbow 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_crossbow"}}] store result score #t num_mold_crossbow run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t slot_mold_crossbow 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t cnt_mold_crossbow 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_crossbow"}}] store result score #t num_mold_crossbow run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t slot_mold_crossbow 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t cnt_mold_crossbow 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_crossbow"}}] store result score #t num_mold_crossbow run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t slot_mold_crossbow 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t cnt_mold_crossbow 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_crossbow"}}] store result score #t num_mold_crossbow run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t slot_mold_crossbow 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t cnt_mold_crossbow 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_crossbow"}}] store result score #t num_mold_crossbow run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t slot_mold_crossbow 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t cnt_mold_crossbow 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_crossbow"}}] store result score #t num_mold_crossbow run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t slot_mold_crossbow 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t cnt_mold_crossbow 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_crossbow"}}] store result score #t num_mold_crossbow run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t slot_mold_crossbow 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t cnt_mold_crossbow 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_crossbow"}}] store result score #t num_mold_crossbow run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t slot_mold_crossbow 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_crossbow"}}] run scoreboard players set #t cnt_mold_crossbow 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_crossbow"}}] store result score #t num_mold_crossbow run data get block ~ ~ ~ Items[{Slot:8b}].Count
# mold_twin
scoreboard players set #t cnt_mold_twin 0
scoreboard players set #t num_mold_twin 0
scoreboard players set #t slot_mold_twin -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t slot_mold_twin 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t cnt_mold_twin 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_furnace_twin"}}] store result score #t num_mold_twin run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t slot_mold_twin 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t cnt_mold_twin 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_furnace_twin"}}] store result score #t num_mold_twin run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t slot_mold_twin 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t cnt_mold_twin 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_furnace_twin"}}] store result score #t num_mold_twin run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t slot_mold_twin 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t cnt_mold_twin 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_furnace_twin"}}] store result score #t num_mold_twin run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t slot_mold_twin 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t cnt_mold_twin 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_furnace_twin"}}] store result score #t num_mold_twin run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t slot_mold_twin 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t cnt_mold_twin 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_furnace_twin"}}] store result score #t num_mold_twin run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t slot_mold_twin 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t cnt_mold_twin 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_furnace_twin"}}] store result score #t num_mold_twin run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t slot_mold_twin 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t cnt_mold_twin 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_furnace_twin"}}] store result score #t num_mold_twin run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t slot_mold_twin 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_furnace_twin"}}] run scoreboard players set #t cnt_mold_twin 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_furnace_twin"}}] store result score #t num_mold_twin run data get block ~ ~ ~ Items[{Slot:8b}].Count
# mold_rub
scoreboard players set #t cnt_mold_rub 0
scoreboard players set #t num_mold_rub 0
scoreboard players set #t slot_mold_rub -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t slot_mold_rub 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t cnt_mold_rub 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_furnace_rub"}}] store result score #t num_mold_rub run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t slot_mold_rub 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t cnt_mold_rub 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_furnace_rub"}}] store result score #t num_mold_rub run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t slot_mold_rub 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t cnt_mold_rub 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_furnace_rub"}}] store result score #t num_mold_rub run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t slot_mold_rub 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t cnt_mold_rub 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_furnace_rub"}}] store result score #t num_mold_rub run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t slot_mold_rub 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t cnt_mold_rub 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_furnace_rub"}}] store result score #t num_mold_rub run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t slot_mold_rub 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t cnt_mold_rub 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_furnace_rub"}}] store result score #t num_mold_rub run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t slot_mold_rub 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t cnt_mold_rub 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_furnace_rub"}}] store result score #t num_mold_rub run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t slot_mold_rub 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t cnt_mold_rub 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_furnace_rub"}}] store result score #t num_mold_rub run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t slot_mold_rub 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_furnace_rub"}}] run scoreboard players set #t cnt_mold_rub 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_furnace_rub"}}] store result score #t num_mold_rub run data get block ~ ~ ~ Items[{Slot:8b}].Count
# mold_helmet
scoreboard players set #t cnt_mold_helmet 0
scoreboard players set #t num_mold_helmet 0
scoreboard players set #t slot_mold_helmet -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t slot_mold_helmet 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t cnt_mold_helmet 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_helmet"}}] store result score #t num_mold_helmet run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t slot_mold_helmet 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t cnt_mold_helmet 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_helmet"}}] store result score #t num_mold_helmet run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t slot_mold_helmet 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t cnt_mold_helmet 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_helmet"}}] store result score #t num_mold_helmet run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t slot_mold_helmet 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t cnt_mold_helmet 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_helmet"}}] store result score #t num_mold_helmet run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t slot_mold_helmet 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t cnt_mold_helmet 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_helmet"}}] store result score #t num_mold_helmet run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t slot_mold_helmet 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t cnt_mold_helmet 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_helmet"}}] store result score #t num_mold_helmet run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t slot_mold_helmet 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t cnt_mold_helmet 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_helmet"}}] store result score #t num_mold_helmet run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t slot_mold_helmet 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t cnt_mold_helmet 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_helmet"}}] store result score #t num_mold_helmet run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t slot_mold_helmet 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_helmet"}}] run scoreboard players set #t cnt_mold_helmet 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_helmet"}}] store result score #t num_mold_helmet run data get block ~ ~ ~ Items[{Slot:8b}].Count
# mold_chest
scoreboard players set #t cnt_mold_chest 0
scoreboard players set #t num_mold_chest 0
scoreboard players set #t slot_mold_chest -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t slot_mold_chest 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t cnt_mold_chest 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_chestplate"}}] store result score #t num_mold_chest run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t slot_mold_chest 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t cnt_mold_chest 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_chestplate"}}] store result score #t num_mold_chest run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t slot_mold_chest 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t cnt_mold_chest 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_chestplate"}}] store result score #t num_mold_chest run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t slot_mold_chest 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t cnt_mold_chest 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_chestplate"}}] store result score #t num_mold_chest run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t slot_mold_chest 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t cnt_mold_chest 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_chestplate"}}] store result score #t num_mold_chest run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t slot_mold_chest 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t cnt_mold_chest 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_chestplate"}}] store result score #t num_mold_chest run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t slot_mold_chest 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t cnt_mold_chest 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_chestplate"}}] store result score #t num_mold_chest run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t slot_mold_chest 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t cnt_mold_chest 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_chestplate"}}] store result score #t num_mold_chest run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t slot_mold_chest 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_chestplate"}}] run scoreboard players set #t cnt_mold_chest 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_chestplate"}}] store result score #t num_mold_chest run data get block ~ ~ ~ Items[{Slot:8b}].Count
# mold_legs
scoreboard players set #t cnt_mold_legs 0
scoreboard players set #t num_mold_legs 0
scoreboard players set #t slot_mold_legs -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t slot_mold_legs 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t cnt_mold_legs 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_leggings"}}] store result score #t num_mold_legs run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t slot_mold_legs 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t cnt_mold_legs 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_leggings"}}] store result score #t num_mold_legs run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t slot_mold_legs 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t cnt_mold_legs 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_leggings"}}] store result score #t num_mold_legs run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t slot_mold_legs 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t cnt_mold_legs 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_leggings"}}] store result score #t num_mold_legs run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t slot_mold_legs 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t cnt_mold_legs 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_leggings"}}] store result score #t num_mold_legs run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t slot_mold_legs 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t cnt_mold_legs 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_leggings"}}] store result score #t num_mold_legs run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t slot_mold_legs 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t cnt_mold_legs 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_leggings"}}] store result score #t num_mold_legs run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t slot_mold_legs 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t cnt_mold_legs 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_leggings"}}] store result score #t num_mold_legs run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t slot_mold_legs 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_leggings"}}] run scoreboard players set #t cnt_mold_legs 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_leggings"}}] store result score #t num_mold_legs run data get block ~ ~ ~ Items[{Slot:8b}].Count
# mold_boots
scoreboard players set #t cnt_mold_boots 0
scoreboard players set #t num_mold_boots 0
scoreboard players set #t slot_mold_boots -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t slot_mold_boots 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t cnt_mold_boots 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_mold_boots"}}] store result score #t num_mold_boots run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t slot_mold_boots 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t cnt_mold_boots 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_mold_boots"}}] store result score #t num_mold_boots run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t slot_mold_boots 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t cnt_mold_boots 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_mold_boots"}}] store result score #t num_mold_boots run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t slot_mold_boots 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t cnt_mold_boots 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_mold_boots"}}] store result score #t num_mold_boots run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t slot_mold_boots 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t cnt_mold_boots 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_mold_boots"}}] store result score #t num_mold_boots run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t slot_mold_boots 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t cnt_mold_boots 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_mold_boots"}}] store result score #t num_mold_boots run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t slot_mold_boots 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t cnt_mold_boots 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_mold_boots"}}] store result score #t num_mold_boots run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t slot_mold_boots 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t cnt_mold_boots 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_mold_boots"}}] store result score #t num_mold_boots run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t slot_mold_boots 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_boots"}}] run scoreboard players set #t cnt_mold_boots 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_mold_boots"}}] store result score #t num_mold_boots run data get block ~ ~ ~ Items[{Slot:8b}].Count
# heart_metal
scoreboard players set #t cnt_heart_metal 0
scoreboard players set #t num_heart_metal 0
scoreboard players set #t slot_heart_metal -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t slot_heart_metal 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t cnt_heart_metal 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_heart_metal"}}] store result score #t num_heart_metal run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t slot_heart_metal 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t cnt_heart_metal 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_heart_metal"}}] store result score #t num_heart_metal run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t slot_heart_metal 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t cnt_heart_metal 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_heart_metal"}}] store result score #t num_heart_metal run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t slot_heart_metal 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t cnt_heart_metal 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_heart_metal"}}] store result score #t num_heart_metal run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t slot_heart_metal 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t cnt_heart_metal 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_heart_metal"}}] store result score #t num_heart_metal run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t slot_heart_metal 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t cnt_heart_metal 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_heart_metal"}}] store result score #t num_heart_metal run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t slot_heart_metal 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t cnt_heart_metal 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_metal"}}] store result score #t num_heart_metal run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t slot_heart_metal 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t cnt_heart_metal 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_heart_metal"}}] store result score #t num_heart_metal run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t slot_heart_metal 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_heart_metal"}}] run scoreboard players set #t cnt_heart_metal 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_heart_metal"}}] store result score #t num_heart_metal run data get block ~ ~ ~ Items[{Slot:8b}].Count
# heart_wood
scoreboard players set #t cnt_heart_wood 0
scoreboard players set #t num_heart_wood 0
scoreboard players set #t slot_heart_wood -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t slot_heart_wood 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t cnt_heart_wood 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_heart_wood"}}] store result score #t num_heart_wood run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t slot_heart_wood 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t cnt_heart_wood 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_heart_wood"}}] store result score #t num_heart_wood run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t slot_heart_wood 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t cnt_heart_wood 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_heart_wood"}}] store result score #t num_heart_wood run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t slot_heart_wood 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t cnt_heart_wood 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_heart_wood"}}] store result score #t num_heart_wood run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t slot_heart_wood 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t cnt_heart_wood 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_heart_wood"}}] store result score #t num_heart_wood run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t slot_heart_wood 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t cnt_heart_wood 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_heart_wood"}}] store result score #t num_heart_wood run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t slot_heart_wood 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t cnt_heart_wood 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_wood"}}] store result score #t num_heart_wood run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t slot_heart_wood 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t cnt_heart_wood 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_heart_wood"}}] store result score #t num_heart_wood run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t slot_heart_wood 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_heart_wood"}}] run scoreboard players set #t cnt_heart_wood 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_heart_wood"}}] store result score #t num_heart_wood run data get block ~ ~ ~ Items[{Slot:8b}].Count
# heart_water
scoreboard players set #t cnt_heart_water 0
scoreboard players set #t num_heart_water 0
scoreboard players set #t slot_heart_water -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t slot_heart_water 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t cnt_heart_water 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_heart_water"}}] store result score #t num_heart_water run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t slot_heart_water 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t cnt_heart_water 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_heart_water"}}] store result score #t num_heart_water run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t slot_heart_water 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t cnt_heart_water 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_heart_water"}}] store result score #t num_heart_water run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t slot_heart_water 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t cnt_heart_water 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_heart_water"}}] store result score #t num_heart_water run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t slot_heart_water 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t cnt_heart_water 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_heart_water"}}] store result score #t num_heart_water run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t slot_heart_water 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t cnt_heart_water 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_heart_water"}}] store result score #t num_heart_water run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t slot_heart_water 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t cnt_heart_water 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_water"}}] store result score #t num_heart_water run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t slot_heart_water 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t cnt_heart_water 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_heart_water"}}] store result score #t num_heart_water run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t slot_heart_water 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_heart_water"}}] run scoreboard players set #t cnt_heart_water 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_heart_water"}}] store result score #t num_heart_water run data get block ~ ~ ~ Items[{Slot:8b}].Count
# heart_fire
scoreboard players set #t cnt_heart_fire 0
scoreboard players set #t num_heart_fire 0
scoreboard players set #t slot_heart_fire -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t slot_heart_fire 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t cnt_heart_fire 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_heart_fire"}}] store result score #t num_heart_fire run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t slot_heart_fire 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t cnt_heart_fire 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_heart_fire"}}] store result score #t num_heart_fire run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t slot_heart_fire 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t cnt_heart_fire 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_heart_fire"}}] store result score #t num_heart_fire run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t slot_heart_fire 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t cnt_heart_fire 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_heart_fire"}}] store result score #t num_heart_fire run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t slot_heart_fire 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t cnt_heart_fire 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_heart_fire"}}] store result score #t num_heart_fire run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t slot_heart_fire 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t cnt_heart_fire 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_heart_fire"}}] store result score #t num_heart_fire run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t slot_heart_fire 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t cnt_heart_fire 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_fire"}}] store result score #t num_heart_fire run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t slot_heart_fire 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t cnt_heart_fire 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_heart_fire"}}] store result score #t num_heart_fire run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t slot_heart_fire 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_heart_fire"}}] run scoreboard players set #t cnt_heart_fire 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_heart_fire"}}] store result score #t num_heart_fire run data get block ~ ~ ~ Items[{Slot:8b}].Count
# heart_earth
scoreboard players set #t cnt_heart_earth 0
scoreboard players set #t num_heart_earth 0
scoreboard players set #t slot_heart_earth -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t slot_heart_earth 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t cnt_heart_earth 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_heart_earth"}}] store result score #t num_heart_earth run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t slot_heart_earth 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t cnt_heart_earth 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_heart_earth"}}] store result score #t num_heart_earth run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t slot_heart_earth 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t cnt_heart_earth 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_heart_earth"}}] store result score #t num_heart_earth run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t slot_heart_earth 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t cnt_heart_earth 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_heart_earth"}}] store result score #t num_heart_earth run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t slot_heart_earth 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t cnt_heart_earth 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_heart_earth"}}] store result score #t num_heart_earth run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t slot_heart_earth 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t cnt_heart_earth 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_heart_earth"}}] store result score #t num_heart_earth run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t slot_heart_earth 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t cnt_heart_earth 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_heart_earth"}}] store result score #t num_heart_earth run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t slot_heart_earth 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t cnt_heart_earth 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_heart_earth"}}] store result score #t num_heart_earth run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t slot_heart_earth 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_heart_earth"}}] run scoreboard players set #t cnt_heart_earth 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_heart_earth"}}] store result score #t num_heart_earth run data get block ~ ~ ~ Items[{Slot:8b}].Count
# shard_metal
scoreboard players set #t cnt_shard_metal 0
scoreboard players set #t num_shard_metal 0
scoreboard players set #t slot_shard_metal -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t slot_shard_metal 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t cnt_shard_metal 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_metal"}}] store result score #t num_shard_metal run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t slot_shard_metal 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t cnt_shard_metal 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_shard_metal"}}] store result score #t num_shard_metal run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t slot_shard_metal 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t cnt_shard_metal 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_shard_metal"}}] store result score #t num_shard_metal run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t slot_shard_metal 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t cnt_shard_metal 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_shard_metal"}}] store result score #t num_shard_metal run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t slot_shard_metal 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t cnt_shard_metal 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_shard_metal"}}] store result score #t num_shard_metal run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t slot_shard_metal 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t cnt_shard_metal 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_shard_metal"}}] store result score #t num_shard_metal run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t slot_shard_metal 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t cnt_shard_metal 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_shard_metal"}}] store result score #t num_shard_metal run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t slot_shard_metal 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t cnt_shard_metal 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_shard_metal"}}] store result score #t num_shard_metal run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t slot_shard_metal 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_shard_metal"}}] run scoreboard players set #t cnt_shard_metal 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_shard_metal"}}] store result score #t num_shard_metal run data get block ~ ~ ~ Items[{Slot:8b}].Count
# shard_wood
scoreboard players set #t cnt_shard_wood 0
scoreboard players set #t num_shard_wood 0
scoreboard players set #t slot_shard_wood -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t slot_shard_wood 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t cnt_shard_wood 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_wood"}}] store result score #t num_shard_wood run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t slot_shard_wood 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t cnt_shard_wood 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_shard_wood"}}] store result score #t num_shard_wood run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t slot_shard_wood 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t cnt_shard_wood 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_shard_wood"}}] store result score #t num_shard_wood run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t slot_shard_wood 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t cnt_shard_wood 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_shard_wood"}}] store result score #t num_shard_wood run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t slot_shard_wood 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t cnt_shard_wood 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_shard_wood"}}] store result score #t num_shard_wood run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t slot_shard_wood 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t cnt_shard_wood 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_shard_wood"}}] store result score #t num_shard_wood run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t slot_shard_wood 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t cnt_shard_wood 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_shard_wood"}}] store result score #t num_shard_wood run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t slot_shard_wood 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t cnt_shard_wood 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_shard_wood"}}] store result score #t num_shard_wood run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t slot_shard_wood 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_shard_wood"}}] run scoreboard players set #t cnt_shard_wood 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_shard_wood"}}] store result score #t num_shard_wood run data get block ~ ~ ~ Items[{Slot:8b}].Count
# shard_water
scoreboard players set #t cnt_shard_water 0
scoreboard players set #t num_shard_water 0
scoreboard players set #t slot_shard_water -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t slot_shard_water 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t cnt_shard_water 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_water"}}] store result score #t num_shard_water run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t slot_shard_water 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t cnt_shard_water 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_shard_water"}}] store result score #t num_shard_water run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t slot_shard_water 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t cnt_shard_water 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_shard_water"}}] store result score #t num_shard_water run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t slot_shard_water 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t cnt_shard_water 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_shard_water"}}] store result score #t num_shard_water run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t slot_shard_water 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t cnt_shard_water 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_shard_water"}}] store result score #t num_shard_water run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t slot_shard_water 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t cnt_shard_water 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_shard_water"}}] store result score #t num_shard_water run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t slot_shard_water 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t cnt_shard_water 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_shard_water"}}] store result score #t num_shard_water run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t slot_shard_water 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t cnt_shard_water 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_shard_water"}}] store result score #t num_shard_water run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t slot_shard_water 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_shard_water"}}] run scoreboard players set #t cnt_shard_water 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_shard_water"}}] store result score #t num_shard_water run data get block ~ ~ ~ Items[{Slot:8b}].Count
# shard_fire
scoreboard players set #t cnt_shard_fire 0
scoreboard players set #t num_shard_fire 0
scoreboard players set #t slot_shard_fire -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t slot_shard_fire 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t cnt_shard_fire 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_fire"}}] store result score #t num_shard_fire run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t slot_shard_fire 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t cnt_shard_fire 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_shard_fire"}}] store result score #t num_shard_fire run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t slot_shard_fire 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t cnt_shard_fire 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_shard_fire"}}] store result score #t num_shard_fire run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t slot_shard_fire 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t cnt_shard_fire 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_shard_fire"}}] store result score #t num_shard_fire run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t slot_shard_fire 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t cnt_shard_fire 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_shard_fire"}}] store result score #t num_shard_fire run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t slot_shard_fire 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t cnt_shard_fire 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_shard_fire"}}] store result score #t num_shard_fire run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t slot_shard_fire 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t cnt_shard_fire 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_shard_fire"}}] store result score #t num_shard_fire run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t slot_shard_fire 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t cnt_shard_fire 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_shard_fire"}}] store result score #t num_shard_fire run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t slot_shard_fire 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_shard_fire"}}] run scoreboard players set #t cnt_shard_fire 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_shard_fire"}}] store result score #t num_shard_fire run data get block ~ ~ ~ Items[{Slot:8b}].Count
# shard_earth
scoreboard players set #t cnt_shard_earth 0
scoreboard players set #t num_shard_earth 0
scoreboard players set #t slot_shard_earth -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t slot_shard_earth 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t cnt_shard_earth 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_shard_earth"}}] store result score #t num_shard_earth run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t slot_shard_earth 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t cnt_shard_earth 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_shard_earth"}}] store result score #t num_shard_earth run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t slot_shard_earth 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t cnt_shard_earth 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_shard_earth"}}] store result score #t num_shard_earth run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t slot_shard_earth 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t cnt_shard_earth 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_shard_earth"}}] store result score #t num_shard_earth run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t slot_shard_earth 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t cnt_shard_earth 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_shard_earth"}}] store result score #t num_shard_earth run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t slot_shard_earth 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t cnt_shard_earth 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_shard_earth"}}] store result score #t num_shard_earth run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t slot_shard_earth 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t cnt_shard_earth 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_shard_earth"}}] store result score #t num_shard_earth run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t slot_shard_earth 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t cnt_shard_earth 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_shard_earth"}}] store result score #t num_shard_earth run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t slot_shard_earth 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_shard_earth"}}] run scoreboard players set #t cnt_shard_earth 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_shard_earth"}}] store result score #t num_shard_earth run data get block ~ ~ ~ Items[{Slot:8b}].Count
# edge_zhao
scoreboard players set #t cnt_edge_zhao 0
scoreboard players set #t num_edge_zhao 0
scoreboard players set #t slot_edge_zhao -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t slot_edge_zhao 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t cnt_edge_zhao 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_zhao"}}] store result score #t num_edge_zhao run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t slot_edge_zhao 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t cnt_edge_zhao 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_zhao"}}] store result score #t num_edge_zhao run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t slot_edge_zhao 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t cnt_edge_zhao 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_zhao"}}] store result score #t num_edge_zhao run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t slot_edge_zhao 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t cnt_edge_zhao 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_zhao"}}] store result score #t num_edge_zhao run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t slot_edge_zhao 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t cnt_edge_zhao 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_zhao"}}] store result score #t num_edge_zhao run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t slot_edge_zhao 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t cnt_edge_zhao 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_zhao"}}] store result score #t num_edge_zhao run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t slot_edge_zhao 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t cnt_edge_zhao 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_zhao"}}] store result score #t num_edge_zhao run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t slot_edge_zhao 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t cnt_edge_zhao 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_zhao"}}] store result score #t num_edge_zhao run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t slot_edge_zhao 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_zhao"}}] run scoreboard players set #t cnt_edge_zhao 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_zhao"}}] store result score #t num_edge_zhao run data get block ~ ~ ~ Items[{Slot:8b}].Count
# edge_lie
scoreboard players set #t cnt_edge_lie 0
scoreboard players set #t num_edge_lie 0
scoreboard players set #t slot_edge_lie -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t slot_edge_lie 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t cnt_edge_lie 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_lie"}}] store result score #t num_edge_lie run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t slot_edge_lie 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t cnt_edge_lie 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_lie"}}] store result score #t num_edge_lie run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t slot_edge_lie 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t cnt_edge_lie 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_lie"}}] store result score #t num_edge_lie run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t slot_edge_lie 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t cnt_edge_lie 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_lie"}}] store result score #t num_edge_lie run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t slot_edge_lie 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t cnt_edge_lie 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_lie"}}] store result score #t num_edge_lie run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t slot_edge_lie 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t cnt_edge_lie 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_lie"}}] store result score #t num_edge_lie run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t slot_edge_lie 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t cnt_edge_lie 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_lie"}}] store result score #t num_edge_lie run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t slot_edge_lie 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t cnt_edge_lie 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_lie"}}] store result score #t num_edge_lie run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t slot_edge_lie 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_lie"}}] run scoreboard players set #t cnt_edge_lie 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_lie"}}] store result score #t num_edge_lie run data get block ~ ~ ~ Items[{Slot:8b}].Count
# edge_jing
scoreboard players set #t cnt_edge_jing 0
scoreboard players set #t num_edge_jing 0
scoreboard players set #t slot_edge_jing -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t slot_edge_jing 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t cnt_edge_jing 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_jing"}}] store result score #t num_edge_jing run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t slot_edge_jing 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t cnt_edge_jing 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_jing"}}] store result score #t num_edge_jing run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t slot_edge_jing 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t cnt_edge_jing 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_jing"}}] store result score #t num_edge_jing run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t slot_edge_jing 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t cnt_edge_jing 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_jing"}}] store result score #t num_edge_jing run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t slot_edge_jing 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t cnt_edge_jing 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_jing"}}] store result score #t num_edge_jing run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t slot_edge_jing 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t cnt_edge_jing 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_jing"}}] store result score #t num_edge_jing run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t slot_edge_jing 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t cnt_edge_jing 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_jing"}}] store result score #t num_edge_jing run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t slot_edge_jing 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t cnt_edge_jing 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_jing"}}] store result score #t num_edge_jing run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t slot_edge_jing 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_jing"}}] run scoreboard players set #t cnt_edge_jing 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_jing"}}] store result score #t num_edge_jing run data get block ~ ~ ~ Items[{Slot:8b}].Count
# edge_can
scoreboard players set #t cnt_edge_can 0
scoreboard players set #t num_edge_can 0
scoreboard players set #t slot_edge_can -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t slot_edge_can 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t cnt_edge_can 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_can"}}] store result score #t num_edge_can run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t slot_edge_can 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t cnt_edge_can 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_can"}}] store result score #t num_edge_can run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t slot_edge_can 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t cnt_edge_can 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_can"}}] store result score #t num_edge_can run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t slot_edge_can 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t cnt_edge_can 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_can"}}] store result score #t num_edge_can run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t slot_edge_can 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t cnt_edge_can 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_can"}}] store result score #t num_edge_can run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t slot_edge_can 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t cnt_edge_can 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_can"}}] store result score #t num_edge_can run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t slot_edge_can 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t cnt_edge_can 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_can"}}] store result score #t num_edge_can run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t slot_edge_can 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t cnt_edge_can 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_can"}}] store result score #t num_edge_can run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t slot_edge_can 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_can"}}] run scoreboard players set #t cnt_edge_can 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_can"}}] store result score #t num_edge_can run data get block ~ ~ ~ Items[{Slot:8b}].Count
# edge_twin
scoreboard players set #t cnt_edge_twin 0
scoreboard players set #t num_edge_twin 0
scoreboard players set #t slot_edge_twin -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t slot_edge_twin 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t cnt_edge_twin 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_twin"}}] store result score #t num_edge_twin run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t slot_edge_twin 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t cnt_edge_twin 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_twin"}}] store result score #t num_edge_twin run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t slot_edge_twin 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t cnt_edge_twin 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_twin"}}] store result score #t num_edge_twin run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t slot_edge_twin 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t cnt_edge_twin 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_twin"}}] store result score #t num_edge_twin run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t slot_edge_twin 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t cnt_edge_twin 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_twin"}}] store result score #t num_edge_twin run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t slot_edge_twin 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t cnt_edge_twin 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_twin"}}] store result score #t num_edge_twin run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t slot_edge_twin 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t cnt_edge_twin 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_twin"}}] store result score #t num_edge_twin run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t slot_edge_twin 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t cnt_edge_twin 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_twin"}}] store result score #t num_edge_twin run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t slot_edge_twin 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_twin"}}] run scoreboard players set #t cnt_edge_twin 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_twin"}}] store result score #t num_edge_twin run data get block ~ ~ ~ Items[{Slot:8b}].Count
# edge_rub
scoreboard players set #t cnt_edge_rub 0
scoreboard players set #t num_edge_rub 0
scoreboard players set #t slot_edge_rub -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t slot_edge_rub 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t cnt_edge_rub 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_edge_rub"}}] store result score #t num_edge_rub run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t slot_edge_rub 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t cnt_edge_rub 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_edge_rub"}}] store result score #t num_edge_rub run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t slot_edge_rub 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t cnt_edge_rub 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_edge_rub"}}] store result score #t num_edge_rub run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t slot_edge_rub 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t cnt_edge_rub 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_edge_rub"}}] store result score #t num_edge_rub run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t slot_edge_rub 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t cnt_edge_rub 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_edge_rub"}}] store result score #t num_edge_rub run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t slot_edge_rub 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t cnt_edge_rub 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_edge_rub"}}] store result score #t num_edge_rub run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t slot_edge_rub 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t cnt_edge_rub 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_edge_rub"}}] store result score #t num_edge_rub run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t slot_edge_rub 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t cnt_edge_rub 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_edge_rub"}}] store result score #t num_edge_rub run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t slot_edge_rub 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_rub"}}] run scoreboard players set #t cnt_edge_rub 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_edge_rub"}}] store result score #t num_edge_rub run data get block ~ ~ ~ Items[{Slot:8b}].Count
# dust
scoreboard players set #t cnt_dust 0
scoreboard players set #t num_dust 0
scoreboard players set #t slot_dust -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t slot_dust 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t cnt_dust 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_dust"}}] store result score #t num_dust run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t slot_dust 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t cnt_dust 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_dust"}}] store result score #t num_dust run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t slot_dust 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t cnt_dust 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_dust"}}] store result score #t num_dust run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t slot_dust 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t cnt_dust 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_dust"}}] store result score #t num_dust run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t slot_dust 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t cnt_dust 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_dust"}}] store result score #t num_dust run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t slot_dust 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t cnt_dust 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_dust"}}] store result score #t num_dust run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t slot_dust 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t cnt_dust 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_dust"}}] store result score #t num_dust run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t slot_dust 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t cnt_dust 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_dust"}}] store result score #t num_dust run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t slot_dust 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_dust"}}] run scoreboard players set #t cnt_dust 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_dust"}}] store result score #t num_dust run data get block ~ ~ ~ Items[{Slot:8b}].Count
# sand
scoreboard players set #t cnt_sand 0
scoreboard players set #t num_sand 0
scoreboard players set #t slot_sand -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t slot_sand 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t cnt_sand 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_sand"}}] store result score #t num_sand run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t slot_sand 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t cnt_sand 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_sand"}}] store result score #t num_sand run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t slot_sand 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t cnt_sand 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_sand"}}] store result score #t num_sand run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t slot_sand 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t cnt_sand 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_sand"}}] store result score #t num_sand run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t slot_sand 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t cnt_sand 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_sand"}}] store result score #t num_sand run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t slot_sand 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t cnt_sand 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_sand"}}] store result score #t num_sand run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t slot_sand 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t cnt_sand 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_sand"}}] store result score #t num_sand run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t slot_sand 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t cnt_sand 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_sand"}}] store result score #t num_sand run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t slot_sand 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_sand"}}] run scoreboard players set #t cnt_sand 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_sand"}}] store result score #t num_sand run data get block ~ ~ ~ Items[{Slot:8b}].Count
# seal1
scoreboard players set #t cnt_seal1 0
scoreboard players set #t num_seal1 0
scoreboard players set #t slot_seal1 -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t slot_seal1 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t cnt_seal1 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_seal_1"}}] store result score #t num_seal1 run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t slot_seal1 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t cnt_seal1 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_1"}}] store result score #t num_seal1 run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t slot_seal1 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t cnt_seal1 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_seal_1"}}] store result score #t num_seal1 run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t slot_seal1 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t cnt_seal1 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_seal_1"}}] store result score #t num_seal1 run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t slot_seal1 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t cnt_seal1 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_seal_1"}}] store result score #t num_seal1 run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t slot_seal1 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t cnt_seal1 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_seal_1"}}] store result score #t num_seal1 run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t slot_seal1 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t cnt_seal1 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_seal_1"}}] store result score #t num_seal1 run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t slot_seal1 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t cnt_seal1 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_seal_1"}}] store result score #t num_seal1 run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t slot_seal1 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_seal_1"}}] run scoreboard players set #t cnt_seal1 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_seal_1"}}] store result score #t num_seal1 run data get block ~ ~ ~ Items[{Slot:8b}].Count
# seal2
scoreboard players set #t cnt_seal2 0
scoreboard players set #t num_seal2 0
scoreboard players set #t slot_seal2 -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t slot_seal2 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t cnt_seal2 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_seal_2"}}] store result score #t num_seal2 run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t slot_seal2 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t cnt_seal2 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_2"}}] store result score #t num_seal2 run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t slot_seal2 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t cnt_seal2 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_seal_2"}}] store result score #t num_seal2 run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t slot_seal2 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t cnt_seal2 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_seal_2"}}] store result score #t num_seal2 run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t slot_seal2 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t cnt_seal2 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_seal_2"}}] store result score #t num_seal2 run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t slot_seal2 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t cnt_seal2 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_seal_2"}}] store result score #t num_seal2 run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t slot_seal2 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t cnt_seal2 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_seal_2"}}] store result score #t num_seal2 run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t slot_seal2 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t cnt_seal2 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_seal_2"}}] store result score #t num_seal2 run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t slot_seal2 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_seal_2"}}] run scoreboard players set #t cnt_seal2 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_seal_2"}}] store result score #t num_seal2 run data get block ~ ~ ~ Items[{Slot:8b}].Count
# seal3
scoreboard players set #t cnt_seal3 0
scoreboard players set #t num_seal3 0
scoreboard players set #t slot_seal3 -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t slot_seal3 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t cnt_seal3 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_seal_3"}}] store result score #t num_seal3 run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t slot_seal3 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t cnt_seal3 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_seal_3"}}] store result score #t num_seal3 run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t slot_seal3 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t cnt_seal3 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_seal_3"}}] store result score #t num_seal3 run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t slot_seal3 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t cnt_seal3 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_seal_3"}}] store result score #t num_seal3 run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t slot_seal3 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t cnt_seal3 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_seal_3"}}] store result score #t num_seal3 run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t slot_seal3 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t cnt_seal3 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_seal_3"}}] store result score #t num_seal3 run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t slot_seal3 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t cnt_seal3 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_seal_3"}}] store result score #t num_seal3 run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t slot_seal3 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t cnt_seal3 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_seal_3"}}] store result score #t num_seal3 run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t slot_seal3 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_seal_3"}}] run scoreboard players set #t cnt_seal3 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_seal_3"}}] store result score #t num_seal3 run data get block ~ ~ ~ Items[{Slot:8b}].Count
# core
scoreboard players set #t cnt_core 0
scoreboard players set #t num_core 0
scoreboard players set #t slot_core -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t slot_core 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t cnt_core 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{id:"panling:mirror_core"}}] store result score #t num_core run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t slot_core 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t cnt_core 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{id:"panling:mirror_core"}}] store result score #t num_core run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t slot_core 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t cnt_core 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{id:"panling:mirror_core"}}] store result score #t num_core run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t slot_core 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t cnt_core 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_core"}}] store result score #t num_core run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t slot_core 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t cnt_core 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{id:"panling:mirror_core"}}] store result score #t num_core run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t slot_core 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t cnt_core 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{id:"panling:mirror_core"}}] store result score #t num_core run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t slot_core 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t cnt_core 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{id:"panling:mirror_core"}}] store result score #t num_core run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t slot_core 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t cnt_core 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{id:"panling:mirror_core"}}] store result score #t num_core run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t slot_core 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_core"}}] run scoreboard players set #t cnt_core 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{id:"panling:mirror_core"}}] store result score #t num_core run data get block ~ ~ ~ Items[{Slot:8b}].Count
# gear
scoreboard players set #t cnt_gear 0
scoreboard players set #t num_gear 0
scoreboard players set #t slot_gear -1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{mirror:1}}] run scoreboard players set #t slot_gear 0
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{mirror:1}}] run scoreboard players set #t cnt_gear 1
execute if data block ~ ~ ~ Items[{Slot:0b,tag:{mirror:1}}] store result score #t num_gear run data get block ~ ~ ~ Items[{Slot:0b}].Count
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{mirror:1}}] run scoreboard players set #t slot_gear 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{mirror:1}}] run scoreboard players set #t cnt_gear 1
execute if data block ~ ~ ~ Items[{Slot:1b,tag:{mirror:1}}] store result score #t num_gear run data get block ~ ~ ~ Items[{Slot:1b}].Count
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{mirror:1}}] run scoreboard players set #t slot_gear 2
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{mirror:1}}] run scoreboard players set #t cnt_gear 1
execute if data block ~ ~ ~ Items[{Slot:2b,tag:{mirror:1}}] store result score #t num_gear run data get block ~ ~ ~ Items[{Slot:2b}].Count
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] run scoreboard players set #t slot_gear 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] run scoreboard players set #t cnt_gear 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1}}] store result score #t num_gear run data get block ~ ~ ~ Items[{Slot:3b}].Count
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{mirror:1}}] run scoreboard players set #t slot_gear 4
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{mirror:1}}] run scoreboard players set #t cnt_gear 1
execute if data block ~ ~ ~ Items[{Slot:4b,tag:{mirror:1}}] store result score #t num_gear run data get block ~ ~ ~ Items[{Slot:4b}].Count
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{mirror:1}}] run scoreboard players set #t slot_gear 5
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{mirror:1}}] run scoreboard players set #t cnt_gear 1
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{mirror:1}}] store result score #t num_gear run data get block ~ ~ ~ Items[{Slot:5b}].Count
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{mirror:1}}] run scoreboard players set #t slot_gear 6
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{mirror:1}}] run scoreboard players set #t cnt_gear 1
execute if data block ~ ~ ~ Items[{Slot:6b,tag:{mirror:1}}] store result score #t num_gear run data get block ~ ~ ~ Items[{Slot:6b}].Count
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{mirror:1}}] run scoreboard players set #t slot_gear 7
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{mirror:1}}] run scoreboard players set #t cnt_gear 1
execute if data block ~ ~ ~ Items[{Slot:7b,tag:{mirror:1}}] store result score #t num_gear run data get block ~ ~ ~ Items[{Slot:7b}].Count
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{mirror:1}}] run scoreboard players set #t slot_gear 8
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{mirror:1}}] run scoreboard players set #t cnt_gear 1
execute if data block ~ ~ ~ Items[{Slot:8b,tag:{mirror:1}}] store result score #t num_gear run data get block ~ ~ ~ Items[{Slot:8b}].Count
