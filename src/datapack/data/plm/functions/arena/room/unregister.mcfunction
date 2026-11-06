scoreboard players set #arena mirror_arena_active 0
scoreboard players set #arena mirror_boss_phase 0
scoreboard players set #arena mirror_lightning_warn 0
scoreboard players set #arena mirror_arena_outcome 0
bossbar set plm:mirror_boss visible false
bossbar set plm:mirror_boss players
tag @a[tag=mirror_arena_member] remove mirror_arena_member
tag @a[tag=plm_shadow_arena] remove plm_shadow_arena
tag @a[tag=mirror_arena_inside] remove mirror_arena_inside
scoreboard players set #missing mirror_tick 0
