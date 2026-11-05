# 双生（镜统 4）：释放阵法时 5% 概率在同点 0.5s 后释放一个 20% 强度的相克倒影阵。只给双生炉（form 4）。
# 触发：plm:weapon/tick/5t 轮询 mirror_furnace_cast（mirror/furnace/after_main|off 每次成功主阵 +1）；
#       mirror_base_shuang_seen 去重，避免同一发主阵被 5t 轮询重复判定。
# 由于是 5t 轮询，实际延迟 = 0.5s + 0~5t；仍走 echo 队列（storage plm:mirror echo），不新增实体。
execute unless score @s wp_set matches 4 run return 0
execute unless score @s mirror_form matches 4 run return 0
execute unless entity @s[tag=mirror_weapon_active] run return 0
execute unless score @s mirror_furnace_cast matches 1.. run return 0
execute unless score @s mirror_base_shuang_seen matches -2147483648.. run scoreboard players set @s mirror_base_shuang_seen 0
execute if score @s mirror_furnace_cast <= @s mirror_base_shuang_seen run return 0
scoreboard players operation @s mirror_base_shuang_seen = @s mirror_furnace_cast
# 只有造成伤害的主阵（金属，element=1）才有 mirror_zf_raw_dmg 快照
execute unless score @s mirror_zf_snap matches 1.. run return 0
execute unless score @s mirror_zf_raw_dmg matches 1.. run return 0
execute if predicate plm:chance/5 run function plm:weapon/base/base_shuang_sheng/cast
