# 洗练：按 §5.1 抽 A35/B35/C12/D12/E6 形状，再按形状的类别配额填满 5 条
# 类别上限 3/3/1；同 id 不重复；镜统/锻位不动。
data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg set value []
data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl set value []
data modify block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx set value []
function plm:weapon/affix/roll_shape
execute if score #t wp_shape matches 1 run function plm:weapon/affix/shapefill/1
execute if score #t wp_shape matches 2 run function plm:weapon/affix/shapefill/2
execute if score #t wp_shape matches 3 run function plm:weapon/affix/shapefill/3
execute if score #t wp_shape matches 4 run function plm:weapon/affix/shapefill/4
execute if score #t wp_shape matches 5 run function plm:weapon/affix/shapefill/5
# 形状槽位若因池不足没填满（例如弓/弩只有 2 条可实装 DMG），按 45/45/10 补齐到 5 条。
# wp_rr_n = 最多补抽次数；reroll_loop 在有效纹数达到 5 时立即停止。
scoreboard players set #t wp_rr_n 5
function plm:weapon/affix/reroll_loop
