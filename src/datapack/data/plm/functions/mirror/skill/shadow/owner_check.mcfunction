# @s = 倒影；检查 mirror_shadow_owner 对应的玩家是否还在同一维度
# 主人死亡/换维度/重登：倒影直接结束（设计 §2.1.2 第 4 条）。
function plm:mirror/skill/shadow/owner_mark
execute unless entity @a[tag=mirror_shadow_owner_ref,limit=1] run function plm:mirror/skill/shadow/end
tag @a remove mirror_shadow_owner_ref
