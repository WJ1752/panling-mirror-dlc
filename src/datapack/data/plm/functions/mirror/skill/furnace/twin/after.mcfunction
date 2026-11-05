# 双生炉·倒映公共段（after_main = 炉副手/元素主手；after_off = 炉主手/元素副手）
# 上下文：@s = 玩家；位置 = 主阵位置（父 after 已 at @s）。
# 设计 §2.5.1：主阵成功后 0.5s，同点生成相克元素倒影阵；强度 20%（dao_ying_qiang +15pp）；
# 内部冷却 10s（dao_ying_kuai → 7s）；不消耗元素、不再触发倒映。

# 1) 主阵元素快照（先不要 counter，后面要用主阵元素判断金属阵/共鸣）
scoreboard players set @s mirror_zf_el 0
function plm:mirror/skill/furnace/twin/element/snapshot
# 保存主阵元素（counter 之后 mirror_zf_el 会变成倒影元素）
scoreboard players operation @s mirror_zf_main_el = @s mirror_zf_el
execute if score @s mirror_zf_el matches 1.. run scoreboard players set @s mirror_zf_snap 1

# 2) 主阵实际伤害快照
#    zf_str 在本体 attribute/zf_str 末尾已 /10 成整数 HP；
#    mirror_zf_raw 是共鸣前的 zf_str（×10，来自 zf_base）。
#    - mirror_zf_raw_dmg：实际主阵伤害 ×10（0.1 HP 定点），不含共鸣 → 倒影/镜匣快照
#    - mirror_zf_base：   实际主阵伤害 ×10，含共鸣 → 拓印放印快照
#    只有金属主阵造成伤害（本体 zf_mp_metal=250%）；木/火/水/土主阵是治疗/增益，快照为 0。
scoreboard players set @s mirror_zf_base 0
scoreboard players set @s mirror_zf_raw_dmg 0
execute unless score @s mirror_zf_mult matches 1.. run scoreboard players set @s mirror_zf_mult 1000
execute if score @s mirror_zf_el matches 1 if score @s mirror_zf_raw matches 1.. run scoreboard players operation @s mirror_zf_raw_dmg = @s mirror_zf_raw
execute if score @s mirror_zf_el matches 1 if score @s mirror_zf_raw matches 1.. run scoreboard players operation @s mirror_zf_raw_dmg *= #const25 mirror_calc
execute if score @s mirror_zf_el matches 1 if score @s mirror_zf_raw matches 1.. run scoreboard players operation @s mirror_zf_raw_dmg /= #const10 mirror_calc
# 没有 raw 时退回整数 HP 的 zf_str ×25（zf_str 已含共鸣，只作为降级路径）
execute if score @s mirror_zf_el matches 1 unless score @s mirror_zf_raw matches 1.. run scoreboard players operation @s mirror_zf_raw_dmg = @s zf_str
execute if score @s mirror_zf_el matches 1 unless score @s mirror_zf_raw matches 1.. run scoreboard players operation @s mirror_zf_raw_dmg *= #const25 mirror_calc
# 这条降级路径的 zf_str 已含共鸣；先除回去，避免下面再乘一次
execute if score @s mirror_zf_el matches 1 unless score @s mirror_zf_raw matches 1.. run scoreboard players operation @s mirror_zf_raw_dmg *= #const1000 mirror_calc
execute if score @s mirror_zf_el matches 1 unless score @s mirror_zf_raw matches 1.. run scoreboard players operation @s mirror_zf_raw_dmg /= @s mirror_zf_mult
# 含共鸣的实际伤害 = 不含共鸣 × zf_mult /1000
execute if score @s mirror_zf_el matches 1 run scoreboard players operation @s mirror_zf_base = @s mirror_zf_raw_dmg
execute if score @s mirror_zf_el matches 1 run scoreboard players operation @s mirror_zf_base *= @s mirror_zf_mult
execute if score @s mirror_zf_el matches 1 run scoreboard players operation @s mirror_zf_base /= #const1000 mirror_calc
execute if score @s mirror_zf_base matches ..0 run function plm:mirror/skill/furnace/twin/base/fallback

# 3) 被动「双生」：只有金属主阵真的命中目标时才打 1s 窗口标记。
#    本体金属阵 limit=1 选最近目标；这里也只标最近一个，并写 owner，避免 B 玩家消费 A 的标记。
execute if score @s mirror_zf_el matches 1 at @s run function plm:mirror/skill/furnace/twin/resonance/mark

# 4) 主阵元素 → 相克元素（1 金 / 2 木 / 3 水 / 4 火 / 5 土）
function plm:mirror/skill/furnace/twin/element/counter

# 5) 倒映：内部冷却不为 1.. 才生成；位置 = 主阵位置；marker 带 due=2（0.5s，5t 单位）
execute unless score @s mirror_cd_int matches 1.. at @s run function plm:mirror/skill/furnace/twin/echo/main_cast
