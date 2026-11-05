# 单个目标结算：@s = 主人玩家；位置 = 阵中心；#tw_n = 剩余目标数。
# 流程：选最近候选 → 双阵同中判定 → 倍率 → 伤害 → 递归下一个。
# 共鸣叠层不在这里做：echo/damage 在逐目标循环结束后按「每阵一次」调用 resonance/stack。
execute unless entity @e[tag=mirror_zf_hit] run return 0
tag @e[tag=mirror_zf_cur] remove mirror_zf_cur
tag @e[tag=mirror_zf_hit,sort=nearest,limit=1] add mirror_zf_cur
tag @e[tag=mirror_zf_cur] remove mirror_zf_hit

# 双阵同中：主阵标记 tag + until >= game_time（1s 窗口）+ owner 必须一致
# owner 防止 B 玩家的倒影消费 A 玩家主阵留下的标记。
scoreboard players operation #tw_uid mirror_skill_atk = @s player_uid
scoreboard players set #tw_flag mirror_skill_perfect 0
execute as @e[tag=mirror_zf_cur,limit=1] if entity @s[tag=mirror_resonance_mark] if score @s mirror_resonance_owner = #tw_uid mirror_skill_atk if score @s mirror_resonance_target >= #sys mirror_game_time run scoreboard players set #tw_flag mirror_skill_perfect 1
# 过期标记就地清理（不做全局实体 tick）；已消费的标记也移除，避免重复叠层
execute as @e[tag=mirror_zf_cur,limit=1,tag=mirror_resonance_mark] unless score @s mirror_resonance_target >= #sys mirror_game_time run tag @s remove mirror_resonance_mark
execute if score #tw_flag mirror_skill_perfect matches 1 as @e[tag=mirror_zf_cur,limit=1] run tag @s remove mirror_resonance_mark

# 叠共鸣（上限 3、15s；gong_ming_shang 的额外层由 #tw_shang 决定）
# 每座倒影阵只叠一次（#63）：逐目标只记「本阵有同中」，真正的 stack 在
# echo/damage 的逐目标循环结束后执行，触发共鸣的这一发倒影只吃加层前的层数。
execute if score #tw_flag mirror_skill_perfect matches 1 run scoreboard players set #tw_any mirror_resonance_extra 1
# 2 件套：任意阵法命中都算“本阵有命中”，每阵叠 1 层
execute if score #tw_2pc mirror_resonance_max matches 1 run scoreboard players set #tw_any mirror_resonance_extra 1

# 共鸣过期判定（读时比较，不挂实体 tick）
execute unless score @s mirror_resonance_until >= #sys mirror_game_time run scoreboard players set @s mirror_resonance 0
execute unless score @s mirror_resonance matches 0.. run scoreboard players set @s mirror_resonance 0
execute if score @s mirror_resonance matches 4.. run scoreboard players set @s mirror_resonance 3

# 倍率×10：1000 + 层数×(40 + gong_ming_xiao/10) + 双生·契（双阵同中时 +shuang_sheng_qi）
scoreboard players set #tw_stack mirror_zf_tmp 40
scoreboard players set #tw_chance mirror_zf_tmp 0
scoreboard players operation #tw_chance mirror_zf_tmp = @s wp_affix_skl_gong_ming_xiao
scoreboard players operation #tw_chance mirror_zf_tmp /= #const10 mirror_calc
scoreboard players operation #tw_stack mirror_zf_tmp += #tw_chance mirror_zf_tmp
scoreboard players operation #tw_stack mirror_zf_tmp *= @s mirror_resonance
scoreboard players set #tw_mult mirror_skill_lie_pct 1000
scoreboard players operation #tw_mult mirror_skill_lie_pct += #tw_stack mirror_zf_tmp
execute if score #tw_flag mirror_skill_perfect matches 1 run scoreboard players operation #tw_mult mirror_skill_lie_pct += @s wp_affix_skl_shuang_sheng_qi

# 伤害：base（0.1 HP 定点）× ratio（百分比×10）/100 → 100 = 1 HP；再乘共鸣/双生倍率
scoreboard players operation #tw_dmg mirror_skill_tmp2 = #tw_base mirror_skill_tmp
scoreboard players operation #tw_dmg mirror_skill_tmp2 *= #tw_ratio mirror_skill_ratio
scoreboard players operation #tw_dmg mirror_skill_tmp2 /= #const100 mirror_calc
scoreboard players operation #tw_dmg mirror_skill_tmp2 *= #tw_mult mirror_skill_lie_pct
scoreboard players operation #tw_dmg mirror_skill_tmp2 /= #const1000 mirror_calc

# 元素抗性不再在这里手算：plm:mirror/damage/armor → 本体 public_damage_entity
# 已经会按 Resistance（Id:11，每级 -20%，封顶 5 级）减一次。这里再减就是双重减伤。
# in30_boss4：本体对阵法减伤 20%（这是阵法的独立减伤，不在公共管线里）
execute if entity @e[tag=mirror_zf_cur,limit=1,tag=in30_boss4] run scoreboard players operation #tw_dmg mirror_skill_tmp2 *= #const2 mirror_calc
execute if entity @e[tag=mirror_zf_cur,limit=1,tag=in30_boss4] run scoreboard players operation #tw_dmg mirror_skill_tmp2 /= #const10 mirror_calc

# 4 件套「相克」：目标有效元素抗性降一级。只影响 DLC 阵法伤害（预乘到 #tw_dmg），
# 不改目标 ActiveEffects；N=5 时公共管线乘 0，无法预乘救回（报告写 blocker）。
execute as @e[tag=mirror_zf_cur,limit=1,tag=mirror_element_break_active] if score @s mirror_element_break >= #sys mirror_game_time run function plm:mirror/set/twin/element_break_mult

# DLC zf 管路口径：本体没有可复用的通用元素伤害入口，因此由
# plm:mirror/damage/zf 作为 DLC 的阵法伤害包装：目标打 mirror_formation，
# 走一次 public_damage_entity（护甲/保护/一次 Resistance），再清标识。
# 这不是本体 zf 的 metal/wood 函数，但 mirror_formation 已被实际消费，
# 不再只是遗留 tag；不要把“包装”写成“本体 zf 函数已接”。
# 结算：目标打 mirror_dmg_target，走 DLC zf 包装。
execute if score #tw_dmg mirror_skill_tmp2 matches 1.. as @e[tag=mirror_zf_cur,limit=1] run tag @s add mirror_dmg_target
scoreboard players operation #temp entity_hurt_temp = #tw_dmg mirror_skill_tmp2
execute if score #tw_dmg mirror_skill_tmp2 matches 1.. run function plm:mirror/damage/zf
tag @e[tag=mirror_dmg_target] remove mirror_dmg_target
tag @e[tag=mirror_zf_cur,limit=1] remove mirror_formation

# 4 件套：满共鸣时给本目标挂「相克」（10s，DLC 私有 debuff）
# 放在伤害之后：本次触发相克的这一发按加层前/加相克前的抗性结算，后续阵法命中才吃降抗。
execute if score #tw_4pc mirror_twin_4_until matches 1 if score @s mirror_resonance_until >= #sys mirror_game_time if score @s mirror_resonance matches 3.. as @e[tag=mirror_zf_cur,limit=1] run function plm:mirror/set/twin/element_break

# 下一个目标
tag @e[tag=mirror_zf_cur] remove mirror_zf_cur
scoreboard players remove #tw_n mirror_furnace_cast 1
execute if score #tw_n mirror_furnace_cast matches 1.. run function plm:mirror/skill/furnace/twin/echo/hit
