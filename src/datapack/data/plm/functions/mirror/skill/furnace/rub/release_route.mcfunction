# 拓印炉·放印（right_click_run=26）
# 入口：plm:mirror/skill/route（#pld:right_click/do）；check 阶段由 plm:mirror/input/check 覆写
# 条件：主手 panling:mirror_furnace_rub7 + act:1 + job2 + 副手空 + mirror_cd_a 可用
# 无印：只提示「印不足」，不进冷却；有印：消耗全部（合印·生 40% 不消耗，仍进冷却）
execute unless entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_furnace_rub7"}}}] run return 0
execute unless score @s job matches 2 run return 0
execute if data entity @s Inventory[{Slot:-106b}] run return 0
# 施法锁：0.5s 内重复触发直接丢弃，不扣冷却（设计 §1.6）
execute if score @s mirror_cast_lock matches 1.. run return 0
# 冷却中：显示剩余秒数后 return（不施放、不重置冷却）
execute if score @s mirror_cd_a matches 1.. run scoreboard players operation #mirror_msg_cd mirror_msg = @s mirror_cd_a
execute if score @s mirror_cd_a matches 1.. run function plm:mirror/msg/cooling
execute if score @s mirror_cd_a matches 1.. run return 0
# 2/4/真影律分档（同时把印收敛到 3/5）
function plm:mirror/set/rub/tier
execute unless score @s mirror_rub_stack matches 1.. run title @s actionbar {"text":"印不足","color":"red"}
execute unless score @s mirror_rub_stack matches 1.. run return 0

# --- 伤害基数 ---
# mirror_zf_base：最近一次本体阵法的实际伤害快照（×10，0.1 HP），由 rub/after_main|off 写
# （现在已按金属阵 250% 换算；木/火/水/土主阵不造成伤害，快照为 0）
scoreboard players set @s mirror_rub_base 0
execute if score @s mirror_zf_base matches 1.. run scoreboard players operation @s mirror_rub_base = @s mirror_zf_base
# 旧快照/降级：主阵元素=金 + zf_str 整数 HP → 实际伤害 ×10 = zf_str ×25
# 用 mirror_zf_main_el（counter 之前的主阵元素），不能用 mirror_zf_el（可能是倒影元素）。
execute unless score @s mirror_zf_base matches 1.. if score @s mirror_zf_snap matches 1 if score @s mirror_zf_main_el matches 1 if score @s zf_str matches 1.. run scoreboard players operation @s mirror_rub_base = @s zf_str
execute unless score @s mirror_zf_base matches 1.. if score @s mirror_zf_snap matches 1 if score @s mirror_zf_main_el matches 1 if score @s zf_str matches 1.. run scoreboard players operation @s mirror_rub_base *= #const25 mirror_calc
# 完全没有快照（从未放过本体阵）：用副手元素/镜炉的基础阵法伤害兜底。
# 镜炉物品 base.atk_pt 18.7 scale 10 = 187（×10），金属阵 ×250% → 187 × 25 / 10 = 467。
scoreboard players set #rub_fb mirror_rub_cd 0
execute if score @s mirror_rub_base matches ..0 unless score @s mirror_zf_snap matches 1 run scoreboard players set #rub_fb mirror_rub_cd 1
execute if score #rub_fb mirror_rub_cd matches 1 store result score @s mirror_rub_base run data get entity @s SelectedItem.tag.mirror_base.base.atk_pt 10
execute if score #rub_fb mirror_rub_cd matches 1 run scoreboard players operation @s mirror_rub_base *= #const25 mirror_calc
execute if score #rub_fb mirror_rub_cd matches 1 run scoreboard players operation @s mirror_rub_base /= #const10 mirror_calc

# --- 伤害 = 印数 × (15 + 拓片·上/100) % × 基数 × (1 + 拓片·强/100) ---
# mirror_rub_base 是 HP×10；下面是 100=1HP 的定点，×100 与 HP×10 正好抵消（/10）
scoreboard players set #rub mirror_rub_extra 15
scoreboard players set #skill mirror_skill_tmp 0
scoreboard players operation #skill mirror_skill_tmp = @s wp_affix_skl_ta_pian_shang
scoreboard players operation #skill mirror_skill_tmp /= #const100 mirror_calc
scoreboard players operation #rub mirror_rub_extra += #skill mirror_skill_tmp
scoreboard players operation #rub mirror_rub_extra *= @s mirror_rub_stack
scoreboard players operation #rub mirror_rub_extra *= @s mirror_rub_base
scoreboard players operation #rub mirror_rub_extra /= #const10 mirror_calc
# 拓片·强：wp_affix_skl_ta_pian_qiang 满 150 = +15%（/10）
scoreboard players set #skill mirror_skill_tmp 0
scoreboard players operation #skill mirror_skill_tmp = @s wp_affix_skl_ta_pian_qiang
scoreboard players operation #skill mirror_skill_tmp /= #const10 mirror_calc
scoreboard players add #skill mirror_skill_tmp 100
scoreboard players operation #rub mirror_rub_extra *= #skill mirror_skill_tmp
scoreboard players operation #rub mirror_rub_extra /= #const100 mirror_calc

# --- 照妖：对显形目标额外 +15%，照妖·深 满 800 = +8pp（/100）→ 23% ---
scoreboard players set #skill mirror_skill_tmp2 15
scoreboard players set #skill mirror_skill_tmp3 0
scoreboard players operation #skill mirror_skill_tmp3 = @s wp_affix_skl_zhao_yao_shen
scoreboard players operation #skill mirror_skill_tmp3 /= #const100 mirror_calc
scoreboard players operation #skill mirror_skill_tmp2 += #skill mirror_skill_tmp3
scoreboard players add #skill mirror_skill_tmp2 100

# --- 显形时长：3s + 显影·久（满 300 = 3.00s，/100 取整秒）---
# 假玩家 #rub 的 mirror_rub_free 在本链路复用为「显影秒数」；玩家身上的 mirror_rub_free 才是免耗标记
scoreboard players set #rub mirror_rub_free 3
scoreboard players set #skill mirror_skill_tmp3 0
scoreboard players operation #skill mirror_skill_tmp3 = @s wp_affix_skl_xian_ying_jiu
scoreboard players operation #skill mirror_skill_tmp3 /= #const100 mirror_calc
scoreboard players operation #rub mirror_rub_free += #skill mirror_skill_tmp3

# --- 本次放印使用的击杀类型（0 = 未记录，按设计默认「其他/定身」）---
scoreboard players set #rub mirror_rub_type 0
scoreboard players operation #rub mirror_rub_type = @s mirror_rub_type
execute if score #rub mirror_rub_type matches 0 run scoreboard players set #rub mirror_rub_type 4

# --- 合印·生：40%（wp_affix_skl_he_yin_sheng 满 400 /10）概率本次不消耗印 ---
function plm:mirror/skill/furnace/rub/roll
scoreboard players set #skill mirror_skill_tmp3 0
scoreboard players operation #skill mirror_skill_tmp3 = @s wp_affix_skl_he_yin_sheng
scoreboard players operation #skill mirror_skill_tmp3 /= #const10 mirror_calc
scoreboard players set @s mirror_rub_free 0
execute if score #rub mirror_rub_cd < #skill mirror_skill_tmp3 run scoreboard players set @s mirror_rub_free 1

# --- 真影律：放印不消耗印（120s = 480 个 5t 内部冷却；仍占 15s 外部 CD）---
# 合印·生已经免耗时不再消耗真影律冷却，避免两个免耗叠加浪费。
scoreboard players set #rub mirror_rub_award 0
execute if score @s mirror_rub_free matches 0 if score @s mirror_true_law matches 1 if score @s mirror_rub_true_cd matches ..0 run scoreboard players set #rub mirror_rub_award 1
execute if score #rub mirror_rub_award matches 1 run scoreboard players set @s mirror_rub_free 1
execute if score #rub mirror_rub_award matches 1 run scoreboard players set @s mirror_rub_true_cd 480

# --- 结算：4 格 AoE（伤害 + 显形 + 按类型的次要效果）---
tag @s add rub_caster
function plm:mirror/skill/furnace/rub/release/damage
tag @s remove rub_caster
function plm:mirror/skill/furnace/rub/release/fx

# --- 消耗：合印·生 / 真影律 触发时保留（仍然进冷却）---
execute if score @s mirror_rub_free matches 0 run scoreboard players set @s mirror_rub_stack 0
# --- 4 件套：放印后 5s 内下一次本体阵法 +5% ---
scoreboard players set @s mirror_rub_next_bonus 0
execute if score @s mirror_set_4 matches 1 run scoreboard players operation @s mirror_rub_next_bonus = #sys mirror_game_time
execute if score @s mirror_set_4 matches 1 run scoreboard players add @s mirror_rub_next_bonus 100
# 冷却 15s = 60 × 5t，按 weapon_skill_cool_reduce 缩减
scoreboard players set #cd mirror_skill_tmp 60
function plm:mirror/skill/reduce_cool
scoreboard players operation @s mirror_cd_a = #cd mirror_skill_tmp
scoreboard players operation @s mirror_last_combat = #sys mirror_game_time

# --- 技能成功钩子（防具 2/4 件套的武器技能触发；必须调防具入口）---
scoreboard players set @s skill_success 1
function pld:equipment_lock/equipment/armor/set_bonus/when_weapon_skill_enable
scoreboard players set @s skill_success 0
# 施法锁 10t（0.5s）：入口 1.. 直接丢弃，不扣冷却
scoreboard players set @s mirror_cast_lock 10

# --- 提示 ---
execute if score @s mirror_rub_base matches 0 run title @s actionbar {"text":"无阵法快照：本次放印伤害为 0","color":"red"}
execute unless score @s mirror_rub_base matches 0 if score #rub mirror_rub_award matches 1 run title @s actionbar {"text":"真影律：本次不消耗印","color":"light_purple"}
execute unless score @s mirror_rub_base matches 0 if score #rub mirror_rub_award matches 0 if score @s mirror_rub_free matches 1 run title @s actionbar {"text":"合印·生：本次不消耗印","color":"aqua"}
execute unless score @s mirror_rub_base matches 0 if score #rub mirror_rub_award matches 0 if score @s mirror_rub_free matches 0 run function plm:mirror/skill/furnace/rub/bar
