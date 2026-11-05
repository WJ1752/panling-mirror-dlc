# 从本器形 6 条 SKL 中不重复抽一条 → #t wp_idx 1..6
# 说明：Phase 1 不抽取技能纹的限制已解除；旧占位实现不再使用。
# 最多重抽 20 次；仍重复则按 6 条池顺序找第一个未用 id 兜底
scoreboard players set #t wp_attempt 0
function plm:weapon/affix/pick_skl/try
