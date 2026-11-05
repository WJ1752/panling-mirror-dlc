# 镜花 4 件套：绽放后 5s 内下一支箭 +20%。@s=射手。
# 由 bow/resolve 在绽放结算后调用；由 bow/tag_arrow 消费并清零。
# 4 件套映度门槛：四件镜花防具 ≥3；3 防具 + 同套满锻武器时武器视为满足（主文档 §1）
scoreboard players set #t mirror_set_tmp 2
function plm:mirror/set/tier_gate
execute unless score #t ok matches 1 run return 0
scoreboard players operation @s mirror_bow_4_until = #sys mirror_game_time
scoreboard players add @s mirror_bow_4_until 100
scoreboard players set @s mirror_bow_4_bonus 20
