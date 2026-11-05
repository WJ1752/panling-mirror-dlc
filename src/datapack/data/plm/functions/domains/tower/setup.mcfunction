function plm:domains/tower/cleanup
fill ~0 ~ ~ ~31 ~23 ~31 air
fill ~0 ~ ~ ~31 ~ ~31 deepslate_bricks
fill ~0 ~1 ~0 ~31 ~6 ~0 cracked_deepslate_bricks
fill ~0 ~1 ~31 ~31 ~6 ~31 cracked_deepslate_bricks
fill ~4 ~1 ~2 ~4 ~4 ~2 cracked_deepslate_bricks
setblock ~4 ~5 ~2 lantern
fill ~4 ~1 ~29 ~4 ~4 ~29 cracked_deepslate_bricks
setblock ~4 ~5 ~29 lantern
fill ~12 ~1 ~2 ~12 ~4 ~2 cracked_deepslate_bricks
setblock ~12 ~5 ~2 lantern
fill ~12 ~1 ~29 ~12 ~4 ~29 cracked_deepslate_bricks
setblock ~12 ~5 ~29 lantern
fill ~20 ~1 ~2 ~20 ~4 ~2 cracked_deepslate_bricks
setblock ~20 ~5 ~2 lantern
fill ~20 ~1 ~29 ~20 ~4 ~29 cracked_deepslate_bricks
setblock ~20 ~5 ~29 lantern
fill ~28 ~1 ~2 ~28 ~4 ~2 cracked_deepslate_bricks
setblock ~28 ~5 ~2 lantern
fill ~28 ~1 ~29 ~28 ~4 ~29 cracked_deepslate_bricks
setblock ~28 ~5 ~29 lantern
fill ~32 ~ ~ ~63 ~23 ~31 air
fill ~32 ~ ~ ~63 ~ ~31 deepslate_bricks
fill ~32 ~1 ~0 ~63 ~6 ~0 cracked_deepslate_bricks
fill ~32 ~1 ~31 ~63 ~6 ~31 cracked_deepslate_bricks
fill ~36 ~1 ~2 ~36 ~4 ~2 cracked_deepslate_bricks
setblock ~36 ~5 ~2 lantern
fill ~36 ~1 ~29 ~36 ~4 ~29 cracked_deepslate_bricks
setblock ~36 ~5 ~29 lantern
fill ~44 ~1 ~2 ~44 ~4 ~2 cracked_deepslate_bricks
setblock ~44 ~5 ~2 lantern
fill ~44 ~1 ~29 ~44 ~4 ~29 cracked_deepslate_bricks
setblock ~44 ~5 ~29 lantern
fill ~52 ~1 ~2 ~52 ~4 ~2 cracked_deepslate_bricks
setblock ~52 ~5 ~2 lantern
fill ~52 ~1 ~29 ~52 ~4 ~29 cracked_deepslate_bricks
setblock ~52 ~5 ~29 lantern
fill ~60 ~1 ~2 ~60 ~4 ~2 cracked_deepslate_bricks
setblock ~60 ~5 ~2 lantern
fill ~60 ~1 ~29 ~60 ~4 ~29 cracked_deepslate_bricks
setblock ~60 ~5 ~29 lantern
fill ~64 ~ ~ ~95 ~23 ~31 air
fill ~64 ~ ~ ~95 ~ ~31 deepslate_bricks
fill ~64 ~1 ~0 ~95 ~6 ~0 cracked_deepslate_bricks
fill ~64 ~1 ~31 ~95 ~6 ~31 cracked_deepslate_bricks
fill ~68 ~1 ~2 ~68 ~4 ~2 cracked_deepslate_bricks
setblock ~68 ~5 ~2 lantern
fill ~68 ~1 ~29 ~68 ~4 ~29 cracked_deepslate_bricks
setblock ~68 ~5 ~29 lantern
fill ~76 ~1 ~2 ~76 ~4 ~2 cracked_deepslate_bricks
setblock ~76 ~5 ~2 lantern
fill ~76 ~1 ~29 ~76 ~4 ~29 cracked_deepslate_bricks
setblock ~76 ~5 ~29 lantern
fill ~84 ~1 ~2 ~84 ~4 ~2 cracked_deepslate_bricks
setblock ~84 ~5 ~2 lantern
fill ~84 ~1 ~29 ~84 ~4 ~29 cracked_deepslate_bricks
setblock ~84 ~5 ~29 lantern
fill ~92 ~1 ~2 ~92 ~4 ~2 cracked_deepslate_bricks
setblock ~92 ~5 ~2 lantern
fill ~92 ~1 ~29 ~92 ~4 ~29 cracked_deepslate_bricks
setblock ~92 ~5 ~29 lantern
fill ~0 ~1 ~1 ~0 ~6 ~30 cracked_deepslate_bricks
fill ~31 ~1 ~1 ~31 ~6 ~30 cracked_deepslate_bricks
fill ~63 ~1 ~1 ~63 ~6 ~30 cracked_deepslate_bricks
fill ~95 ~1 ~1 ~95 ~6 ~30 cracked_deepslate_bricks
scoreboard players set #tower ds_stage 0
scoreboard players set #tower ds_count 0
scoreboard players set #tower ds_lamps 0
scoreboard players set #tower ds_hold 0
scoreboard players set #tower ds_cd 0
scoreboard players set #tower ds_window 0
scoreboard players set #tower ds_clock 0
scoreboard players set #tower ds_seq 0
scoreboard players operation #tower ds_hp = @s dm_party
scoreboard players operation #tower ds_hp *= #base ds_hp
scoreboard players operation #tower ds_hp *= @s dm_depth
scoreboard players operation #tower ds_max = #tower ds_hp
fill ~1 ~ ~1 ~94 ~ ~30 air
fill ~1 ~0 ~10 ~1 ~0 ~20 deepslate_tiles
fill ~2 ~0 ~10 ~2 ~0 ~20 deepslate_tiles
fill ~3 ~0 ~10 ~3 ~0 ~20 deepslate_tiles
fill ~4 ~0 ~10 ~4 ~0 ~20 deepslate_tiles
fill ~5 ~1 ~10 ~5 ~1 ~20 deepslate_tiles
fill ~4 ~1 ~10 ~4 ~1 ~20 polished_deepslate_stairs[facing=east]
fill ~6 ~1 ~10 ~6 ~1 ~20 deepslate_tiles
fill ~7 ~1 ~10 ~7 ~1 ~20 deepslate_tiles
fill ~8 ~1 ~10 ~8 ~1 ~20 deepslate_tiles
fill ~9 ~1 ~10 ~9 ~1 ~20 deepslate_tiles
fill ~10 ~2 ~10 ~10 ~2 ~20 deepslate_tiles
fill ~9 ~2 ~10 ~9 ~2 ~20 polished_deepslate_stairs[facing=east]
fill ~11 ~2 ~10 ~11 ~2 ~20 deepslate_tiles
fill ~12 ~2 ~10 ~12 ~2 ~20 deepslate_tiles
fill ~13 ~2 ~10 ~13 ~2 ~20 deepslate_tiles
fill ~14 ~2 ~10 ~14 ~2 ~20 deepslate_tiles
fill ~15 ~3 ~10 ~15 ~3 ~20 deepslate_tiles
fill ~14 ~3 ~10 ~14 ~3 ~20 polished_deepslate_stairs[facing=east]
fill ~16 ~3 ~10 ~16 ~3 ~20 deepslate_tiles
fill ~17 ~3 ~10 ~17 ~3 ~20 deepslate_tiles
fill ~18 ~3 ~10 ~18 ~3 ~20 deepslate_tiles
fill ~19 ~3 ~10 ~19 ~3 ~20 deepslate_tiles
fill ~20 ~4 ~10 ~20 ~4 ~20 deepslate_tiles
fill ~19 ~4 ~10 ~19 ~4 ~20 polished_deepslate_stairs[facing=east]
fill ~21 ~4 ~10 ~21 ~4 ~20 deepslate_tiles
fill ~22 ~4 ~10 ~22 ~4 ~20 deepslate_tiles
fill ~23 ~4 ~10 ~23 ~4 ~20 deepslate_tiles
fill ~24 ~4 ~10 ~24 ~4 ~20 deepslate_tiles
fill ~25 ~5 ~10 ~25 ~5 ~20 deepslate_tiles
fill ~24 ~5 ~10 ~24 ~5 ~20 polished_deepslate_stairs[facing=east]
fill ~26 ~5 ~10 ~26 ~5 ~20 deepslate_tiles
fill ~27 ~5 ~10 ~27 ~5 ~20 deepslate_tiles
fill ~28 ~5 ~10 ~28 ~5 ~20 deepslate_tiles
fill ~29 ~5 ~10 ~29 ~5 ~20 deepslate_tiles
fill ~30 ~6 ~10 ~30 ~6 ~20 deepslate_tiles
fill ~29 ~6 ~10 ~29 ~6 ~20 polished_deepslate_stairs[facing=east]
fill ~31 ~6 ~10 ~31 ~6 ~20 deepslate_tiles
fill ~32 ~6 ~10 ~32 ~6 ~20 deepslate_tiles
fill ~33 ~6 ~10 ~33 ~6 ~20 deepslate_tiles
fill ~34 ~6 ~10 ~34 ~6 ~20 deepslate_tiles
fill ~35 ~7 ~10 ~35 ~7 ~20 deepslate_tiles
fill ~34 ~7 ~10 ~34 ~7 ~20 polished_deepslate_stairs[facing=east]
fill ~36 ~7 ~10 ~36 ~7 ~20 deepslate_tiles
fill ~37 ~7 ~10 ~37 ~7 ~20 deepslate_tiles
fill ~38 ~7 ~10 ~38 ~7 ~20 deepslate_tiles
fill ~39 ~7 ~10 ~39 ~7 ~20 deepslate_tiles
fill ~40 ~8 ~10 ~40 ~8 ~20 deepslate_tiles
fill ~39 ~8 ~10 ~39 ~8 ~20 polished_deepslate_stairs[facing=east]
fill ~41 ~8 ~10 ~41 ~8 ~20 deepslate_tiles
fill ~42 ~8 ~10 ~42 ~8 ~20 deepslate_tiles
fill ~43 ~8 ~10 ~43 ~8 ~20 deepslate_tiles
fill ~44 ~8 ~10 ~44 ~8 ~20 deepslate_tiles
fill ~45 ~9 ~10 ~45 ~9 ~20 deepslate_tiles
fill ~44 ~9 ~10 ~44 ~9 ~20 polished_deepslate_stairs[facing=east]
fill ~46 ~9 ~10 ~46 ~9 ~20 deepslate_tiles
fill ~47 ~9 ~10 ~47 ~9 ~20 deepslate_tiles
fill ~48 ~9 ~10 ~48 ~9 ~20 deepslate_tiles
fill ~49 ~9 ~10 ~49 ~9 ~20 deepslate_tiles
fill ~50 ~10 ~10 ~50 ~10 ~20 deepslate_tiles
fill ~49 ~10 ~10 ~49 ~10 ~20 polished_deepslate_stairs[facing=east]
fill ~51 ~10 ~10 ~51 ~10 ~20 deepslate_tiles
fill ~52 ~10 ~10 ~52 ~10 ~20 deepslate_tiles
fill ~53 ~10 ~10 ~53 ~10 ~20 deepslate_tiles
fill ~54 ~10 ~10 ~54 ~10 ~20 deepslate_tiles
fill ~55 ~11 ~10 ~55 ~11 ~20 deepslate_tiles
fill ~54 ~11 ~10 ~54 ~11 ~20 polished_deepslate_stairs[facing=east]
fill ~56 ~11 ~10 ~56 ~11 ~20 deepslate_tiles
fill ~57 ~11 ~10 ~57 ~11 ~20 deepslate_tiles
fill ~58 ~11 ~10 ~58 ~11 ~20 deepslate_tiles
fill ~59 ~11 ~10 ~59 ~11 ~20 deepslate_tiles
fill ~60 ~12 ~10 ~60 ~12 ~20 deepslate_tiles
fill ~59 ~12 ~10 ~59 ~12 ~20 polished_deepslate_stairs[facing=east]
fill ~61 ~12 ~10 ~61 ~12 ~20 deepslate_tiles
fill ~62 ~12 ~10 ~62 ~12 ~20 deepslate_tiles
fill ~63 ~12 ~10 ~63 ~12 ~20 deepslate_tiles
fill ~31 ~1 ~10 ~31 ~9 ~20 air
fill ~63 ~7 ~10 ~63 ~18 ~20 air
fill ~31 ~6 ~10 ~31 ~6 ~20 deepslate_tiles
fill ~63 ~12 ~10 ~63 ~12 ~20 deepslate_tiles
fill ~64 ~12 ~0 ~94 ~12 ~30 deepslate_tiles
fill ~68 ~12 ~4 ~90 ~12 ~26 polished_deepslate
fill ~73 ~12 ~9 ~85 ~12 ~21 quartz_bricks
function plm:domains/tower/stage/1
