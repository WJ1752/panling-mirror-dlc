# 三类都可：45/45/10（1..45 / 46..90 / 91..100）
execute if score #t wp_cat matches ..45 run function plm:weapon/affix/add/dmg
execute if score #t wp_cat matches 46..90 run function plm:weapon/affix/add/skl
execute if score #t wp_cat matches 91.. run function plm:weapon/affix/add/fx
