function plm:domains/valley/cleanup
fill ~0 ~ ~ ~31 ~23 ~31 air
fill ~0 ~ ~ ~31 ~ ~31 prismarine_bricks
fill ~0 ~1 ~0 ~31 ~6 ~0 dark_prismarine
fill ~0 ~1 ~31 ~31 ~6 ~31 dark_prismarine
fill ~4 ~1 ~2 ~4 ~4 ~2 dark_prismarine
setblock ~4 ~5 ~2 lantern
fill ~4 ~1 ~29 ~4 ~4 ~29 dark_prismarine
setblock ~4 ~5 ~29 lantern
fill ~12 ~1 ~2 ~12 ~4 ~2 dark_prismarine
setblock ~12 ~5 ~2 lantern
fill ~12 ~1 ~29 ~12 ~4 ~29 dark_prismarine
setblock ~12 ~5 ~29 lantern
fill ~20 ~1 ~2 ~20 ~4 ~2 dark_prismarine
setblock ~20 ~5 ~2 lantern
fill ~20 ~1 ~29 ~20 ~4 ~29 dark_prismarine
setblock ~20 ~5 ~29 lantern
fill ~28 ~1 ~2 ~28 ~4 ~2 dark_prismarine
setblock ~28 ~5 ~2 lantern
fill ~28 ~1 ~29 ~28 ~4 ~29 dark_prismarine
setblock ~28 ~5 ~29 lantern
fill ~32 ~ ~ ~63 ~23 ~31 air
fill ~32 ~ ~ ~63 ~ ~31 prismarine_bricks
fill ~32 ~1 ~0 ~63 ~6 ~0 dark_prismarine
fill ~32 ~1 ~31 ~63 ~6 ~31 dark_prismarine
fill ~36 ~1 ~2 ~36 ~4 ~2 dark_prismarine
setblock ~36 ~5 ~2 lantern
fill ~36 ~1 ~29 ~36 ~4 ~29 dark_prismarine
setblock ~36 ~5 ~29 lantern
fill ~44 ~1 ~2 ~44 ~4 ~2 dark_prismarine
setblock ~44 ~5 ~2 lantern
fill ~44 ~1 ~29 ~44 ~4 ~29 dark_prismarine
setblock ~44 ~5 ~29 lantern
fill ~52 ~1 ~2 ~52 ~4 ~2 dark_prismarine
setblock ~52 ~5 ~2 lantern
fill ~52 ~1 ~29 ~52 ~4 ~29 dark_prismarine
setblock ~52 ~5 ~29 lantern
fill ~60 ~1 ~2 ~60 ~4 ~2 dark_prismarine
setblock ~60 ~5 ~2 lantern
fill ~60 ~1 ~29 ~60 ~4 ~29 dark_prismarine
setblock ~60 ~5 ~29 lantern
fill ~64 ~ ~ ~95 ~23 ~31 air
fill ~64 ~ ~ ~95 ~ ~31 prismarine_bricks
fill ~64 ~1 ~0 ~95 ~6 ~0 dark_prismarine
fill ~64 ~1 ~31 ~95 ~6 ~31 dark_prismarine
fill ~68 ~1 ~2 ~68 ~4 ~2 dark_prismarine
setblock ~68 ~5 ~2 lantern
fill ~68 ~1 ~29 ~68 ~4 ~29 dark_prismarine
setblock ~68 ~5 ~29 lantern
fill ~76 ~1 ~2 ~76 ~4 ~2 dark_prismarine
setblock ~76 ~5 ~2 lantern
fill ~76 ~1 ~29 ~76 ~4 ~29 dark_prismarine
setblock ~76 ~5 ~29 lantern
fill ~84 ~1 ~2 ~84 ~4 ~2 dark_prismarine
setblock ~84 ~5 ~2 lantern
fill ~84 ~1 ~29 ~84 ~4 ~29 dark_prismarine
setblock ~84 ~5 ~29 lantern
fill ~92 ~1 ~2 ~92 ~4 ~2 dark_prismarine
setblock ~92 ~5 ~2 lantern
fill ~92 ~1 ~29 ~92 ~4 ~29 dark_prismarine
setblock ~92 ~5 ~29 lantern
fill ~0 ~1 ~1 ~0 ~6 ~30 dark_prismarine
fill ~31 ~1 ~1 ~31 ~6 ~30 dark_prismarine
fill ~63 ~1 ~1 ~63 ~6 ~30 dark_prismarine
fill ~95 ~1 ~1 ~95 ~6 ~30 dark_prismarine
scoreboard players set #valley ds_stage 0
scoreboard players set #valley ds_count 0
scoreboard players set #valley ds_lamps 0
scoreboard players set #valley ds_hold 0
scoreboard players set #valley ds_cd 0
scoreboard players set #valley ds_window 0
scoreboard players set #valley ds_clock 0
scoreboard players set #valley ds_seq 0
scoreboard players operation #valley ds_hp = @s dm_party
scoreboard players operation #valley ds_hp *= #base ds_hp
scoreboard players operation #valley ds_hp *= @s dm_depth
scoreboard players operation #valley ds_max = #valley ds_hp
fill ~11 ~-1 ~11 ~18 ~ ~18 dark_prismarine
fill ~12 ~ ~12 ~17 ~ ~17 air
fill ~45 ~-1 ~11 ~52 ~ ~18 dark_prismarine
fill ~46 ~ ~12 ~51 ~ ~17 air
fill ~66 ~-1 ~3 ~73 ~ ~10 dark_prismarine
fill ~67 ~ ~4 ~72 ~ ~9 air
fill ~78 ~-1 ~3 ~85 ~ ~10 dark_prismarine
fill ~79 ~ ~4 ~84 ~ ~9 air
fill ~83 ~-1 ~19 ~90 ~ ~26 dark_prismarine
fill ~84 ~ ~20 ~89 ~ ~25 air
function plm:domains/valley/stage/1
