# 换维度清理：advancement plm:mirror/event/changed_dimension 的 reward（@s=玩家）
# clear 内部按三个维度扫描实体，旧维度的倒影/弩机/待结算 marker 也会被清掉。
advancement revoke @s only plm:mirror/event/changed_dimension
function plm:mirror/skill/clear
