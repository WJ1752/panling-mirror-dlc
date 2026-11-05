# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 输入：storage plm:weapon item（完整物品 compound，含 tag）
# 输出：@s 的 wp_* / wp_affix_* / mirror_form / mirror_temper / mirror_set / mirror_parse_ok
function plm:weapon/parse/clear
execute unless data storage plm:weapon item.tag{mirror:1} run return 0
execute unless data storage plm:weapon item.tag{mirror_ver:2} run return 0

execute store result score @s wp_temper run data get storage plm:weapon item.tag.mirror_temper
execute store result score @s wp_set run data get storage plm:weapon item.tag.mirror_set
scoreboard players operation @s mirror_temper = @s wp_temper
scoreboard players operation @s mirror_set = @s wp_set
function plm:weapon/parse/form

# ---- 条数 ----
execute if data storage plm:weapon item.tag.mirror_dmg[0] run scoreboard players add @s wp_dmg_n 1
execute if data storage plm:weapon item.tag.mirror_dmg[1] run scoreboard players add @s wp_dmg_n 1
execute if data storage plm:weapon item.tag.mirror_dmg[2] run scoreboard players add @s wp_dmg_n 1
execute if data storage plm:weapon item.tag.mirror_skl[0] run scoreboard players add @s wp_skl_n 1
execute if data storage plm:weapon item.tag.mirror_skl[1] run scoreboard players add @s wp_skl_n 1
execute if data storage plm:weapon item.tag.mirror_skl[2] run scoreboard players add @s wp_skl_n 1
execute if data storage plm:weapon item.tag.mirror_fx[0] run scoreboard players add @s wp_fx_n 1

# ---- 原始 val（50..100，用于 lore/身份）----
execute if data storage plm:weapon item.tag.mirror_dmg[0] store result score @s wp_dmg0 run data get storage plm:weapon item.tag.mirror_dmg[0].val
execute if data storage plm:weapon item.tag.mirror_dmg[1] store result score @s wp_dmg1 run data get storage plm:weapon item.tag.mirror_dmg[1].val
execute if data storage plm:weapon item.tag.mirror_dmg[2] store result score @s wp_dmg2 run data get storage plm:weapon item.tag.mirror_dmg[2].val
execute if data storage plm:weapon item.tag.mirror_skl[0] store result score @s wp_skl0 run data get storage plm:weapon item.tag.mirror_skl[0].val
execute if data storage plm:weapon item.tag.mirror_skl[1] store result score @s wp_skl1 run data get storage plm:weapon item.tag.mirror_skl[1].val
execute if data storage plm:weapon item.tag.mirror_skl[2] store result score @s wp_skl2 run data get storage plm:weapon item.tag.mirror_skl[2].val
execute if data storage plm:weapon item.tag.mirror_fx[0] store result score @s wp_fx0 run data get storage plm:weapon item.tag.mirror_fx[0].val

# ---- 58 条：存在则写 val，再转 actual×10 ----
# DMG
execute if data storage plm:weapon item.tag.mirror_dmg[{id:"po_xiao"}] store result score @s wp_affix_dmg_po_xiao run data get storage plm:weapon item.tag.mirror_dmg[{id:"po_xiao"}].val
execute if score @s wp_affix_dmg_po_xiao matches 1.. run scoreboard players operation @s wp_affix_dmg_po_xiao *= #max_dmg_po_xiao wp_max
execute if score @s wp_affix_dmg_po_xiao matches 1.. run scoreboard players operation @s wp_affix_dmg_po_xiao /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_dmg[{id:"xu_ying"}] store result score @s wp_affix_dmg_xu_ying run data get storage plm:weapon item.tag.mirror_dmg[{id:"xu_ying"}].val
execute if score @s wp_affix_dmg_xu_ying matches 1.. run scoreboard players operation @s wp_affix_dmg_xu_ying *= #max_dmg_xu_ying wp_max
execute if score @s wp_affix_dmg_xu_ying matches 1.. run scoreboard players operation @s wp_affix_dmg_xu_ying /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_dmg[{id:"ni_lin"}] store result score @s wp_affix_dmg_ni_lin run data get storage plm:weapon item.tag.mirror_dmg[{id:"ni_lin"}].val
execute if score @s wp_affix_dmg_ni_lin matches 1.. run scoreboard players operation @s wp_affix_dmg_ni_lin *= #max_dmg_ni_lin wp_max
execute if score @s wp_affix_dmg_ni_lin matches 1.. run scoreboard players operation @s wp_affix_dmg_ni_lin /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_dmg[{id:"jing_xi"}] store result score @s wp_affix_dmg_jing_xi run data get storage plm:weapon item.tag.mirror_dmg[{id:"jing_xi"}].val
execute if score @s wp_affix_dmg_jing_xi matches 1.. run scoreboard players operation @s wp_affix_dmg_jing_xi *= #max_dmg_jing_xi wp_max
execute if score @s wp_affix_dmg_jing_xi matches 1.. run scoreboard players operation @s wp_affix_dmg_jing_xi /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_dmg[{id:"zhui_ying"}] store result score @s wp_affix_dmg_zhui_ying run data get storage plm:weapon item.tag.mirror_dmg[{id:"zhui_ying"}].val
execute if score @s wp_affix_dmg_zhui_ying matches 1.. run scoreboard players operation @s wp_affix_dmg_zhui_ying *= #max_dmg_zhui_ying wp_max
execute if score @s wp_affix_dmg_zhui_ying matches 1.. run scoreboard players operation @s wp_affix_dmg_zhui_ying /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_dmg[{id:"lian_xing"}] store result score @s wp_affix_dmg_lian_xing run data get storage plm:weapon item.tag.mirror_dmg[{id:"lian_xing"}].val
execute if score @s wp_affix_dmg_lian_xing matches 1.. run scoreboard players operation @s wp_affix_dmg_lian_xing *= #max_dmg_lian_xing wp_max
execute if score @s wp_affix_dmg_lian_xing matches 1.. run scoreboard players operation @s wp_affix_dmg_lian_xing /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_dmg[{id:"bei_zhao"}] store result score @s wp_affix_dmg_bei_zhao run data get storage plm:weapon item.tag.mirror_dmg[{id:"bei_zhao"}].val
execute if score @s wp_affix_dmg_bei_zhao matches 1.. run scoreboard players operation @s wp_affix_dmg_bei_zhao *= #max_dmg_bei_zhao wp_max
execute if score @s wp_affix_dmg_bei_zhao matches 1.. run scoreboard players operation @s wp_affix_dmg_bei_zhao /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_dmg[{id:"yu_xiang"}] store result score @s wp_affix_dmg_yu_xiang run data get storage plm:weapon item.tag.mirror_dmg[{id:"yu_xiang"}].val
execute if score @s wp_affix_dmg_yu_xiang matches 1.. run scoreboard players operation @s wp_affix_dmg_yu_xiang *= #max_dmg_yu_xiang wp_max
execute if score @s wp_affix_dmg_yu_xiang matches 1.. run scoreboard players operation @s wp_affix_dmg_yu_xiang /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_dmg[{id:"ying_ren"}] store result score @s wp_affix_dmg_ying_ren run data get storage plm:weapon item.tag.mirror_dmg[{id:"ying_ren"}].val
execute if score @s wp_affix_dmg_ying_ren matches 1.. run scoreboard players operation @s wp_affix_dmg_ying_ren *= #max_dmg_ying_ren wp_max
execute if score @s wp_affix_dmg_ying_ren matches 1.. run scoreboard players operation @s wp_affix_dmg_ying_ren /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_dmg[{id:"su_feng"}] store result score @s wp_affix_dmg_su_feng run data get storage plm:weapon item.tag.mirror_dmg[{id:"su_feng"}].val
execute if score @s wp_affix_dmg_su_feng matches 1.. run scoreboard players operation @s wp_affix_dmg_su_feng *= #max_dmg_su_feng wp_max
execute if score @s wp_affix_dmg_su_feng matches 1.. run scoreboard players operation @s wp_affix_dmg_su_feng /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_dmg[{id:"shuang_zhao"}] store result score @s wp_affix_dmg_shuang_zhao run data get storage plm:weapon item.tag.mirror_dmg[{id:"shuang_zhao"}].val
execute if score @s wp_affix_dmg_shuang_zhao matches 1.. run scoreboard players operation @s wp_affix_dmg_shuang_zhao *= #max_dmg_shuang_zhao wp_max
execute if score @s wp_affix_dmg_shuang_zhao matches 1.. run scoreboard players operation @s wp_affix_dmg_shuang_zhao /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_dmg[{id:"jing_shu"}] store result score @s wp_affix_dmg_jing_shu run data get storage plm:weapon item.tag.mirror_dmg[{id:"jing_shu"}].val
execute if score @s wp_affix_dmg_jing_shu matches 1.. run scoreboard players operation @s wp_affix_dmg_jing_shu *= #max_dmg_jing_shu wp_max
execute if score @s wp_affix_dmg_jing_shu matches 1.. run scoreboard players operation @s wp_affix_dmg_jing_shu /= #const10 mirror_calc

# SKL
execute if data storage plm:weapon item.tag.mirror_skl[{id:"ying_xin"}] store result score @s wp_affix_skl_ying_xin run data get storage plm:weapon item.tag.mirror_skl[{id:"ying_xin"}].val
execute if score @s wp_affix_skl_ying_xin matches 1.. run scoreboard players operation @s wp_affix_skl_ying_xin *= #max_skl_ying_xin wp_max
execute if score @s wp_affix_skl_ying_xin matches 1.. run scoreboard players operation @s wp_affix_skl_ying_xin /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"chi_jing"}] store result score @s wp_affix_skl_chi_jing run data get storage plm:weapon item.tag.mirror_skl[{id:"chi_jing"}].val
execute if score @s wp_affix_skl_chi_jing matches 1.. run scoreboard players operation @s wp_affix_skl_chi_jing *= #max_skl_chi_jing wp_max
execute if score @s wp_affix_skl_chi_jing matches 1.. run scoreboard players operation @s wp_affix_skl_chi_jing /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"fen_ying_ji"}] store result score @s wp_affix_skl_fen_ying_ji run data get storage plm:weapon item.tag.mirror_skl[{id:"fen_ying_ji"}].val
execute if score @s wp_affix_skl_fen_ying_ji matches 1.. run scoreboard players operation @s wp_affix_skl_fen_ying_ji *= #max_skl_fen_ying_ji wp_max
execute if score @s wp_affix_skl_fen_ying_ji matches 1.. run scoreboard players operation @s wp_affix_skl_fen_ying_ji /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"fen_ying_shi"}] store result score @s wp_affix_skl_fen_ying_shi run data get storage plm:weapon item.tag.mirror_skl[{id:"fen_ying_shi"}].val
execute if score @s wp_affix_skl_fen_ying_shi matches 1.. run scoreboard players operation @s wp_affix_skl_fen_ying_shi *= #max_skl_fen_ying_shi wp_max
execute if score @s wp_affix_skl_fen_ying_shi matches 1.. run scoreboard players operation @s wp_affix_skl_fen_ying_shi /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"ming_jing_zao"}] store result score @s wp_affix_skl_ming_jing_zao run data get storage plm:weapon item.tag.mirror_skl[{id:"ming_jing_zao"}].val
execute if score @s wp_affix_skl_ming_jing_zao matches 1.. run scoreboard players operation @s wp_affix_skl_ming_jing_zao *= #max_skl_ming_jing_zao wp_max
execute if score @s wp_affix_skl_ming_jing_zao matches 1.. run scoreboard players operation @s wp_affix_skl_ming_jing_zao /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"jing_xin_su"}] store result score @s wp_affix_skl_jing_xin_su run data get storage plm:weapon item.tag.mirror_skl[{id:"jing_xin_su"}].val
execute if score @s wp_affix_skl_jing_xin_su matches 1.. run scoreboard players operation @s wp_affix_skl_jing_xin_su *= #max_skl_jing_xin_su wp_max
execute if score @s wp_affix_skl_jing_xin_su matches 1.. run scoreboard players operation @s wp_affix_skl_jing_xin_su /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"lie_shen"}] store result score @s wp_affix_skl_lie_shen run data get storage plm:weapon item.tag.mirror_skl[{id:"lie_shen"}].val
execute if score @s wp_affix_skl_lie_shen matches 1.. run scoreboard players operation @s wp_affix_skl_lie_shen *= #max_skl_lie_shen wp_max
execute if score @s wp_affix_skl_lie_shen matches 1.. run scoreboard players operation @s wp_affix_skl_lie_shen /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"ying_zhong"}] store result score @s wp_affix_skl_ying_zhong run data get storage plm:weapon item.tag.mirror_skl[{id:"ying_zhong"}].val
execute if score @s wp_affix_skl_ying_zhong matches 1.. run scoreboard players operation @s wp_affix_skl_ying_zhong *= #max_skl_ying_zhong wp_max
execute if score @s wp_affix_skl_ying_zhong matches 1.. run scoreboard players operation @s wp_affix_skl_ying_zhong /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"ying_chi"}] store result score @s wp_affix_skl_ying_chi run data get storage plm:weapon item.tag.mirror_skl[{id:"ying_chi"}].val
execute if score @s wp_affix_skl_ying_chi matches 1.. run scoreboard players operation @s wp_affix_skl_ying_chi *= #max_skl_ying_chi wp_max
execute if score @s wp_affix_skl_ying_chi matches 1.. run scoreboard players operation @s wp_affix_skl_ying_chi /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"lie_xu"}] store result score @s wp_affix_skl_lie_xu run data get storage plm:weapon item.tag.mirror_skl[{id:"lie_xu"}].val
execute if score @s wp_affix_skl_lie_xu matches 1.. run scoreboard players operation @s wp_affix_skl_lie_xu *= #max_skl_lie_xu wp_max
execute if score @s wp_affix_skl_lie_xu matches 1.. run scoreboard players operation @s wp_affix_skl_lie_xu /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"chong_ying_xu"}] store result score @s wp_affix_skl_chong_ying_xu run data get storage plm:weapon item.tag.mirror_skl[{id:"chong_ying_xu"}].val
execute if score @s wp_affix_skl_chong_ying_xu matches 1.. run scoreboard players operation @s wp_affix_skl_chong_ying_xu *= #max_skl_chong_ying_xu wp_max
execute if score @s wp_affix_skl_chong_ying_xu matches 1.. run scoreboard players operation @s wp_affix_skl_chong_ying_xu /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"ying_sui_zhi"}] store result score @s wp_affix_skl_ying_sui_zhi run data get storage plm:weapon item.tag.mirror_skl[{id:"ying_sui_zhi"}].val
execute if score @s wp_affix_skl_ying_sui_zhi matches 1.. run scoreboard players operation @s wp_affix_skl_ying_sui_zhi *= #max_skl_ying_sui_zhi wp_max
execute if score @s wp_affix_skl_ying_sui_zhi matches 1.. run scoreboard players operation @s wp_affix_skl_ying_sui_zhi /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"jing_hua_tan"}] store result score @s wp_affix_skl_jing_hua_tan run data get storage plm:weapon item.tag.mirror_skl[{id:"jing_hua_tan"}].val
execute if score @s wp_affix_skl_jing_hua_tan matches 1.. run scoreboard players operation @s wp_affix_skl_jing_hua_tan *= #max_skl_jing_hua_tan wp_max
execute if score @s wp_affix_skl_jing_hua_tan matches 1.. run scoreboard players operation @s wp_affix_skl_jing_hua_tan /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"jing_hua_bao"}] store result score @s wp_affix_skl_jing_hua_bao run data get storage plm:weapon item.tag.mirror_skl[{id:"jing_hua_bao"}].val
execute if score @s wp_affix_skl_jing_hua_bao matches 1.. run scoreboard players operation @s wp_affix_skl_jing_hua_bao *= #max_skl_jing_hua_bao wp_max
execute if score @s wp_affix_skl_jing_hua_bao matches 1.. run scoreboard players operation @s wp_affix_skl_jing_hua_bao /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"shui_yue_kuan"}] store result score @s wp_affix_skl_shui_yue_kuan run data get storage plm:weapon item.tag.mirror_skl[{id:"shui_yue_kuan"}].val
execute if score @s wp_affix_skl_shui_yue_kuan matches 1.. run scoreboard players operation @s wp_affix_skl_shui_yue_kuan *= #max_skl_shui_yue_kuan wp_max
execute if score @s wp_affix_skl_shui_yue_kuan matches 1.. run scoreboard players operation @s wp_affix_skl_shui_yue_kuan /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"shui_yue_jiu"}] store result score @s wp_affix_skl_shui_yue_jiu run data get storage plm:weapon item.tag.mirror_skl[{id:"shui_yue_jiu"}].val
execute if score @s wp_affix_skl_shui_yue_jiu matches 1.. run scoreboard players operation @s wp_affix_skl_shui_yue_jiu *= #max_skl_shui_yue_jiu wp_max
execute if score @s wp_affix_skl_shui_yue_jiu matches 1.. run scoreboard players operation @s wp_affix_skl_shui_yue_jiu /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"hua_ying_su"}] store result score @s wp_affix_skl_hua_ying_su run data get storage plm:weapon item.tag.mirror_skl[{id:"hua_ying_su"}].val
execute if score @s wp_affix_skl_hua_ying_su matches 1.. run scoreboard players operation @s wp_affix_skl_hua_ying_su *= #max_skl_hua_ying_su wp_max
execute if score @s wp_affix_skl_hua_ying_su matches 1.. run scoreboard players operation @s wp_affix_skl_hua_ying_su /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"ying_shui_qiang"}] store result score @s wp_affix_skl_ying_shui_qiang run data get storage plm:weapon item.tag.mirror_skl[{id:"ying_shui_qiang"}].val
execute if score @s wp_affix_skl_ying_shui_qiang matches 1.. run scoreboard players operation @s wp_affix_skl_ying_shui_qiang *= #max_skl_ying_shui_qiang wp_max
execute if score @s wp_affix_skl_ying_shui_qiang matches 1.. run scoreboard players operation @s wp_affix_skl_ying_shui_qiang /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"liu_ying_jiu"}] store result score @s wp_affix_skl_liu_ying_jiu run data get storage plm:weapon item.tag.mirror_skl[{id:"liu_ying_jiu"}].val
execute if score @s wp_affix_skl_liu_ying_jiu matches 1.. run scoreboard players operation @s wp_affix_skl_liu_ying_jiu *= #max_skl_liu_ying_jiu wp_max
execute if score @s wp_affix_skl_liu_ying_jiu matches 1.. run scoreboard players operation @s wp_affix_skl_liu_ying_jiu /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"liu_ying_su"}] store result score @s wp_affix_skl_liu_ying_su run data get storage plm:weapon item.tag.mirror_skl[{id:"liu_ying_su"}].val
execute if score @s wp_affix_skl_liu_ying_su matches 1.. run scoreboard players operation @s wp_affix_skl_liu_ying_su *= #max_skl_liu_ying_su wp_max
execute if score @s wp_affix_skl_liu_ying_su matches 1.. run scoreboard players operation @s wp_affix_skl_liu_ying_su /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"ying_sui_duo"}] store result score @s wp_affix_skl_ying_sui_duo run data get storage plm:weapon item.tag.mirror_skl[{id:"ying_sui_duo"}].val
execute if score @s wp_affix_skl_ying_sui_duo matches 1.. run scoreboard players operation @s wp_affix_skl_ying_sui_duo *= #max_skl_ying_sui_duo wp_max
execute if score @s wp_affix_skl_ying_sui_duo matches 1.. run scoreboard players operation @s wp_affix_skl_ying_sui_duo /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"ying_sui_qiang"}] store result score @s wp_affix_skl_ying_sui_qiang run data get storage plm:weapon item.tag.mirror_skl[{id:"ying_sui_qiang"}].val
execute if score @s wp_affix_skl_ying_sui_qiang matches 1.. run scoreboard players operation @s wp_affix_skl_ying_sui_qiang *= #max_skl_ying_sui_qiang wp_max
execute if score @s wp_affix_skl_ying_sui_qiang matches 1.. run scoreboard players operation @s wp_affix_skl_ying_sui_qiang /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"lian_ying_yi"}] store result score @s wp_affix_skl_lian_ying_yi run data get storage plm:weapon item.tag.mirror_skl[{id:"lian_ying_yi"}].val
execute if score @s wp_affix_skl_lian_ying_yi matches 1.. run scoreboard players operation @s wp_affix_skl_lian_ying_yi *= #max_skl_lian_ying_yi wp_max
execute if score @s wp_affix_skl_lian_ying_yi matches 1.. run scoreboard players operation @s wp_affix_skl_lian_ying_yi /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"chong_ying_chuan"}] store result score @s wp_affix_skl_chong_ying_chuan run data get storage plm:weapon item.tag.mirror_skl[{id:"chong_ying_chuan"}].val
execute if score @s wp_affix_skl_chong_ying_chuan matches 1.. run scoreboard players operation @s wp_affix_skl_chong_ying_chuan *= #max_skl_chong_ying_chuan wp_max
execute if score @s wp_affix_skl_chong_ying_chuan matches 1.. run scoreboard players operation @s wp_affix_skl_chong_ying_chuan /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"dao_ying_qiang"}] store result score @s wp_affix_skl_dao_ying_qiang run data get storage plm:weapon item.tag.mirror_skl[{id:"dao_ying_qiang"}].val
execute if score @s wp_affix_skl_dao_ying_qiang matches 1.. run scoreboard players operation @s wp_affix_skl_dao_ying_qiang *= #max_skl_dao_ying_qiang wp_max
execute if score @s wp_affix_skl_dao_ying_qiang matches 1.. run scoreboard players operation @s wp_affix_skl_dao_ying_qiang /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"dao_ying_kuai"}] store result score @s wp_affix_skl_dao_ying_kuai run data get storage plm:weapon item.tag.mirror_skl[{id:"dao_ying_kuai"}].val
execute if score @s wp_affix_skl_dao_ying_kuai matches 1.. run scoreboard players operation @s wp_affix_skl_dao_ying_kuai *= #max_skl_dao_ying_kuai wp_max
execute if score @s wp_affix_skl_dao_ying_kuai matches 1.. run scoreboard players operation @s wp_affix_skl_dao_ying_kuai /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"jing_xia_jiu"}] store result score @s wp_affix_skl_jing_xia_jiu run data get storage plm:weapon item.tag.mirror_skl[{id:"jing_xia_jiu"}].val
execute if score @s wp_affix_skl_jing_xia_jiu matches 1.. run scoreboard players operation @s wp_affix_skl_jing_xia_jiu *= #max_skl_jing_xia_jiu wp_max
execute if score @s wp_affix_skl_jing_xia_jiu matches 1.. run scoreboard players operation @s wp_affix_skl_jing_xia_jiu /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"gong_ming_shang"}] store result score @s wp_affix_skl_gong_ming_shang run data get storage plm:weapon item.tag.mirror_skl[{id:"gong_ming_shang"}].val
execute if score @s wp_affix_skl_gong_ming_shang matches 1.. run scoreboard players operation @s wp_affix_skl_gong_ming_shang *= #max_skl_gong_ming_shang wp_max
execute if score @s wp_affix_skl_gong_ming_shang matches 1.. run scoreboard players operation @s wp_affix_skl_gong_ming_shang /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"gong_ming_xiao"}] store result score @s wp_affix_skl_gong_ming_xiao run data get storage plm:weapon item.tag.mirror_skl[{id:"gong_ming_xiao"}].val
execute if score @s wp_affix_skl_gong_ming_xiao matches 1.. run scoreboard players operation @s wp_affix_skl_gong_ming_xiao *= #max_skl_gong_ming_xiao wp_max
execute if score @s wp_affix_skl_gong_ming_xiao matches 1.. run scoreboard players operation @s wp_affix_skl_gong_ming_xiao /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"shuang_sheng_qi"}] store result score @s wp_affix_skl_shuang_sheng_qi run data get storage plm:weapon item.tag.mirror_skl[{id:"shuang_sheng_qi"}].val
execute if score @s wp_affix_skl_shuang_sheng_qi matches 1.. run scoreboard players operation @s wp_affix_skl_shuang_sheng_qi *= #max_skl_shuang_sheng_qi wp_max
execute if score @s wp_affix_skl_shuang_sheng_qi matches 1.. run scoreboard players operation @s wp_affix_skl_shuang_sheng_qi /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"ta_yin_cheng"}] store result score @s wp_affix_skl_ta_yin_cheng run data get storage plm:weapon item.tag.mirror_skl[{id:"ta_yin_cheng"}].val
execute if score @s wp_affix_skl_ta_yin_cheng matches 1.. run scoreboard players operation @s wp_affix_skl_ta_yin_cheng *= #max_skl_ta_yin_cheng wp_max
execute if score @s wp_affix_skl_ta_yin_cheng matches 1.. run scoreboard players operation @s wp_affix_skl_ta_yin_cheng /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"ta_pian_shang"}] store result score @s wp_affix_skl_ta_pian_shang run data get storage plm:weapon item.tag.mirror_skl[{id:"ta_pian_shang"}].val
execute if score @s wp_affix_skl_ta_pian_shang matches 1.. run scoreboard players operation @s wp_affix_skl_ta_pian_shang *= #max_skl_ta_pian_shang wp_max
execute if score @s wp_affix_skl_ta_pian_shang matches 1.. run scoreboard players operation @s wp_affix_skl_ta_pian_shang /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"ta_pian_qiang"}] store result score @s wp_affix_skl_ta_pian_qiang run data get storage plm:weapon item.tag.mirror_skl[{id:"ta_pian_qiang"}].val
execute if score @s wp_affix_skl_ta_pian_qiang matches 1.. run scoreboard players operation @s wp_affix_skl_ta_pian_qiang *= #max_skl_ta_pian_qiang wp_max
execute if score @s wp_affix_skl_ta_pian_qiang matches 1.. run scoreboard players operation @s wp_affix_skl_ta_pian_qiang /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"xian_ying_jiu"}] store result score @s wp_affix_skl_xian_ying_jiu run data get storage plm:weapon item.tag.mirror_skl[{id:"xian_ying_jiu"}].val
execute if score @s wp_affix_skl_xian_ying_jiu matches 1.. run scoreboard players operation @s wp_affix_skl_xian_ying_jiu *= #max_skl_xian_ying_jiu wp_max
execute if score @s wp_affix_skl_xian_ying_jiu matches 1.. run scoreboard players operation @s wp_affix_skl_xian_ying_jiu /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"zhao_yao_shen"}] store result score @s wp_affix_skl_zhao_yao_shen run data get storage plm:weapon item.tag.mirror_skl[{id:"zhao_yao_shen"}].val
execute if score @s wp_affix_skl_zhao_yao_shen matches 1.. run scoreboard players operation @s wp_affix_skl_zhao_yao_shen *= #max_skl_zhao_yao_shen wp_max
execute if score @s wp_affix_skl_zhao_yao_shen matches 1.. run scoreboard players operation @s wp_affix_skl_zhao_yao_shen /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_skl[{id:"he_yin_sheng"}] store result score @s wp_affix_skl_he_yin_sheng run data get storage plm:weapon item.tag.mirror_skl[{id:"he_yin_sheng"}].val
execute if score @s wp_affix_skl_he_yin_sheng matches 1.. run scoreboard players operation @s wp_affix_skl_he_yin_sheng *= #max_skl_he_yin_sheng wp_max
execute if score @s wp_affix_skl_he_yin_sheng matches 1.. run scoreboard players operation @s wp_affix_skl_he_yin_sheng /= #const10 mirror_calc

# FX
execute if data storage plm:weapon item.tag.mirror_fx[{id:"jing_hen"}] store result score @s wp_affix_fx_jing_hen run data get storage plm:weapon item.tag.mirror_fx[{id:"jing_hen"}].val
execute if score @s wp_affix_fx_jing_hen matches 1.. run scoreboard players operation @s wp_affix_fx_jing_hen *= #max_fx_jing_hen wp_max
execute if score @s wp_affix_fx_jing_hen matches 1.. run scoreboard players operation @s wp_affix_fx_jing_hen /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_fx[{id:"zhe_guang"}] store result score @s wp_affix_fx_zhe_guang run data get storage plm:weapon item.tag.mirror_fx[{id:"zhe_guang"}].val
execute if score @s wp_affix_fx_zhe_guang matches 1.. run scoreboard players operation @s wp_affix_fx_zhe_guang *= #max_fx_zhe_guang wp_max
execute if score @s wp_affix_fx_zhe_guang matches 1.. run scoreboard players operation @s wp_affix_fx_zhe_guang /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_fx[{id:"jie_ying"}] store result score @s wp_affix_fx_jie_ying run data get storage plm:weapon item.tag.mirror_fx[{id:"jie_ying"}].val
execute if score @s wp_affix_fx_jie_ying matches 1.. run scoreboard players operation @s wp_affix_fx_jie_ying *= #max_fx_jie_ying wp_max
execute if score @s wp_affix_fx_jie_ying matches 1.. run scoreboard players operation @s wp_affix_fx_jie_ying /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_fx[{id:"zhao_xi"}] store result score @s wp_affix_fx_zhao_xi run data get storage plm:weapon item.tag.mirror_fx[{id:"zhao_xi"}].val
execute if score @s wp_affix_fx_zhao_xi matches 1.. run scoreboard players operation @s wp_affix_fx_zhao_xi *= #max_fx_zhao_xi wp_max
execute if score @s wp_affix_fx_zhao_xi matches 1.. run scoreboard players operation @s wp_affix_fx_zhao_xi /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_fx[{id:"shi_ying"}] store result score @s wp_affix_fx_shi_ying run data get storage plm:weapon item.tag.mirror_fx[{id:"shi_ying"}].val
execute if score @s wp_affix_fx_shi_ying matches 1.. run scoreboard players operation @s wp_affix_fx_shi_ying *= #max_fx_shi_ying wp_max
execute if score @s wp_affix_fx_shi_ying matches 1.. run scoreboard players operation @s wp_affix_fx_shi_ying /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_fx[{id:"jing_xi"}] store result score @s wp_affix_fx_jing_xi run data get storage plm:weapon item.tag.mirror_fx[{id:"jing_xi"}].val
execute if score @s wp_affix_fx_jing_xi matches 1.. run scoreboard players operation @s wp_affix_fx_jing_xi *= #max_fx_jing_xi wp_max
execute if score @s wp_affix_fx_jing_xi matches 1.. run scoreboard players operation @s wp_affix_fx_jing_xi /= #const100 mirror_calc
execute if data storage plm:weapon item.tag.mirror_fx[{id:"fan_zhao"}] store result score @s wp_affix_fx_fan_zhao run data get storage plm:weapon item.tag.mirror_fx[{id:"fan_zhao"}].val
execute if score @s wp_affix_fx_fan_zhao matches 1.. run scoreboard players operation @s wp_affix_fx_fan_zhao *= #max_fx_fan_zhao wp_max
execute if score @s wp_affix_fx_fan_zhao matches 1.. run scoreboard players operation @s wp_affix_fx_fan_zhao /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_fx[{id:"shuang_ying"}] store result score @s wp_affix_fx_shuang_ying run data get storage plm:weapon item.tag.mirror_fx[{id:"shuang_ying"}].val
execute if score @s wp_affix_fx_shuang_ying matches 1.. run scoreboard players operation @s wp_affix_fx_shuang_ying *= #max_fx_shuang_ying wp_max
execute if score @s wp_affix_fx_shuang_ying matches 1.. run scoreboard players operation @s wp_affix_fx_shuang_ying /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_fx[{id:"ying_sheng"}] store result score @s wp_affix_fx_ying_sheng run data get storage plm:weapon item.tag.mirror_fx[{id:"ying_sheng"}].val
execute if score @s wp_affix_fx_ying_sheng matches 1.. run scoreboard players operation @s wp_affix_fx_ying_sheng *= #max_fx_ying_sheng wp_max
execute if score @s wp_affix_fx_ying_sheng matches 1.. run scoreboard players operation @s wp_affix_fx_ying_sheng /= #const10 mirror_calc
execute if data storage plm:weapon item.tag.mirror_fx[{id:"jing_jing"}] store result score @s wp_affix_fx_jing_jing run data get storage plm:weapon item.tag.mirror_fx[{id:"jing_jing"}].val
execute if score @s wp_affix_fx_jing_jing matches 1.. run scoreboard players operation @s wp_affix_fx_jing_jing *= #max_fx_jing_jing wp_max
execute if score @s wp_affix_fx_jing_jing matches 1.. run scoreboard players operation @s wp_affix_fx_jing_jing /= #const10 mirror_calc

scoreboard players set @s mirror_parse_ok 1
tag @s add mirror_weapon_active

# 续影状态只在未设置时初始化；parse/apply 会被 refresh 反复调用，不能在这里清零。
execute unless score @s mirror_xu_streak matches -2147483648.. run scoreboard players set @s mirror_xu_streak 0
execute unless score @s mirror_xu_target matches -2147483648.. run scoreboard players set @s mirror_xu_target 0

# 记录本次解析对应的武器槽；tick/refresh 只在该槽变化时重解析（设计 §10.3 parse 只做一次）。
execute if score @s WeaponSlot matches -2147483648.. run scoreboard players operation @s mirror_last_wslot = @s WeaponSlot
