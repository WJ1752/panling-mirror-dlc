function plm:domains/mountain/cleanup
fill ~0 ~ ~ ~31 ~23 ~31 air
fill ~0 ~ ~ ~31 ~ ~31 stone_bricks
fill ~0 ~1 ~0 ~31 ~6 ~0 mossy_stone_bricks
fill ~0 ~1 ~31 ~31 ~6 ~31 mossy_stone_bricks
fill ~4 ~1 ~2 ~4 ~4 ~2 mossy_stone_bricks
setblock ~4 ~5 ~2 lantern
fill ~4 ~1 ~29 ~4 ~4 ~29 mossy_stone_bricks
setblock ~4 ~5 ~29 lantern
fill ~12 ~1 ~2 ~12 ~4 ~2 mossy_stone_bricks
setblock ~12 ~5 ~2 lantern
fill ~12 ~1 ~29 ~12 ~4 ~29 mossy_stone_bricks
setblock ~12 ~5 ~29 lantern
fill ~20 ~1 ~2 ~20 ~4 ~2 mossy_stone_bricks
setblock ~20 ~5 ~2 lantern
fill ~20 ~1 ~29 ~20 ~4 ~29 mossy_stone_bricks
setblock ~20 ~5 ~29 lantern
fill ~28 ~1 ~2 ~28 ~4 ~2 mossy_stone_bricks
setblock ~28 ~5 ~2 lantern
fill ~28 ~1 ~29 ~28 ~4 ~29 mossy_stone_bricks
setblock ~28 ~5 ~29 lantern
fill ~32 ~ ~ ~63 ~23 ~31 air
fill ~32 ~ ~ ~63 ~ ~31 stone_bricks
fill ~32 ~1 ~0 ~63 ~6 ~0 mossy_stone_bricks
fill ~32 ~1 ~31 ~63 ~6 ~31 mossy_stone_bricks
fill ~36 ~1 ~2 ~36 ~4 ~2 mossy_stone_bricks
setblock ~36 ~5 ~2 lantern
fill ~36 ~1 ~29 ~36 ~4 ~29 mossy_stone_bricks
setblock ~36 ~5 ~29 lantern
fill ~44 ~1 ~2 ~44 ~4 ~2 mossy_stone_bricks
setblock ~44 ~5 ~2 lantern
fill ~44 ~1 ~29 ~44 ~4 ~29 mossy_stone_bricks
setblock ~44 ~5 ~29 lantern
fill ~52 ~1 ~2 ~52 ~4 ~2 mossy_stone_bricks
setblock ~52 ~5 ~2 lantern
fill ~52 ~1 ~29 ~52 ~4 ~29 mossy_stone_bricks
setblock ~52 ~5 ~29 lantern
fill ~60 ~1 ~2 ~60 ~4 ~2 mossy_stone_bricks
setblock ~60 ~5 ~2 lantern
fill ~60 ~1 ~29 ~60 ~4 ~29 mossy_stone_bricks
setblock ~60 ~5 ~29 lantern
fill ~64 ~ ~ ~95 ~23 ~31 air
fill ~64 ~ ~ ~95 ~ ~31 stone_bricks
fill ~64 ~1 ~0 ~95 ~6 ~0 mossy_stone_bricks
fill ~64 ~1 ~31 ~95 ~6 ~31 mossy_stone_bricks
fill ~68 ~1 ~2 ~68 ~4 ~2 mossy_stone_bricks
setblock ~68 ~5 ~2 lantern
fill ~68 ~1 ~29 ~68 ~4 ~29 mossy_stone_bricks
setblock ~68 ~5 ~29 lantern
fill ~76 ~1 ~2 ~76 ~4 ~2 mossy_stone_bricks
setblock ~76 ~5 ~2 lantern
fill ~76 ~1 ~29 ~76 ~4 ~29 mossy_stone_bricks
setblock ~76 ~5 ~29 lantern
fill ~84 ~1 ~2 ~84 ~4 ~2 mossy_stone_bricks
setblock ~84 ~5 ~2 lantern
fill ~84 ~1 ~29 ~84 ~4 ~29 mossy_stone_bricks
setblock ~84 ~5 ~29 lantern
fill ~92 ~1 ~2 ~92 ~4 ~2 mossy_stone_bricks
setblock ~92 ~5 ~2 lantern
fill ~92 ~1 ~29 ~92 ~4 ~29 mossy_stone_bricks
setblock ~92 ~5 ~29 lantern
fill ~0 ~1 ~1 ~0 ~6 ~30 mossy_stone_bricks
fill ~31 ~1 ~1 ~31 ~6 ~30 mossy_stone_bricks
fill ~63 ~1 ~1 ~63 ~6 ~30 mossy_stone_bricks
fill ~95 ~1 ~1 ~95 ~6 ~30 mossy_stone_bricks
scoreboard players set #mountain ds_stage 0
scoreboard players set #mountain ds_count 0
scoreboard players set #mountain ds_lamps 0
scoreboard players set #mountain ds_hold 0
scoreboard players set #mountain ds_cd 0
scoreboard players set #mountain ds_window 0
scoreboard players set #mountain ds_clock 0
scoreboard players set #mountain ds_seq 0
scoreboard players operation #mountain ds_hp = @s dm_party
scoreboard players operation #mountain ds_hp *= #base ds_hp
scoreboard players operation #mountain ds_hp *= @s dm_depth
scoreboard players operation #mountain ds_max = #mountain ds_hp
fill ~24 ~ ~14 ~26 ~ ~16 prismarine_bricks
summon text_display ~25.5 ~2 ~15.5 {Tags:["dm_scene_mountain"],billboard:"center",alignment:"center",text:'{"text": "青龙", "color": "gold"}'}
fill ~6 ~ ~14 ~8 ~ ~16 quartz_pillar
summon text_display ~7.5 ~2 ~15.5 {Tags:["dm_scene_mountain"],billboard:"center",alignment:"center",text:'{"text": "白虎", "color": "gold"}'}
fill ~15 ~ ~23 ~17 ~ ~25 red_nether_bricks
summon text_display ~16.5 ~2 ~24.5 {Tags:["dm_scene_mountain"],billboard:"center",alignment:"center",text:'{"text": "朱雀", "color": "gold"}'}
fill ~15 ~ ~5 ~17 ~ ~7 polished_blackstone
summon text_display ~16.5 ~2 ~6.5 {Tags:["dm_scene_mountain"],billboard:"center",alignment:"center",text:'{"text": "玄武", "color": "gold"}'}
fill ~56 ~ ~14 ~58 ~ ~16 prismarine_bricks
summon text_display ~57.5 ~2 ~15.5 {Tags:["dm_scene_mountain"],billboard:"center",alignment:"center",text:'{"text": "青龙", "color": "gold"}'}
fill ~38 ~ ~14 ~40 ~ ~16 quartz_pillar
summon text_display ~39.5 ~2 ~15.5 {Tags:["dm_scene_mountain"],billboard:"center",alignment:"center",text:'{"text": "白虎", "color": "gold"}'}
fill ~47 ~ ~23 ~49 ~ ~25 red_nether_bricks
summon text_display ~48.5 ~2 ~24.5 {Tags:["dm_scene_mountain"],billboard:"center",alignment:"center",text:'{"text": "朱雀", "color": "gold"}'}
fill ~47 ~ ~5 ~49 ~ ~7 polished_blackstone
summon text_display ~48.5 ~2 ~6.5 {Tags:["dm_scene_mountain"],billboard:"center",alignment:"center",text:'{"text": "玄武", "color": "gold"}'}
fill ~88 ~ ~14 ~90 ~ ~16 prismarine_bricks
summon text_display ~89.5 ~2 ~15.5 {Tags:["dm_scene_mountain"],billboard:"center",alignment:"center",text:'{"text": "青龙", "color": "gold"}'}
fill ~70 ~ ~14 ~72 ~ ~16 quartz_pillar
summon text_display ~71.5 ~2 ~15.5 {Tags:["dm_scene_mountain"],billboard:"center",alignment:"center",text:'{"text": "白虎", "color": "gold"}'}
fill ~79 ~ ~23 ~81 ~ ~25 red_nether_bricks
summon text_display ~80.5 ~2 ~24.5 {Tags:["dm_scene_mountain"],billboard:"center",alignment:"center",text:'{"text": "朱雀", "color": "gold"}'}
fill ~79 ~ ~5 ~81 ~ ~7 polished_blackstone
summon text_display ~80.5 ~2 ~6.5 {Tags:["dm_scene_mountain"],billboard:"center",alignment:"center",text:'{"text": "玄武", "color": "gold"}'}
function plm:domains/mountain/stage/1
