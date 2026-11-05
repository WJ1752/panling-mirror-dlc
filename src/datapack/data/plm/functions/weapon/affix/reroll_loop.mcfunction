# 洗练补齐：形状填充后若有效纹数 <5，按 45/45/10 继续抽，最多 wp_rr_n 次
# 只补抽、不覆盖已有条目；add_one 在无可抽类别时返回（wp_added=0）并停止。
execute if score #t wp_rr_n matches ..0 run return 0
function plm:weapon/affix/count
execute if score #t wp_count matches 5.. run return 0
scoreboard players remove #t wp_rr_n 1
function plm:weapon/affix/add_one
execute if score #t wp_added matches 1 run function plm:weapon/affix/reroll_loop
