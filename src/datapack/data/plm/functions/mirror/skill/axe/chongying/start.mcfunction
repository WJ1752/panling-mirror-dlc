# 重影起手：15s + 重影·续；影伤比例/延迟带 SKL
# 词条单位（全部 actual×10）：
#   chong_ying_xu max 60 → 600；持续 5t 单位 = 600/25 = 24（+6s），基础 60 = 15s
#   ying_zhong    max 12 → 120；ratio 单位 90=9%，120/4 = 30（+3pp → 12%）
#   ying_chi      max 5  → 50；延迟 5t 单位 = 50/25 = 2（−0.5s），基础 6 = 1.5s
# 冷却 150 ×5t，按 weapon_skill_cool_reduce 缩减（设计 §1.2；统一走 mirror_cd_a）
scoreboard players set #cd mirror_skill_tmp 150
function plm:mirror/skill/reduce_cool
scoreboard players operation @s mirror_cd_a = #cd mirror_skill_tmp

scoreboard players set @s mirror_chongying_5ticks 60
scoreboard players set @s mirror_axe_ratio 90
# 基础延迟 6 个 5t = 1.5s（marker 的 due 每 5t 减 1）
scoreboard players set @s mirror_axe_delay 6

# 重影·续：wp_affix_skl_chong_ying_xu（actual×10）/25 → 5t 单位
scoreboard players set #skill mirror_skill_tmp 0
scoreboard players operation #skill mirror_skill_tmp = @s wp_affix_skl_chong_ying_xu
scoreboard players operation #skill mirror_skill_tmp /= #const25 mirror_calc
scoreboard players operation @s mirror_chongying_5ticks += #skill mirror_skill_tmp

# 影重：wp_affix_skl_ying_zhong（actual×10）/4 → ratio 百分点（90=9%）
scoreboard players set #skill mirror_skill_tmp 0
scoreboard players operation #skill mirror_skill_tmp = @s wp_affix_skl_ying_zhong
scoreboard players operation #skill mirror_skill_tmp /= #const4 mirror_calc
scoreboard players operation @s mirror_axe_ratio += #skill mirror_skill_tmp

# 影迟：wp_affix_skl_ying_chi（actual×10）/25 → 5t 单位（6=1.5s，最大 −2=1.0s）
scoreboard players set #skill mirror_skill_tmp 0
scoreboard players operation #skill mirror_skill_tmp = @s wp_affix_skl_ying_chi
scoreboard players operation #skill mirror_skill_tmp /= #const25 mirror_calc
scoreboard players operation @s mirror_axe_delay -= #skill mirror_skill_tmp
execute if score @s mirror_axe_delay matches ..4 run scoreboard players set @s mirror_axe_delay 4

# 武器技成功钩子（防具 2/4 件套）
scoreboard players set @s skill_success 1
function pld:equipment_lock/equipment/armor/set_bonus/when_weapon_skill_enable
scoreboard players set @s skill_success 0
# 施法锁 10t（0.5s）：入口 1.. 直接丢弃，不扣冷却
scoreboard players set @s mirror_cast_lock 10

execute at @s run particle minecraft:dust 0.8 0.1 0.1 1 ~ ~1 ~ 0.6 0.7 0.6 0.02 20
execute at @s run playsound minecraft:item.axe.scrape master @a ~ ~ ~ 1 1.1
