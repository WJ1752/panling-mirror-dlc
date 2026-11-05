# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 五纹 max 常量（设计文档 §6）。常规 actual×10 = max*val/10；jing_xi 的特例见 parse/apply。

# ---- DMG ----
scoreboard players set #max_dmg_po_xiao wp_max 15
scoreboard players set #max_dmg_xu_ying wp_max 4
scoreboard players set #max_dmg_ni_lin wp_max 12
scoreboard players set #max_dmg_jing_xi wp_max 0
scoreboard players set #max_dmg_zhui_ying wp_max 12
scoreboard players set #max_dmg_lian_xing wp_max 20
scoreboard players set #max_dmg_bei_zhao wp_max 15
scoreboard players set #max_dmg_yu_xiang wp_max 10
scoreboard players set #max_dmg_ying_ren wp_max 12
scoreboard players set #max_dmg_su_feng wp_max 12
scoreboard players set #max_dmg_shuang_zhao wp_max 15
scoreboard players set #max_dmg_jing_shu wp_max 12

# ---- SKL ----
scoreboard players set #max_skl_ying_xin wp_max 25
scoreboard players set #max_skl_chi_jing wp_max 15
scoreboard players set #max_skl_fen_ying_ji wp_max 25
scoreboard players set #max_skl_fen_ying_shi wp_max 15
scoreboard players set #max_skl_ming_jing_zao wp_max 3
scoreboard players set #max_skl_jing_xin_su wp_max 50
scoreboard players set #max_skl_lie_shen wp_max 25
scoreboard players set #max_skl_ying_zhong wp_max 12
scoreboard players set #max_skl_ying_chi wp_max 5
scoreboard players set #max_skl_lie_xu wp_max 20
scoreboard players set #max_skl_chong_ying_xu wp_max 60
scoreboard players set #max_skl_ying_sui_zhi wp_max 8
scoreboard players set #max_skl_jing_hua_tan wp_max 40
scoreboard players set #max_skl_jing_hua_bao wp_max 8
scoreboard players set #max_skl_shui_yue_kuan wp_max 20
scoreboard players set #max_skl_shui_yue_jiu wp_max 50
scoreboard players set #max_skl_hua_ying_su wp_max 50
scoreboard players set #max_skl_ying_shui_qiang wp_max 15
scoreboard players set #max_skl_liu_ying_jiu wp_max 40
scoreboard players set #max_skl_liu_ying_su wp_max 25
scoreboard players set #max_skl_ying_sui_duo wp_max 40
scoreboard players set #max_skl_ying_sui_qiang wp_max 8
scoreboard players set #max_skl_lian_ying_yi wp_max 50
scoreboard players set #max_skl_chong_ying_chuan wp_max 20
scoreboard players set #max_skl_dao_ying_qiang wp_max 15
scoreboard players set #max_skl_dao_ying_kuai wp_max 30
scoreboard players set #max_skl_jing_xia_jiu wp_max 120
scoreboard players set #max_skl_gong_ming_shang wp_max 50
scoreboard players set #max_skl_gong_ming_xiao wp_max 15
scoreboard players set #max_skl_shuang_sheng_qi wp_max 12
scoreboard players set #max_skl_ta_yin_cheng wp_max 15
scoreboard players set #max_skl_ta_pian_shang wp_max 30
scoreboard players set #max_skl_ta_pian_qiang wp_max 15
scoreboard players set #max_skl_xian_ying_jiu wp_max 30
scoreboard players set #max_skl_zhao_yao_shen wp_max 80
scoreboard players set #max_skl_he_yin_sheng wp_max 40

# ---- FX ----
scoreboard players set #max_fx_jing_hen wp_max 5
scoreboard players set #max_fx_zhe_guang wp_max 15
scoreboard players set #max_fx_jie_ying wp_max 10
scoreboard players set #max_fx_zhao_xi wp_max 15
scoreboard players set #max_fx_shi_ying wp_max 20
scoreboard players set #max_fx_jing_xi wp_max 5
scoreboard players set #max_fx_fan_zhao wp_max 20
scoreboard players set #max_fx_shuang_ying wp_max 10
scoreboard players set #max_fx_ying_sheng wp_max 15
scoreboard players set #max_fx_jing_jing wp_max 8
