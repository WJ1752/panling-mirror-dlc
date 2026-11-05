# 照心剑 · 踏影单维度 5t
# 倒影是 armor_stand，不在 @a 里，天然不吃踏影。

# 计时：buff/cd 都是 tick 单位（buff=60 → 3s；cd=160 → 8s）。
# 本函数 5t 跑一次，因此每次减 5，和 mirror_cast_lock 同口径（设计 §2.1.3「每 5 tick 更新」）。
execute as @a[scores={mirror_taying_buff=1..}] run scoreboard players remove @s mirror_taying_buff 5
execute as @a[scores={mirror_taying_buff=..-1}] run scoreboard players set @s mirror_taying_buff 0
execute as @a[scores={mirror_taying_cd=1..}] run scoreboard players remove @s mirror_taying_cd 5
execute as @a[scores={mirror_taying_cd=..-1}] run scoreboard players set @s mirror_taying_cd 0

# 只对当前主手持照心剑（mirror_form=0 且 SelectedItem 为激活镜武）的玩家采样水平位移。
# 与 weapon/on_hit 的 SelectedItem 守卫一致：副手/切到别的物品时不累计。
execute as @a[tag=mirror_weapon_active,scores={mirror_form=0}] at @s if data entity @s SelectedItem.tag{mirror:1,act:1} run function plm:mirror/skill/sword/tick_player
