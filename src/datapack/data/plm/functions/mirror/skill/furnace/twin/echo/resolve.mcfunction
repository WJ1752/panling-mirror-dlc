# 结算 storage 队列第 0 条：tick 源，无 @s / 位置。
# 把 dmg/el/owner 抄到全局 temp，再在 owner 当前所在维度用临时 anchor 定位到 pos 结算。
# dmg 已在 spawn 预乘 base×ratio/100（0.01 HP），所以 #tw_ratio 固定 100，echo/hit 原公式不变。
execute store result score #tw_base mirror_skill_tmp run data get storage plm:mirror echo[0].dmg
scoreboard players set #tw_ratio mirror_skill_ratio 100
execute store result score #tw_el mirror_skill_tmp3 run data get storage plm:mirror echo[0].el
execute store result score #tw_owner mirror_zf_tmp run data get storage plm:mirror echo[0].owner
execute store result score #tw_dim mirror_zf_tmp3 run data get storage plm:mirror echo[0].dim

# 只在实际入队维度结算。console/schedule 源下裸 @a 可能跨维度可见，所以不能三个维度都跑；
# 用入队时记录的 dim 门控，dim 不正确或 owner 离线就丢弃本条（与旧 clear 语义一致：不残留）。
execute in minecraft:overworld if score #tw_dim mirror_zf_tmp3 matches 0 as @a if score @s player_uid = #tw_owner mirror_zf_tmp run function plm:mirror/skill/furnace/twin/echo/resolve_anchor
execute in minecraft:the_nether if score #tw_dim mirror_zf_tmp3 matches 1 as @a if score @s player_uid = #tw_owner mirror_zf_tmp run function plm:mirror/skill/furnace/twin/echo/resolve_anchor
execute in minecraft:the_end if score #tw_dim mirror_zf_tmp3 matches 2 as @a if score @s player_uid = #tw_owner mirror_zf_tmp run function plm:mirror/skill/furnace/twin/echo/resolve_anchor

data remove storage plm:mirror echo[0]
