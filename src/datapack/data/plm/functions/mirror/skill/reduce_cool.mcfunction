# 镜武冷却缩减（设计 §1.2）
# 输入：@s = 玩家；#cd mirror_skill_tmp = 冷却（5t 单位）
# 输出：#cd mirror_skill_tmp 已按 weapon_skill_cool_reduce（0..50 百分点）缩减
# 本体每 5t 重算 weapon_skill_cool_reduce；DLC 只读不写。
scoreboard players set #mirror_red mirror_skill_tmp2 100
scoreboard players operation #mirror_red mirror_skill_tmp2 -= @s weapon_skill_cool_reduce
# 防御：外部把缩减写成负数/超过 100 时夹到 0..100（正常本体不会）
execute if score #mirror_red mirror_skill_tmp2 matches ..0 run scoreboard players set #mirror_red mirror_skill_tmp2 0
execute if score #mirror_red mirror_skill_tmp2 matches 101.. run scoreboard players set #mirror_red mirror_skill_tmp2 100
scoreboard players operation #cd mirror_skill_tmp *= #mirror_red mirror_skill_tmp2
scoreboard players operation #cd mirror_skill_tmp /= #const100 mirror_calc
