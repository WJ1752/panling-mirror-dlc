# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 战斗上下文新增 objective（只在此文件 add；重复 add 会报错）
scoreboard objectives add mirror_game_time dummy
scoreboard objectives add mirror_tick20 dummy
scoreboard objectives add mirror_last_combat dummy
scoreboard objectives add mirror_last_kill dummy
scoreboard objectives add mirror_fx_shi_ying_cd dummy
scoreboard objectives add mirror_fx_jing_xi_until dummy
scoreboard objectives add mirror_fx_jing_xi_done dummy
scoreboard objectives add mirror_fx_jing_xi_next dummy
scoreboard objectives add mirror_hit_seq dummy
scoreboard objectives add mirror_ctx_extra dummy
scoreboard objectives add mirror_ctx_hit dummy
scoreboard objectives add mirror_parse_ok dummy
scoreboard objectives add mirror_form dummy
scoreboard objectives add mirror_walk_stat minecraft.custom:minecraft.walk_one_cm
scoreboard objectives add mirror_walk_last dummy
scoreboard objectives add mirror_trail_until dummy
scoreboard objectives add mirror_trail_slow_until dummy
scoreboard objectives add mirror_trail_next dummy
scoreboard objectives add mirror_arrow_crit dummy
scoreboard objectives add mirror_arrow_damage dummy
scoreboard objectives add mirror_skill_until dummy
scoreboard objectives add mirror_last_hitter dummy
scoreboard objectives add mirror_xy_streak dummy
scoreboard objectives add mirror_xy_total dummy
scoreboard objectives add mirror_uid dummy
scoreboard objectives add mirror_uid_next dummy
scoreboard objectives add mirror_xu_target dummy
scoreboard objectives add mirror_xu_streak dummy
scoreboard objectives add mirror_last_wslot dummy
scoreboard objectives add mirror_hit_total dummy
scoreboard objectives add mirror_last_hit dummy
scoreboard objectives add mirror_jinghen_until dummy
scoreboard objectives add mirror_zhaoxi_until dummy
scoreboard objectives add wp_max dummy
scoreboard objectives add mirror_calc dummy
scoreboard objectives add wp_added dummy
scoreboard objectives add wp_cap dummy
scoreboard objectives add wp_full dummy
scoreboard objectives add wp_rr_n dummy
scoreboard objectives add mirror_wtmp dummy
scoreboard objectives add mirror_wtmp2 dummy
scoreboard objectives add mirror_wtmp3 dummy
scoreboard objectives add mirror_wtmp4 dummy
scoreboard objectives add mirror_wtmp5 dummy
scoreboard objectives add mirror_wtmp6 dummy
scoreboard objectives add mirror_wtmp7 dummy
scoreboard objectives add mirror_wtmp8 dummy
scoreboard objectives add mirror_wtmp9 dummy
scoreboard objectives add mirror_wtmp10 dummy
scoreboard objectives add mirror_wtmp11 dummy
scoreboard objectives add mirror_wtmp12 dummy

# ---- FX / 镜统固定小特效（deferred 补齐）----
# 受伤前最近一次生命快照（5t 更新，×100）+ 快照时间戳（game_time）。
# 折光/照心只能用它近似本次伤害量；时间戳用于拒绝过期快照（卸下镜武期间的掉血不算一次伤害）。
scoreboard objectives add mirror_hp_last dummy
scoreboard objectives add mirror_hp_last_t dummy
# 目标身上的「同一玩家连续命中」归属与层数（镜熟/镜痕按玩家计数，不再用全局 mirror_xy_total）
scoreboard objectives add mirror_xy_owner dummy
# 镜痕：目标身上的留痕到期时间 + 归属玩家（+5% 只对留痕者生效）
scoreboard objectives add mirror_jinghen_owner dummy
# 照隙：目标发光到期时间 / 归属 / 「下一次受伤 +5%」待结算标记
scoreboard objectives add mirror_zhaoxi_owner dummy
scoreboard objectives add mirror_zhaoxi_ready dummy
# 双影：下一次幻影攻击的可用时间（game_time，8s = 160t）
scoreboard objectives add mirror_fx_shuang_ying_cd dummy
# 素锋：「武器技增益已激活」的持久窗口（ctx/skill 写入，5t 在实 buff 期间续期）
scoreboard objectives add mirror_skill_buff_until dummy
# 借影：命中时留下的目标增益快照（Id）与有效期；击杀时消费
scoreboard objectives add mirror_jieying_id dummy
scoreboard objectives add mirror_jieying_until dummy
# 双生（镜统）：已处理的 mirror_furnace_cast 计数，避免 5t 轮询重复触发
scoreboard objectives add mirror_base_shuang_seen dummy

# 战斗上下文临时值统一用 #wp 假玩家；12 个 mirror_wtmp 足够覆盖背照/镜径计算。
# scoreboard players operation 的源必须是 <holder> <objective>，不能写数字字面量；常量放 mirror_calc。
scoreboard players set #const2 mirror_calc 2
scoreboard players set #const3 mirror_calc 3
scoreboard players set #const4 mirror_calc 4
scoreboard players set #const5 mirror_calc 5
scoreboard players set #const20 mirror_calc 20
scoreboard players set #const25 mirror_calc 25
scoreboard players set #const30 mirror_calc 30
scoreboard players set #const6 mirror_calc 6
scoreboard players set #const10 mirror_calc 10
scoreboard players set #const100 mirror_calc 100
scoreboard players set #const1000 mirror_calc 1000

# 镜径轮转与目标 uid 的全局初值（未置 0 时第一次采样/第一次命中会被跳过）
scoreboard players set #sys mirror_trail_next 0
# uid 计数器不能在 /reload 时归零，否则新目标会与旧目标的 uid 冲突；只在未设置时初始化。
execute unless score #sys mirror_uid_next matches -2147483648.. run scoreboard players set #sys mirror_uid_next 0
