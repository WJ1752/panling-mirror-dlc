# 影随 · 2 格取样（@s=玩家）
# 与上一个被取点的水平距离平方 >= 4 格²（单位 0.01 格，40000 = 2 格²）才取。
scoreboard players operation #dx mirror_wtmp8 = #cbpx mirror_wtmp
scoreboard players operation #dx mirror_wtmp8 -= #lx mirror_yingsui_x
scoreboard players operation #dz mirror_wtmp9 = #cbpz mirror_wtmp3
scoreboard players operation #dz mirror_wtmp9 -= #lz mirror_yingsui_z
scoreboard players operation #s1 mirror_wtmp10 = #dx mirror_wtmp8
scoreboard players operation #s1 mirror_wtmp10 *= #dx mirror_wtmp8
scoreboard players operation #s2 mirror_wtmp11 = #dz mirror_wtmp9
scoreboard players operation #s2 mirror_wtmp11 *= #dz mirror_wtmp9
scoreboard players operation #s1 mirror_wtmp10 += #s2 mirror_wtmp11
execute if score #s1 mirror_wtmp10 matches 40000.. run scoreboard players set #take mirror_wtmp5 1
