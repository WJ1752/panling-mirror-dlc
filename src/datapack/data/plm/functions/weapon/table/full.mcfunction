# 五纹上限：所有器形 5 条（DMG 3 / SKL 3 / FX 1 的类别上限仍由 add_one 保证）。
# 输入 #t wp_form / #t wp_temper；输出 #t wp_cap / #t wp_full。
scoreboard players set #t wp_cap 5
scoreboard players set #t wp_full 0
execute if score #t wp_temper >= #t wp_cap run scoreboard players set #t wp_full 1
