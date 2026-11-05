# 开纹 +1 条：只在未满上限的类别中按 45/45/10 归一化抽类别
function plm:weapon/affix/count
scoreboard players set #t wp_added 0

# DMG 上限 3。镜隙(4) 设计停用；近战/弓弩有 11 条 active。
# 炉形只有 ying_ren(9) 有消费点（skill_hit），因此炉形最多 1 条 DMG。
scoreboard players set #t wp_can_dmg 0
execute if score #t wp_n_dmg matches ..2 run scoreboard players set #t wp_can_dmg 1
execute if score #t wp_form matches 5..6 if score #t wp_n_dmg matches 1.. run scoreboard players set #t wp_can_dmg 0

# SKL 上限 3；每器形 6 条池，已有 2 条时仍有 4 条可选。
scoreboard players set #t wp_can_skl 0
execute if score #t wp_n_skl matches ..2 run scoreboard players add #t wp_can_skl 1
# 器形不在 1..6 时 append/skl 没有对应分支，不抽 SKL。
execute unless score #t wp_form matches 1..6 run scoreboard players set #t wp_can_skl 0

# FX 上限 1
scoreboard players set #t wp_can_fx 0
execute if score #t wp_n_fx matches 0 run scoreboard players set #t wp_can_fx 1

function plm:weapon/util/rand100
# 快照类别骰：add/* 内部的 roll_val 会覆盖 #t wp_rand，后续条件必须读快照
scoreboard players operation #t wp_cat = #t wp_rand
execute if score #t wp_can_dmg matches 1 if score #t wp_can_skl matches 1 if score #t wp_can_fx matches 1 run function plm:weapon/affix/choose/all
execute if score #t wp_can_dmg matches 1 if score #t wp_can_skl matches 1 if score #t wp_can_fx matches 0 run function plm:weapon/affix/choose/ds
execute if score #t wp_can_dmg matches 1 if score #t wp_can_skl matches 0 if score #t wp_can_fx matches 1 run function plm:weapon/affix/choose/df
execute if score #t wp_can_dmg matches 0 if score #t wp_can_skl matches 1 if score #t wp_can_fx matches 1 run function plm:weapon/affix/choose/sf
execute if score #t wp_can_dmg matches 1 if score #t wp_can_skl matches 0 if score #t wp_can_fx matches 0 run function plm:weapon/affix/choose/d
execute if score #t wp_can_dmg matches 0 if score #t wp_can_skl matches 1 if score #t wp_can_fx matches 0 run function plm:weapon/affix/choose/s
execute if score #t wp_can_dmg matches 0 if score #t wp_can_skl matches 0 if score #t wp_can_fx matches 1 run function plm:weapon/affix/choose/f
