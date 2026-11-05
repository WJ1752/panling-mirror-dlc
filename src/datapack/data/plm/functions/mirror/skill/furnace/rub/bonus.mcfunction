# 印的二次结算：调用方已经加过基础印（击杀 +1 / rubbable +2 / 本体阵法 +1）
# 这里只结算拓印·固（额外 +1 印概率）、上限（3）与 actionbar
# @s = 玩家
function plm:mirror/skill/furnace/rub/roll
# 拓印·固 ta_yin_cheng：wp_affix_skl_ta_yin_cheng 满 150 = 15%（/10）
# 先清零：词条未设置时 operation 的源分数不存在，不能拿上一次的 #rub 值。
scoreboard players set #rub mirror_rub_extra 0
scoreboard players operation #rub mirror_rub_extra = @s wp_affix_skl_ta_yin_cheng
scoreboard players operation #rub mirror_rub_extra /= #const10 mirror_calc
execute if score #rub mirror_rub_cd < #rub mirror_rub_extra run scoreboard players add @s mirror_rub_stack 1
function plm:mirror/skill/furnace/rub/clamp
