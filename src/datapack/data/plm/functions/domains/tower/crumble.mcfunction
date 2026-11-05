execute if score #tower ds_seq matches 0 run fill ~64 ~12 ~0 ~67 ~12 ~30 air
execute if score #tower ds_seq matches 1 run fill ~68 ~12 ~0 ~90 ~12 ~3 air
execute if score #tower ds_seq matches 2 run fill ~91 ~12 ~0 ~94 ~12 ~30 air
execute if score #tower ds_seq matches 3 run fill ~68 ~12 ~27 ~90 ~12 ~30 air
execute if score #tower ds_seq matches 4 run fill ~68 ~12 ~4 ~72 ~12 ~26 air
execute if score #tower ds_seq matches 5 run fill ~73 ~12 ~4 ~85 ~12 ~8 air
execute if score #tower ds_seq matches 6 run fill ~86 ~12 ~4 ~90 ~12 ~26 air
execute if score #tower ds_seq matches 7 run fill ~73 ~12 ~22 ~85 ~12 ~26 air
execute if score #tower ds_seq matches 8 run fill ~73 ~12 ~9 ~85 ~12 ~21 air outline
execute if score #tower ds_seq matches 9 run fill ~74 ~12 ~10 ~84 ~12 ~20 air outline
execute if score #tower ds_seq matches 10 run fill ~75 ~12 ~11 ~83 ~12 ~19 air outline
execute if score #tower ds_seq matches 11 run fill ~76 ~12 ~12 ~82 ~12 ~18 air outline
execute if score #tower ds_seq matches 12 run fill ~77 ~12 ~13 ~81 ~12 ~17 air outline
scoreboard players add #tower ds_seq 1
scoreboard players set #tower ds_hold 0
