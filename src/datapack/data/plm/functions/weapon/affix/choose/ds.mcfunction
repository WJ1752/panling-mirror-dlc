# 伤害+技能：45/45 归一化 → 1..50 / 51..100
execute if score #t wp_cat matches ..50 run function plm:weapon/affix/add/dmg
execute if score #t wp_cat matches 51.. run function plm:weapon/affix/add/skl
