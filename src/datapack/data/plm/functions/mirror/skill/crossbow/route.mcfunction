# 残影弩【影随】入口：潜行射箭（#pld:archer/when_shoot -> plm:mirror/input/archer -> 本函数）
# 上下文：@s=射手，箭已射出；这一箭仍正常飞出，本函数只开冷却 + 记录 5s 路径。
# 设计 §2.4.2：冷 150×5t=37.5s；每 10t 记 1 点（最多 10 点）；5s 后每 2 格取点齐射。
execute unless score @s job matches 1 run return 0
execute unless entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_crossbow7"}}}] run return 0
# 施法锁：0.5s 内重复触发直接丢弃，不扣冷却（设计 §1.6）
execute if score @s mirror_cast_lock matches 1.. run return 0
# 冷却中：显示剩余秒数后 return（不施放、不重置冷却）
execute if score @s mirror_cd_a matches 1.. run scoreboard players operation #mirror_msg_cd mirror_msg = @s mirror_cd_a
execute if score @s mirror_cd_a matches 1.. run function plm:mirror/msg/cooling
execute if score @s mirror_cd_a matches 1.. run return 0

# 冷却 150，走共享 reduce_cool（CONTRACT §3；不写本体 weapon_skill_cool_5ticks）
scoreboard players set #cd mirror_skill_tmp 150
function plm:mirror/skill/reduce_cool
scoreboard players operation @s mirror_cd_a = #cd mirror_skill_tmp
# 记录本次施放冷却，换武器取消时按 50% 返还
scoreboard players operation @s mirror_yingsui_5ticks = @s mirror_cd_a

# 施法成功（CONTRACT §3）；必须调防具入口，只调 tag 不会触发 2/4 件套
scoreboard players set @s skill_success 1
function pld:equipment_lock/equipment/armor/set_bonus/when_weapon_skill_enable
scoreboard players set @s skill_success 0
scoreboard players set @s mirror_cast_lock 10

# 路径记录状态：每玩家 10 个点存在自己的记分板槽位（不再用全服 storage 列表）
tag @s add mirror_yingsui_rec
scoreboard players set @s mirror_path_t 100
scoreboard players set @s mirror_path_n 0
scoreboard players set @s mirror_path_i 0
scoreboard players operation @s mirror_yingsui_i = @s mirror_death
# 记录施放维度；换维度（advancement）会 clear，这里再做一层防御
scoreboard players set @s mirror_path_dim 0
execute if dimension minecraft:the_nether run scoreboard players set @s mirror_path_dim 1
execute if dimension minecraft:the_end run scoreboard players set @s mirror_path_dim 2

# 视觉 / 音效
execute at @s run playsound minecraft:item.crossbow.loading_middle master @a ~ ~ ~ 0.8 1.2
execute at @s run particle minecraft:dust 0.55 0.25 0.95 1.0 ~ ~1 ~ 0.4 0.8 0.4 0 12
