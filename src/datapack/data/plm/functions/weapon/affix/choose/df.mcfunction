# 伤害+特效：45/55 归一化 → 1..82 / 83..100
execute if score #t wp_cat matches ..82 run function plm:weapon/affix/add/dmg
execute if score #t wp_cat matches 83.. run function plm:weapon/affix/add/fx
