# 镜映起手：3s 架势（12 个 5t 单位），完美窗口 0.5s（10 tick，逐 tick 递减）
# 冷却 100 ×5t，按 weapon_skill_cool_reduce 缩减（设计 §1.2）
scoreboard players set #cd mirror_skill_tmp 100
function plm:mirror/skill/reduce_cool
scoreboard players operation @s mirror_cd_a = #cd mirror_skill_tmp

scoreboard players set @s mirror_parry 12
# 完美窗口单位改为 tick：基础 10t = 0.5s；递减在 plm:tick/main 逐 tick 做
scoreboard players set @s mirror_parry_perfect 10
scoreboard players set @s mirror_parry_done 0
scoreboard players set @s mirror_parry_mingjing 0
execute store result score @s mirror_parry_hp run data get entity @s Health 100

# 明镜：本次无冷却 + 效果 +50%（反射比例/持续/完美窗口 ×1.5），然后消耗
# 反射比例的 ×1.5 由 hurt 读 mirror_parry_mingjing 实现（mirror_mingjing 在这里就清掉了）。
execute if score @s mirror_mingjing matches 1.. run scoreboard players set @s mirror_parry_mingjing 1
execute if score @s mirror_mingjing matches 1.. run scoreboard players operation @s mirror_parry *= #const3 mirror_calc
execute if score @s mirror_mingjing matches 1.. run scoreboard players operation @s mirror_parry /= #const2 mirror_calc
execute if score @s mirror_mingjing matches 1.. run scoreboard players operation @s mirror_parry_perfect *= #const3 mirror_calc
execute if score @s mirror_mingjing matches 1.. run scoreboard players operation @s mirror_parry_perfect /= #const2 mirror_calc
execute if score @s mirror_mingjing matches 1.. run scoreboard players set @s mirror_mingjing 0
# SKL 持镜 +1.5s（/25 个 5t）、明镜·早 +0.3s（满值 30 → +6 tick，线性 ×2/10）
scoreboard players set #skill mirror_skill_tmp 0
scoreboard players operation #skill mirror_skill_tmp = @s wp_affix_skl_chi_jing
scoreboard players operation #skill mirror_skill_tmp /= #const25 mirror_calc
scoreboard players operation @s mirror_parry += #skill mirror_skill_tmp
scoreboard players set #skill mirror_skill_tmp 0
scoreboard players operation #skill mirror_skill_tmp = @s wp_affix_skl_ming_jing_zao
scoreboard players operation #skill mirror_skill_tmp *= #const2 mirror_calc
scoreboard players operation #skill mirror_skill_tmp /= #const10 mirror_calc
scoreboard players operation @s mirror_parry_perfect += #skill mirror_skill_tmp

# 武器技成功钩子（防具 2/4 件套）
scoreboard players set @s skill_success 1
function pld:equipment_lock/equipment/armor/set_bonus/when_weapon_skill_enable
scoreboard players set @s skill_success 0
# 施法锁 10t（0.5s）：入口 1.. 直接丢弃，不扣冷却
scoreboard players set @s mirror_cast_lock 10

execute at @s run particle minecraft:end_rod ~ ~1 ~ 0.5 0.7 0.5 0.02 24
execute at @s run playsound minecraft:block.amethyst_block.chime master @a ~ ~ ~ 1 1.2
