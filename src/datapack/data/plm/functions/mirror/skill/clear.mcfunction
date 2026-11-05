# 镜武状态清理：死亡 / 换维度 / 重登调用（@s=玩家）
# 接线：plm:tick/main（死亡 deathCount、重登 leave_game）
#       plm:mirror/event/dim_change（advancement changed_dimension）
# 已出手的箭保留；已召出的倒影/弩机/待结算 marker 按 owner 跨维度清除。
# 4 件套临时 QC3 是物品上的状态：死亡/换维度/重登先还原（箱子/容器无法全局定位）。
execute if score @s mirror_crossbow_4_bonus matches 100.. run function plm:mirror/set/can/qc_clear
# 分数已被提前清掉但物品仍带标记：也必须还原，不能把 QC3 留在物品上
execute if data entity @s SelectedItem.tag.mirror_qc3 run function plm:mirror/set/can/qc_clear
scoreboard players set @s mirror_parry 0
scoreboard players set @s mirror_parry_perfect 0
# done 写 1（不是 0）：player_tick_dim 每 5t 对 parry=0 且 done=0 的玩家调 parry/expire，
# expire 会把 mirror_cd_a 减半（自然到期的 50% 返还）。死亡/换维度/重登不是自然到期，
# 若这里写 0，下一 5t 就会误返还冷却；写 1 让 tick 跳过 expire，正常架势走 expire 的路径不变。
scoreboard players set @s mirror_parry_done 1
scoreboard players set @s mirror_parry_hp 0
scoreboard players set @s mirror_parry_mingjing 0
scoreboard players set @s mirror_mingjing 0
scoreboard players set @s mirror_cd_int 0
scoreboard players set @s mirror_cast_lock 0
scoreboard players set @s mirror_taying_dist 0
scoreboard players set @s mirror_taying_buff 0
scoreboard players set @s mirror_taying_cd 0
scoreboard players set @s mirror_taying_last_x 0
scoreboard players set @s mirror_taying_last_z 0
scoreboard players set @s mirror_taying_dx 0
scoreboard players set @s mirror_taying_dz 0
scoreboard players set @s mirror_shadow_5ticks 0
scoreboard players set @s mirror_chongying_5ticks 0
scoreboard players set @s mirror_ch_queue 0
scoreboard players set @s mirror_yingsui_5ticks 0
scoreboard players set @s mirror_yingsui_i 0
scoreboard players set @s mirror_yingsui_x 0
scoreboard players set @s mirror_yingsui_z 0
scoreboard players set @s mirror_turret_5ticks 0
scoreboard players set @s mirror_turret_atk 0
scoreboard players set @s mirror_turret_ratio 0
scoreboard players set @s mirror_turret_interval 0
scoreboard players set @s mirror_turret_shots 0
scoreboard players set @s mirror_turret_prev 0
scoreboard players set @s mirror_turret_count 0
scoreboard players set @s mirror_path_t 0
scoreboard players set @s mirror_path_n 0
scoreboard players set @s mirror_path_i 0
scoreboard players set @s mirror_path_dim 0
scoreboard players set @s mirror_path_ysn 0
scoreboard players set @s mirror_path_taken 0
scoreboard players set @s mirror_trail_i 0
scoreboard players set @s mirror_trail_n 0
scoreboard players set @s mirror_trail_init 0
scoreboard players set @s mirror_trail_lx 0
scoreboard players set @s mirror_trail_lz 0
scoreboard players set @s mirror_trail_lw 0
scoreboard players set @s mirror_lian 0
scoreboard players set @s mirror_lian_target 0
scoreboard players set @s mirror_lian_until 0
scoreboard players set @s mirror_lian_extra 0
scoreboard players set @s mirror_lian_next_pierce 0
scoreboard players set @s mirror_bloom_5ticks 0
scoreboard players set @s mirror_bloom_dmg 0
scoreboard players set @s mirror_bloom_range 0
scoreboard players set @s mirror_bloom_extra 0
scoreboard players set @s mirror_bloom_free 0
scoreboard players set @s mirror_bloom_count 0
scoreboard players set @s mirror_bloom_pct 0
scoreboard players set @s mirror_bloom_target 0
scoreboard players set @s mirror_flower 0
scoreboard players set @s mirror_flower_until 0
scoreboard players set @s mirror_flower_max 0
scoreboard players set @s mirror_flower_extra 0
scoreboard players set @s mirror_box_5ticks 0
scoreboard players set @s mirror_box_el 0
scoreboard players set @s mirror_box_remember 0
scoreboard players set @s mirror_box_ray 0
scoreboard players set @s mirror_zf_base 0
scoreboard players set @s mirror_zf_raw 0
scoreboard players set @s mirror_zf_raw_dmg 0
scoreboard players set @s mirror_zf_mult 0
scoreboard players set @s mirror_zf_el 0
scoreboard players set @s mirror_zf_main_el 0
scoreboard players set @s mirror_zf_snap 0
scoreboard players set @s mirror_zf_due 0
scoreboard players set @s mirror_zf_owner 0
scoreboard players set @s mirror_resonance 0
scoreboard players set @s mirror_resonance_until 0
scoreboard players set @s mirror_resonance_target 0
scoreboard players set @s mirror_resonance_extra 0
scoreboard players set @s mirror_resonance_owner 0
scoreboard players set @s mirror_rub_stack 0
scoreboard players set @s mirror_rub_type 0
scoreboard players set @s mirror_rub_base 0
scoreboard players set @s mirror_rub_flag 0
scoreboard players set @s mirror_rub_award 0
scoreboard players set @s mirror_rub_cd 0
scoreboard players set @s mirror_rub_extra 0
scoreboard players set @s mirror_rub_free 0
scoreboard players set @s mirror_rub_rubbable 0

# 记录 tag 也要移除：否则 path_t=0 后下一次 5t 会立刻 record 一点并齐射
tag @s remove mirror_yingsui_rec
tag @s remove mirror_box_done
tag @s remove mirror_lie_attacker
tag @s remove mirror_skill

# 实体侧：只清属于该玩家的实体；按三个维度展开，旧维度也要清。
scoreboard players operation #mirror_clear mirror_skill_tmp = @s player_uid
# 双生倒影阵已改为 storage 队列（#64）：同步丢弃该 owner 的待结算条目。
function plm:mirror/skill/furnace/twin/echo/purge_owner
execute in minecraft:overworld run function plm:mirror/skill/clear_dim
execute in minecraft:the_nether run function plm:mirror/skill/clear_dim
execute in minecraft:the_end run function plm:mirror/skill/clear_dim
