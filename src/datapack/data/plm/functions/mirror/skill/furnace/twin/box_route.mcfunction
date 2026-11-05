# 双生炉·镜匣（潜行右键）：input/check 已把「潜行 + 手持双生炉」的 right_click_run 覆写成 23。
# 炉在主手或副手都可以：主手炉 → 元素在副手（#tw_hand=-1）；副手炉 → 元素在主手（#tw_hand=1）。
# 效果：在准星目标位置（射线；无目标则脚下）生成相克元素倒影阵，强度 50%，不消耗元素、不触发倒映。
execute unless score @s job matches 2 run return 0
# 施法锁：0.5s 内重复触发直接丢弃，不扣冷却（设计 §1.6）
execute if score @s mirror_cast_lock matches 1.. run return 0
# 未设置 mirror_cd_a 时按 0 处理（`matches 0` 对未设置分数为假）
# 冷却中：显示剩余秒数后 return（不施放、不重置冷却）
execute if score @s mirror_cd_a matches 1.. run scoreboard players operation #mirror_msg_cd mirror_msg = @s mirror_cd_a
execute if score @s mirror_cd_a matches 1.. run function plm:mirror/msg/cooling
execute if score @s mirror_cd_a matches 1.. run return 0
execute unless entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_twin7",act:1}}}] unless entity @s[nbt={Inventory:[{Slot:-106b,tag:{id:"panling:mirror_furnace_twin7",act:1}}]}] run return 0

# 确认元素在哪只手
scoreboard players set #tw_hand mirror_zf_tmp -1
execute unless entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_twin7",act:1}}}] run scoreboard players set #tw_hand mirror_zf_tmp 1

# 元素快照（没有元素：提示「无元素」后返回）
scoreboard players set @s mirror_zf_el 0
function plm:mirror/skill/furnace/twin/element/snapshot
execute if score @s mirror_zf_el matches 0 run title @s actionbar {"text":"镜匣无元素","color":"red"}
execute if score @s mirror_zf_el matches 0 run return 0
# 主阵元素（在 counter 之前保存；用于判断金属主阵的伤害底座）
scoreboard players operation #tw_main_el mirror_zf_tmp3 = @s mirror_zf_el
function plm:mirror/skill/furnace/twin/element/counter

# 镜匣元素记忆 30s（120 个 5t）：下一次倒映优先用它，而不是自动相克
scoreboard players operation @s mirror_box_el = @s mirror_zf_el
scoreboard players set @s mirror_box_5ticks 120
scoreboard players set @s mirror_box_remember 1

# 伤害基数：优先最近一次主阵快照（不含共鸣的 mirror_zf_raw_dmg）；
# 没有快照时读镜炉物品的 base.atk_pt（double 18.7，scale 10 → 187），
# 并按金属主阵 ×250% 换算成实际伤害 ×10：187 × 25 / 10 = 467。
# 非金属主阵不造成伤害，基数为 0。
scoreboard players set #tw_base mirror_skill_tmp 0
scoreboard players operation #tw_base mirror_skill_tmp = @s mirror_zf_raw_dmg
scoreboard players set #tw_fb mirror_zf_tmp2 0
execute if score #tw_base mirror_skill_tmp matches ..0 if score #tw_main_el mirror_zf_tmp3 matches 1 run scoreboard players set #tw_fb mirror_zf_tmp2 1
execute if score #tw_fb mirror_zf_tmp2 matches 1 if score #tw_hand mirror_zf_tmp matches -1 store result score #tw_base mirror_skill_tmp run data get entity @s SelectedItem.tag.mirror_base.base.atk_pt 10
execute if score #tw_fb mirror_zf_tmp2 matches 1 if score #tw_hand mirror_zf_tmp matches 1 store result score #tw_base mirror_skill_tmp run data get entity @s Inventory[{Slot:-106b}].tag.mirror_base.base.atk_pt 10
execute if score #tw_fb mirror_zf_tmp2 matches 1 run scoreboard players operation #tw_base mirror_skill_tmp *= #const25 mirror_calc
execute if score #tw_fb mirror_zf_tmp2 matches 1 run scoreboard players operation #tw_base mirror_skill_tmp /= #const10 mirror_calc
execute if score #tw_main_el mirror_zf_tmp3 matches 0 run scoreboard players set #tw_base mirror_skill_tmp 0

# 冷却 30s = 120 个 5t；jing_xia_jiu 按完成度 −6~−12s。
# objective = 实际值×10（max 120 → 满值 1200；词条 val 50..100 → objective 600..1200）。
# reduction = jing_xia_jiu/25 个 5t（600 → 24=6s，1200 → 48=12s；没有词条时为 0 → 仍是 30s）。
# 下限 72 = 18s（−12s）；最后再走 weapon_skill_cool_reduce。
scoreboard players set #tw_cd mirror_zf_tmp 120
scoreboard players set #tw_cd2 mirror_zf_tmp 0
scoreboard players operation #tw_cd2 mirror_zf_tmp = @s wp_affix_skl_jing_xia_jiu
scoreboard players operation #tw_cd2 mirror_zf_tmp /= #const25 mirror_calc
scoreboard players operation #tw_cd mirror_zf_tmp -= #tw_cd2 mirror_zf_tmp
execute if score #tw_cd mirror_zf_tmp matches ..72 run scoreboard players set #tw_cd mirror_zf_tmp 72
# 真影律：镜匣冷却固定 21s（84 个 5t），不再走 weapon_skill_cool_reduce
scoreboard players set #t mirror_set_tmp 4
function plm:mirror/set/can/tier
execute if score @s mirror_true_law matches 1 run scoreboard players set #tw_cd mirror_zf_tmp 84
execute if score @s mirror_true_law matches 1 run scoreboard players operation @s mirror_cd_a = #tw_cd mirror_zf_tmp
execute if score @s mirror_true_law matches 0 run scoreboard players operation #cd mirror_skill_tmp = #tw_cd mirror_zf_tmp
execute if score @s mirror_true_law matches 0 run function plm:mirror/skill/reduce_cool
execute if score @s mirror_true_law matches 0 run scoreboard players operation @s mirror_cd_a = #cd mirror_skill_tmp

# 强度百分比×10：500（50%）+ dao_ying_qiang（0..150 → +0~15pp）；双生 2 件套 +15pp（+150）= 650
scoreboard players set #tw_ratio mirror_skill_ratio 500
scoreboard players operation #tw_ratio mirror_skill_ratio += @s wp_affix_skl_dao_ying_qiang
execute if score @s mirror_set_count matches 2.. run scoreboard players add #tw_ratio mirror_skill_ratio 150
# 倒影阵 marker 的入参：元素 + 立即结算（due=0）
scoreboard players operation #tw_el mirror_skill_tmp3 = @s mirror_zf_el
scoreboard players set #tw_due mirror_zf_tmp 0

# 准星射线：从眼睛沿视线每 0.5 格步进，遇实体/方块停下；无目标则脚下。
# 1.20.1 没有 raycast 命令，用递归函数 + 方块检测近似。
tag @s remove mirror_box_done
tag @e[tag=mirror_box_hit] remove mirror_box_hit
scoreboard players set #tw_ray mirror_box_ray 0
execute at @s anchored eyes positioned ^ ^ ^0.5 run function plm:mirror/skill/furnace/twin/box_ray
tag @s remove mirror_box_done
tag @e[tag=mirror_box_hit] remove mirror_box_hit

# 施法成功钩子（契约 §3）；必须调防具入口
scoreboard players set @s skill_success 1
function pld:equipment_lock/equipment/armor/set_bonus/when_weapon_skill_enable
scoreboard players set @s skill_success 0
# 施法锁 10t（0.5s）：入口 1.. 直接丢弃，不扣冷却
scoreboard players set @s mirror_cast_lock 10
