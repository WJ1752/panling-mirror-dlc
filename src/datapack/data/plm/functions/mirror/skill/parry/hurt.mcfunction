# 镜映受击：只处理近战（advancement 已过滤弹射/爆炸/穿甲），且必须在架势中
advancement revoke @s only plm:mirror/parry/hurt
execute unless score @s mirror_parry matches 1.. run return 0
# PvP 战役队伍不误触；DLC 只反射 PvE 白名单目标，普通 PvP 由服务端 pvp 配置决定。
execute if entity @s[team=attack] run return 0
execute if entity @s[team=defence] run return 0

# 完美窗口：起手 0.5s 内（2 个 5t 单位）
scoreboard players set #skill mirror_skill_perfect 0
execute if score @s mirror_parry_perfect matches 1.. run scoreboard players set #skill mirror_skill_perfect 1

# 伤害 = 上一快照 - 当前 Health（单位 1/100 HP）；快照由 2t schedule 更新
execute store result score #skill mirror_skill_tmp run data get entity @s Health 100
scoreboard players operation #skill mirror_skill_tmp2 = @s mirror_parry_hp
scoreboard players operation #skill mirror_skill_tmp2 -= #skill mirror_skill_tmp
execute if score #skill mirror_skill_tmp2 matches ..0 run return 0

# 回补 50% 与反射比例都移到“确认白名单目标之后”执行（见下方目标选择段）。
# 这样玩家打玩家时不会回血、不会反射、不会结束架势。

# 正面 120°、3.5 格内最近目标。1.20.1 选择器没有角度，用「距离环 + 前向球」近似：
# 按到玩家脚下的距离把候选分到 0.25 宽的环 (R-0.25, R]；每环只在正前方 R 格、
# 半径 R+0.02 的球内判定。球过玩家原点，故在距离 R 处边界正好 ±60°；
# 环内侧角度会略宽：1 格以上 ≤66°，0.25~0.5 格最多约 77°（贴脸目标）。
# 80°/0.5 格距 0.5 环球心 0.643 > 0.52，不会被近球误收；60°/3 格距 3 环球心 3.0 < 3.02，必中。
# 白名单与 fallback 不变：monster → mirror_boss → mirror_summon（CONTRACT §4），同类取最近。
tag @e[tag=mirror_parry_cand] remove mirror_parry_cand
tag @e[tag=mirror_parry_hit] remove mirror_parry_hit
tag @e[tag=mirror_parry_band] remove mirror_parry_band
tag @e[tag=mirror_parry_kb] remove mirror_parry_kb
execute at @s run tag @e[tag=monster,distance=..3.5] add mirror_parry_cand
execute at @s run tag @e[tag=mirror_boss,distance=..3.5] add mirror_parry_cand
execute at @s run tag @e[tag=mirror_summon,distance=..3.5] add mirror_parry_cand

tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
# 环 (0,0.25]
execute at @s run tag @e[tag=mirror_parry_cand,distance=..0.25] add mirror_parry_band
execute at @s rotated ~ 0 positioned ^ ^ ^0.25 run tag @e[tag=mirror_parry_band,distance=..0.27] add mirror_parry_hit
tag @e[tag=mirror_parry_band] remove mirror_parry_cand
tag @e[tag=mirror_parry_band] remove mirror_parry_band
# 环 (0.25,0.5]
execute at @s run tag @e[tag=mirror_parry_cand,distance=..0.5] add mirror_parry_band
execute at @s rotated ~ 0 positioned ^ ^ ^0.5 run tag @e[tag=mirror_parry_band,distance=..0.52] add mirror_parry_hit
tag @e[tag=mirror_parry_band] remove mirror_parry_cand
tag @e[tag=mirror_parry_band] remove mirror_parry_band
# 环 (0.5,0.75]
execute at @s run tag @e[tag=mirror_parry_cand,distance=..0.75] add mirror_parry_band
execute at @s rotated ~ 0 positioned ^ ^ ^0.75 run tag @e[tag=mirror_parry_band,distance=..0.77] add mirror_parry_hit
tag @e[tag=mirror_parry_band] remove mirror_parry_cand
tag @e[tag=mirror_parry_band] remove mirror_parry_band
# 环 (0.75,1.0]
execute at @s run tag @e[tag=mirror_parry_cand,distance=..1.0] add mirror_parry_band
execute at @s rotated ~ 0 positioned ^ ^ ^1.0 run tag @e[tag=mirror_parry_band,distance=..1.02] add mirror_parry_hit
tag @e[tag=mirror_parry_band] remove mirror_parry_cand
tag @e[tag=mirror_parry_band] remove mirror_parry_band
# 环 (1.0,1.25]
execute at @s run tag @e[tag=mirror_parry_cand,distance=..1.25] add mirror_parry_band
execute at @s rotated ~ 0 positioned ^ ^ ^1.25 run tag @e[tag=mirror_parry_band,distance=..1.27] add mirror_parry_hit
tag @e[tag=mirror_parry_band] remove mirror_parry_cand
tag @e[tag=mirror_parry_band] remove mirror_parry_band
# 环 (1.25,1.5]
execute at @s run tag @e[tag=mirror_parry_cand,distance=..1.5] add mirror_parry_band
execute at @s rotated ~ 0 positioned ^ ^ ^1.5 run tag @e[tag=mirror_parry_band,distance=..1.52] add mirror_parry_hit
tag @e[tag=mirror_parry_band] remove mirror_parry_cand
tag @e[tag=mirror_parry_band] remove mirror_parry_band
# 环 (1.5,1.75]
execute at @s run tag @e[tag=mirror_parry_cand,distance=..1.75] add mirror_parry_band
execute at @s rotated ~ 0 positioned ^ ^ ^1.75 run tag @e[tag=mirror_parry_band,distance=..1.77] add mirror_parry_hit
tag @e[tag=mirror_parry_band] remove mirror_parry_cand
tag @e[tag=mirror_parry_band] remove mirror_parry_band
# 环 (1.75,2.0]
execute at @s run tag @e[tag=mirror_parry_cand,distance=..2.0] add mirror_parry_band
execute at @s rotated ~ 0 positioned ^ ^ ^2.0 run tag @e[tag=mirror_parry_band,distance=..2.02] add mirror_parry_hit
tag @e[tag=mirror_parry_band] remove mirror_parry_cand
tag @e[tag=mirror_parry_band] remove mirror_parry_band
# 环 (2.0,2.25]
execute at @s run tag @e[tag=mirror_parry_cand,distance=..2.25] add mirror_parry_band
execute at @s rotated ~ 0 positioned ^ ^ ^2.25 run tag @e[tag=mirror_parry_band,distance=..2.27] add mirror_parry_hit
tag @e[tag=mirror_parry_band] remove mirror_parry_cand
tag @e[tag=mirror_parry_band] remove mirror_parry_band
# 环 (2.25,2.5]
execute at @s run tag @e[tag=mirror_parry_cand,distance=..2.5] add mirror_parry_band
execute at @s rotated ~ 0 positioned ^ ^ ^2.5 run tag @e[tag=mirror_parry_band,distance=..2.52] add mirror_parry_hit
tag @e[tag=mirror_parry_band] remove mirror_parry_cand
tag @e[tag=mirror_parry_band] remove mirror_parry_band
# 环 (2.5,2.75]
execute at @s run tag @e[tag=mirror_parry_cand,distance=..2.75] add mirror_parry_band
execute at @s rotated ~ 0 positioned ^ ^ ^2.75 run tag @e[tag=mirror_parry_band,distance=..2.77] add mirror_parry_hit
tag @e[tag=mirror_parry_band] remove mirror_parry_cand
tag @e[tag=mirror_parry_band] remove mirror_parry_band
# 环 (2.75,3.0]
execute at @s run tag @e[tag=mirror_parry_cand,distance=..3.0] add mirror_parry_band
execute at @s rotated ~ 0 positioned ^ ^ ^3.0 run tag @e[tag=mirror_parry_band,distance=..3.02] add mirror_parry_hit
tag @e[tag=mirror_parry_band] remove mirror_parry_cand
tag @e[tag=mirror_parry_band] remove mirror_parry_band
# 环 (3.0,3.25]
execute at @s run tag @e[tag=mirror_parry_cand,distance=..3.25] add mirror_parry_band
execute at @s rotated ~ 0 positioned ^ ^ ^3.25 run tag @e[tag=mirror_parry_band,distance=..3.27] add mirror_parry_hit
tag @e[tag=mirror_parry_band] remove mirror_parry_cand
tag @e[tag=mirror_parry_band] remove mirror_parry_band
# 环 (3.25,3.5]
execute at @s run tag @e[tag=mirror_parry_cand,distance=..3.5] add mirror_parry_band
execute at @s rotated ~ 0 positioned ^ ^ ^3.5 run tag @e[tag=mirror_parry_band,distance=..3.52] add mirror_parry_hit
tag @e[tag=mirror_parry_band] remove mirror_parry_cand
tag @e[tag=mirror_parry_band] remove mirror_parry_band

# 同类取最近；保留 monster → mirror_boss → mirror_summon fallback
execute at @s run tag @e[tag=mirror_parry_hit,tag=monster,distance=..3.5,sort=nearest,limit=1] add mirror_dmg_target
execute at @s unless entity @e[tag=mirror_dmg_target,limit=1] run tag @e[tag=mirror_parry_hit,tag=mirror_boss,distance=..3.5,sort=nearest,limit=1] add mirror_dmg_target
execute at @s unless entity @e[tag=mirror_dmg_target,limit=1] run tag @e[tag=mirror_parry_hit,tag=mirror_summon,distance=..3.5,sort=nearest,limit=1] add mirror_dmg_target
tag @e[tag=mirror_parry_hit] remove mirror_parry_hit
tag @e[tag=mirror_parry_cand] remove mirror_parry_cand

# PvP/非白名单：没有可反射目标 → 不回血、不反射、不消耗架势（直接返回，保留 mirror_parry）
execute unless entity @e[tag=mirror_dmg_target,limit=1] run return 0

# 确认目标后才回补 50%（设计：挡一半，不是无敌）
# 玩家 Health 不可写，用 instant_health 近似。I=4 / II=8 / III=16 / IV=32 HP。
# 只取「不超过半伤」的最大档位，避免 3 HP 近战回 4 HP 净赚；<4 HP 的半伤无法用
# instant_health 精确表示（最小 4 HP），这里选择不回也不超量，属于 vanilla 限制。
scoreboard players operation #skill mirror_skill_tmp3 = #skill mirror_skill_tmp2
scoreboard players operation #skill mirror_skill_tmp3 /= 2 int
execute if score #skill mirror_skill_tmp3 matches 3200.. run effect give @s minecraft:instant_health 1 3
execute if score #skill mirror_skill_tmp3 matches 1600..3199 run effect give @s minecraft:instant_health 1 2
execute if score #skill mirror_skill_tmp3 matches 800..1599 run effect give @s minecraft:instant_health 1 1
execute if score #skill mirror_skill_tmp3 matches 400..799 run effect give @s minecraft:instant_health 1 0

# 反射比例：基础 60%；明镜本次 ×1.5 = 90%；SKL 映心 +25pp（/10）
scoreboard players set #skill mirror_skill_ratio 60
execute if score @s mirror_parry_mingjing matches 1.. run scoreboard players set #skill mirror_skill_ratio 90
scoreboard players set #skill mirror_skill_tmp 0
scoreboard players operation #skill mirror_skill_tmp = @s wp_affix_skl_ying_xin
scoreboard players operation #skill mirror_skill_tmp /= #const10 mirror_calc
scoreboard players operation #skill mirror_skill_ratio += #skill mirror_skill_tmp
execute if score #skill mirror_skill_ratio matches 101.. run scoreboard players set #skill mirror_skill_ratio 100
scoreboard players operation #skill mirror_skill_tmp2 *= #skill mirror_skill_ratio
scoreboard players operation #skill mirror_skill_tmp2 /= 100 int

scoreboard players operation #temp entity_hurt_temp = #skill mirror_skill_tmp2
# armor 结算完会清 mirror_dmg_target；击退目标先用独立 tag 保存
execute if entity @e[tag=mirror_dmg_target,limit=1] run tag @e[tag=mirror_dmg_target,limit=1] add mirror_parry_kb
execute if entity @e[tag=mirror_dmg_target,limit=1] run tag @s add mirror_parry_success
execute if entity @e[tag=mirror_dmg_target,limit=1] run tag @s add mirror_skill
execute if entity @e[tag=mirror_dmg_target,limit=1] run function plm:mirror/set/zhao/vuln
execute if entity @e[tag=mirror_dmg_target,limit=1] run function plm:mirror/damage/armor
tag @s remove mirror_skill
# 照心 2 件套：反射成功叠镜心（每层 +4% 减伤；4 件套满层自动碎镜）。
# 用 success 标记而不是 kb tag：反射一击把目标打死时 kb tag 会随实体消失，仍应算成功反射。
execute if entity @s[tag=mirror_parry_success] run function plm:mirror/set/zhao/heart_add
tag @s remove mirror_parry_success
# 反射后 2 格击退：伤害先结算，再位移；不写 Motion / NoAI / knockback_resistance，
# Boss 的既有 AI/抗性处理不被改写。面向目标 eyes 取水平朝向，以目标为原点沿该朝向
# 后退 2 格（等价于 tp 目标 自身位置 + 水平远离玩家 2 格）。
execute if entity @e[tag=mirror_parry_kb,limit=1] at @s facing entity @e[tag=mirror_parry_kb,limit=1] eyes rotated ~ 0 positioned as @e[tag=mirror_parry_kb,limit=1] run tp @e[tag=mirror_parry_kb,limit=1] ^ ^ ^2
tag @e[tag=mirror_parry_kb] remove mirror_parry_kb
execute at @s positioned ^ ^ ^1.75 run particle minecraft:crit ~ ~ ~ 0.4 0.4 0.4 0.1 12
execute at @s positioned ^ ^ ^1.75 run playsound minecraft:block.amethyst_cluster.break master @a ~ ~ ~ 1 1.4

# 完美奖励：明镜 5s（20 个 5t 单位）
execute if score #skill mirror_skill_perfect matches 1.. run scoreboard players set @s mirror_mingjing 20
execute if score #skill mirror_skill_perfect matches 1.. run particle minecraft:end_rod ~ ~1 ~ 0.7 0.9 0.7 0.05 30

# 架势结束（被打掉，不返还冷却）
scoreboard players set @s mirror_parry 0
scoreboard players set @s mirror_parry_perfect 0
scoreboard players set @s mirror_parry_mingjing 0
scoreboard players set @s mirror_parry_done 1
