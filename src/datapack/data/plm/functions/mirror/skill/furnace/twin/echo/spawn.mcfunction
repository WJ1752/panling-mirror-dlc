# 倒影阵入队：@s = 玩家；执行位置 = 倒影阵中心（主阵位置）。
# 输入：#tw_base mirror_skill_tmp（0.1 HP 定点）、#tw_el mirror_skill_tmp3、#tw_ratio mirror_skill_ratio（百分比×10）、#tw_due mirror_zf_tmp（5t 单位）
# 队列条目：{due,pos,el,dmg,owner,dim}；twin/tick 每 5t 递减 due，到 0 结算并删除。
# dim 在入队时用 `execute if dimension` 记录（0 主世界 / 1 下界 / 2 末地），结算时只在
# 该维度找 owner：console/schedule 源下裸 @a 可能跨维度，不能用“三个维度各跑一次”来判定。
#
# #64 口径：不再 summon marker；延迟数据全部在 storage plm:mirror echo。1.20.1 没有函数宏，
# storage 里的 pos 不能直接当 execute positioned 的参数，所以结算时用一个**同 tick 临时**
# anchor marker 把执行位置设到 pos（见 echo/resolve_anchor_at.mcfunction），结算完立即 kill。
# 该 anchor 只存活于结算函数内部（tick 边界上实体数为 0），不是每阵一个 0.5s marker；
# 真正的 0 实体要等 1.20.2+ 的函数宏。不要把它说成“完全没有实体”。
#
# 本阵最终伤害预乘：dmg = base × ratio / 100（0.01 HP 定点）。结算时把
# #tw_base = dmg、#tw_ratio = 100，echo/hit 的原公式不变，直接调用 echo/damage 的测试也不受影响。
scoreboard players operation #tw_dmg mirror_skill_tmp2 = #tw_base mirror_skill_tmp
scoreboard players operation #tw_dmg mirror_skill_tmp2 *= #tw_ratio mirror_skill_ratio
scoreboard players operation #tw_dmg mirror_skill_tmp2 /= #const100 mirror_calc

# 队列初始化 + 上限 32（超过时丢最旧）
execute unless data storage plm:mirror echo run data modify storage plm:mirror echo set value []
execute if data storage plm:mirror echo[31] run data remove storage plm:mirror echo[0]
data modify storage plm:mirror echo append value {due:0,pos:[0.0d,0.0d,0.0d],el:0,dmg:0,owner:0,dim:0}
execute store result storage plm:mirror echo[-1].due int 1 run scoreboard players get #tw_due mirror_zf_tmp
data modify storage plm:mirror echo[-1].pos set from entity @s Pos
execute store result storage plm:mirror echo[-1].el int 1 run scoreboard players get #tw_el mirror_skill_tmp3
execute store result storage plm:mirror echo[-1].dmg int 1 run scoreboard players get #tw_dmg mirror_skill_tmp2
execute store result storage plm:mirror echo[-1].owner int 1 run scoreboard players get @s player_uid
scoreboard players set #tw_dim mirror_zf_tmp3 0
execute if dimension minecraft:the_nether run scoreboard players set #tw_dim mirror_zf_tmp3 1
execute if dimension minecraft:the_end run scoreboard players set #tw_dim mirror_zf_tmp3 2
execute store result storage plm:mirror echo[-1].dim int 1 run scoreboard players get #tw_dim mirror_zf_tmp3
