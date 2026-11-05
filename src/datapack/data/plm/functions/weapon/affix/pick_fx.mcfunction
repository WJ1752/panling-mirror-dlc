# 从 10 条 FX 中不重复抽一条 → #t wp_idx 1..10
scoreboard players set #t wp_attempt 0
function plm:weapon/affix/pick_fx/try
