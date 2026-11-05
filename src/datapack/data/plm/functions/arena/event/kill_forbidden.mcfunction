# player_killed_entity + mirror_forbidden -> Boss 瞬间治疗 12（2% × 600）
advancement revoke @s only plm:arena/kill_forbidden
execute if score #arena mirror_arena_active matches 1 if score #arena mirror_boss_phase matches 1..2 if score #boss mirror_boss_hp matches 1.. run function plm:arena/event/heal_forbidden
