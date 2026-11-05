# 分影起手：身后 2 格召唤 10s 倒影；快照攻击与 SKL 参数
# 冷却 150 ×5t，按 weapon_skill_cool_reduce 缩减（设计 §1.2）
scoreboard players set #cd mirror_skill_tmp 150
function plm:mirror/skill/reduce_cool
scoreboard players operation @s mirror_cd_b = #cd mirror_skill_tmp

scoreboard players set #skill mirror_skill_perfect 0
execute if score @s mirror_mingjing matches 1.. run scoreboard players set #skill mirror_skill_perfect 1
execute if score @s mirror_mingjing matches 1.. run scoreboard players set @s mirror_mingjing 0

# 分影上限 1：重放/跨维度施放时先清掉自己的旧倒影（三个维度都扫）
scoreboard players operation #shadow_owner mirror_skill_tmp = @s player_uid
execute in minecraft:overworld run function plm:mirror/skill/shadow/clear_owned
execute in minecraft:the_nether run function plm:mirror/skill/shadow/clear_owned
execute in minecraft:the_end run function plm:mirror/skill/shadow/clear_owned

execute at @s run summon minecraft:armor_stand ^ ^ ^-2 {Tags:["mirror_shadow","mirror_shadow_new"],Invisible:1b,NoBasePlate:1b,ShowArms:1b,Invulnerable:1b,NoAI:1b,Silent:1b,NoGravity:1b,HandItems:[{id:"minecraft:iron_sword",Count:1b,tag:{CustomModelData:1}},{}]}
execute at @s run tp @e[tag=mirror_shadow_new,limit=1] ^ ^ ^-2 ~ ~
scoreboard players operation @e[tag=mirror_shadow_new,limit=1] mirror_shadow_owner = @s player_uid
scoreboard players set @e[tag=mirror_shadow_new,limit=1] mirror_shadow_5ticks 40
scoreboard players operation @e[tag=mirror_shadow_new,limit=1] mirror_shadow_atk = @s attack_damage1
# 记录召唤维度，owner 匹配只限同维度
scoreboard players set @e[tag=mirror_shadow_new,limit=1] mirror_shadow_dim 0
execute if dimension minecraft:the_nether run scoreboard players set @e[tag=mirror_shadow_new,limit=1] mirror_shadow_dim 1
execute if dimension minecraft:the_end run scoreboard players set @e[tag=mirror_shadow_new,limit=1] mirror_shadow_dim 2

# 伤害比例 60 + 分影·实/10（0..15）
scoreboard players set #skill mirror_skill_tmp 60
scoreboard players set #skill mirror_skill_tmp2 0
scoreboard players operation #skill mirror_skill_tmp2 = @s wp_affix_skl_fen_ying_shi
scoreboard players operation #skill mirror_skill_tmp2 /= #const10 mirror_calc
scoreboard players operation #skill mirror_skill_tmp += #skill mirror_skill_tmp2
# 明镜：本次 +50%
scoreboard players operation #skill mirror_skill_tmp2 = #skill mirror_skill_tmp
execute if score #skill mirror_skill_perfect matches 1.. run scoreboard players operation #skill mirror_skill_tmp2 /= #const2 mirror_calc
execute if score #skill mirror_skill_perfect matches 1.. run scoreboard players operation #skill mirror_skill_tmp += #skill mirror_skill_tmp2
scoreboard players operation @e[tag=mirror_shadow_new,limit=1] mirror_shadow_ratio = #skill mirror_skill_tmp

# 攻击间隔：基础 6 个 5t，分影·疾每 100 点 -1 个 5t（低值保持原曲线），最低 4 个 5t。
# 满值 250 → 6-2=4；落在 4 档时由 attack 按攻击计数奇偶在 4/5 间交替，
# 平均 4.5×5t = 1.125s（设计 §2.1.2），不再固定 1.0s。
scoreboard players set #skill mirror_skill_tmp3 6
scoreboard players set #skill mirror_skill_tmp2 0
scoreboard players operation #skill mirror_skill_tmp2 = @s wp_affix_skl_fen_ying_ji
scoreboard players operation #skill mirror_skill_tmp2 /= #const100 mirror_calc
scoreboard players operation #skill mirror_skill_tmp3 -= #skill mirror_skill_tmp2
execute if score #skill mirror_skill_tmp3 matches ..4 run scoreboard players set #skill mirror_skill_tmp3 4
scoreboard players operation @e[tag=mirror_shadow_new,limit=1] mirror_shadow_interval = #skill mirror_skill_tmp3
scoreboard players operation @e[tag=mirror_shadow_new,limit=1] mirror_shadow_atk_timer = #skill mirror_skill_tmp3
# 攻击计数：4 档时 attack 用奇偶决定下一次 4 或 5 个 5t
scoreboard players set @e[tag=mirror_shadow_new,limit=1] mirror_shadow_hits 0
# 跟随间隔 8 个 5t = 2s
scoreboard players set @e[tag=mirror_shadow_new,limit=1] mirror_shadow_move_timer 8
tag @e[tag=mirror_shadow_new] remove mirror_shadow_new

# 武器技成功钩子：必须调防具入口，只调 tag 不会触发 2/4 件套
scoreboard players set @s skill_success 1
function pld:equipment_lock/equipment/armor/set_bonus/when_weapon_skill_enable
scoreboard players set @s skill_success 0
# 施法锁 10t（0.5s）：入口 1.. 直接丢弃，不扣冷却
scoreboard players set @s mirror_cast_lock 10

execute at @s run particle minecraft:end_rod ~ ~1 ~ 0.6 0.8 0.6 0.03 24
execute at @s run playsound minecraft:block.amethyst_block.chime master @a ~ ~ ~ 1 0.9
