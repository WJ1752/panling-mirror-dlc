# 镜花【镜花】起手（设计 §2.3.1）——潜行射箭，把刚射出的箭变成镜花箭。
# 入口：plm:mirror/input/archer（#pld:archer/when_shoot），at @s；@s=射手，tag=shooter 仍在，
#       箭已射出、本体 projectile_owner_uuid0..3 已写。
# 本函数只做：快照本次绽放参数 + 给箭打 mirror_bloom_arrow（按 owner uuid 匹配，不裸选）
#             + 冷却 / skill_success；箭照常飞出，命中由 advancement plm:mirror/bow/bloom_hit 接手。
#
# 词条单位（actual×10，CONTRACT §5）：
#   jing_hua_tan    max 40 → 400：绽放额外命中 1 个目标的概率，/10 → 0..40（1..100 随机 <= pct）
#   jing_hua_bao    max 8  → 80 ：绽放伤害 60% + 8pp，/10 → 60..68
#   shui_yue_kuan   max 20 → 200：绽放范围 +2 格，/100 → +0..2
#   shui_yue_jiu    max 50 → 500：花影持续 +5s，在 flower_add 里 /5 → +0..100 ticks
#   hua_ying_su     max 50 → 500：获得花影时额外 +1 层的概率，快照到 mirror_flower_extra，命中时 /10 → 0..50
#   ying_shui_qiang max 15 → 150：第 3 个绽放目标 100% + 15pp，/10 → 100..115

execute unless score @s job matches 1 run return 0
execute unless entity @s[tag=shooter] run return 0
execute unless entity @s[nbt={SelectedItem:{tag:{mirror:1,act:1,id:"panling:mirror_bow7"}}}] run return 0
# 所有主动共享施法锁（设计 §1.2）；锁内重复触发直接丢弃，不扣冷却。
execute if score @s mirror_cast_lock matches 1.. run return 0
# 免费箭可以绕过冷却（花影满时 flower_add 写 mirror_bloom_free=1；不再清共享 mirror_cd_a）
# 冷却中：显示剩余秒数后 return（不施放、不重置冷却）
execute if score @s mirror_cd_a matches 1.. unless score @s mirror_bloom_free matches 1 run scoreboard players operation #mirror_msg_cd mirror_msg = @s mirror_cd_a
execute if score @s mirror_cd_a matches 1.. unless score @s mirror_bloom_free matches 1 run function plm:mirror/msg/cooling
execute if score @s mirror_cd_a matches 1.. unless score @s mirror_bloom_free matches 1 run return 0

# ---- 花影到期：只在触发点清，不做全局 tick ----
# 用世界 gametime（1.20.1 time query gametime 可用）作为绝对时间；
# 共享的 #sys mirror_game_time 由 plm:tick/main 每 tick 更新，但这里保留 time query 以兼容旧数据。
execute store result score #bow_now mirror_calc run time query gametime
execute if score @s mirror_flower matches 1.. if score @s mirror_flower_until <= #bow_now mirror_calc run scoreboard players set @s mirror_flower 0
execute if score @s mirror_flower matches 0 run scoreboard players set @s mirror_bloom_free 0
# 2 件套：花影上限 5；否则基础 3（plm:mirror/set/jing_hua/max）。
function plm:mirror/set/jing_hua/max
execute if score @s mirror_flower > @s mirror_flower_max run scoreboard players operation @s mirror_flower = @s mirror_flower_max
# 满层即免费（不依赖 flag 是否被别的东西清过）
execute if score @s mirror_flower_max matches 1.. if score @s mirror_flower >= @s mirror_flower_max run scoreboard players set @s mirror_bloom_free 1

# ---- 满层免费：本次不写冷却，消耗当前全部层数（基础 3；2 件套上限 5） ----
scoreboard players set #bow_free mirror_calc 0
execute if score @s mirror_bloom_free matches 1 run scoreboard players set #bow_free mirror_calc 1
execute if score @s mirror_bloom_free matches 1 run scoreboard players set @s mirror_flower 0
execute if score @s mirror_bloom_free matches 1 run scoreboard players set @s mirror_bloom_free 0

# ---- 本次绽放快照 ----
# 范围 8 + 水月·宽/100（0..2）
scoreboard players set @s mirror_bloom_range 8
scoreboard players set #bow_tmp mirror_calc 0
scoreboard players operation #bow_tmp mirror_calc = @s wp_affix_skl_shui_yue_kuan
scoreboard players operation #bow_tmp mirror_calc /= #const100 mirror_calc
scoreboard players operation @s mirror_bloom_range += #bow_tmp mirror_calc
execute if score @s mirror_bloom_range matches 11.. run scoreboard players set @s mirror_bloom_range 10

# 第 3 个目标：100% + 映水·强/10（0..15）
scoreboard players set @s mirror_bloom_pct 100
scoreboard players set #bow_tmp mirror_calc 0
scoreboard players operation #bow_tmp mirror_calc = @s wp_affix_skl_ying_shui_qiang
scoreboard players operation #bow_tmp mirror_calc /= #const10 mirror_calc
scoreboard players operation @s mirror_bloom_pct += #bow_tmp mirror_calc

# 普通绽放：60% + 镜花·保/10（0..8）→ 存 mirror_bloom_target（逐箭快照，见 tag_arrow）
scoreboard players set @s mirror_bloom_target 60
scoreboard players set #bow_tmp mirror_calc 0
scoreboard players operation #bow_tmp mirror_calc = @s wp_affix_skl_jing_hua_bao
scoreboard players operation #bow_tmp mirror_calc /= #const10 mirror_calc
scoreboard players operation @s mirror_bloom_target += #bow_tmp mirror_calc

# 目标数：基础 2；花影满 +1 个高强度槽（2 件套上限 5 时是第 4 槽，否则第 3 槽）；
# 镜花·弹再 +1（普通 60% 槽）。mirror_bloom_extra 存“高强度槽序号”（0/3/4），不再是布尔。
scoreboard players set @s mirror_bloom_count 2
scoreboard players set @s mirror_bloom_extra 0
execute if score #bow_free mirror_calc matches 1 run scoreboard players add @s mirror_bloom_count 1
execute if score #bow_free mirror_calc matches 1 run scoreboard players set @s mirror_bloom_extra 3
execute if score #bow_free mirror_calc matches 1 if score @s mirror_flower_max matches 5 run scoreboard players set @s mirror_bloom_extra 4
execute if score #bow_free mirror_calc matches 1 if score @s mirror_flower_max matches 5 run scoreboard players add @s mirror_bloom_count 1

# 镜花·弹：1..100 随机 <= 概率%（词条为 0 时不掷）
scoreboard players set #bow_tmp mirror_calc 0
scoreboard players operation #bow_tmp mirror_calc = @s wp_affix_skl_jing_hua_tan
scoreboard players operation #bow_tmp mirror_calc /= #const10 mirror_calc
execute if score #bow_tmp mirror_calc matches 1.. run function plm:weapon/util/rand100
execute if score #bow_tmp mirror_calc matches 1.. if score #t wp_rand matches 1.. if score #t wp_rand <= #bow_tmp mirror_calc run scoreboard players add @s mirror_bloom_count 1

# 真影律：绽放目标数无上限（resolve 走 slot_true 分支，8/9/10 格内所有敌人）
# 4 件防具映度 5 才算；武器不能替代。mirror_true_law 在起手点即时重算。
function plm:mirror/set/jing_hua/true_law
execute if score @s mirror_true_law matches 1 run scoreboard players set @s mirror_bloom_count 99

# 花影·速：命中时按快照概率额外 +1 层（见 flower_add）
scoreboard players set @s mirror_flower_extra 0
scoreboard players operation @s mirror_flower_extra = @s wp_affix_skl_hua_ying_su

# ---- 给刚射出的箭打标：按箭自身的 Owner UUID 匹配，不再依赖 5 格距离 ----
# 本体 set_shooter 也用 distance=..5 写 projectile_owner_uuid0..3；全蓄力箭在 when_shoot
# 回调时可能已飞出 5 格，那些分数根本不会写。所以这里直接读箭的 Owner NBT（原版玩家
# 射出的箭必写），在 32 格内按 owner 匹配；tag=!mirror_bloom_arrow 跳过已打标的老箭。
# 同一 owner 同时有多支在飞箭时，只取离射手最近的一支，避免给旧箭补打标。
scoreboard players operation #bow_uid0 mirror_calc = @s player_uuid0
scoreboard players operation #bow_uid1 mirror_calc = @s player_uuid1
scoreboard players operation #bow_uid2 mirror_calc = @s player_uuid2
scoreboard players operation #bow_uid3 mirror_calc = @s player_uuid3
tag @e[tag=mirror_bloom_new] remove mirror_bloom_new
tag @e[tag=mirror_bloom_pick] remove mirror_bloom_pick
execute at @s as @e[type=arrow,nbt={OnGround:0b},distance=..32,tag=!mirror_bloom_arrow] run function plm:mirror/skill/bow/owner_match
tag @e[tag=mirror_bloom_new,sort=nearest,limit=1] add mirror_bloom_pick
tag @e[tag=mirror_bloom_new] remove mirror_bloom_new
execute as @e[tag=mirror_bloom_pick] run function plm:mirror/skill/bow/tag_arrow
tag @e[tag=mirror_bloom_pick] remove mirror_bloom_pick

# ---- 冷却 15s = 60 个 5t；免费箭不写；按 weapon_skill_cool_reduce 缩减 ----
execute if score #bow_free mirror_calc matches 0 run scoreboard players set #cd mirror_skill_tmp 60
execute if score #bow_free mirror_calc matches 0 run function plm:mirror/skill/reduce_cool
execute if score #bow_free mirror_calc matches 0 run scoreboard players operation @s mirror_cd_a = #cd mirror_skill_tmp
# 施法锁：免费箭也写，防止同一 tick 连发绕过冷却。
scoreboard players set @s mirror_cast_lock 10

# ---- 施放成功钩子 ----
# 本体 weapon_check 走的是 pld:equipment_lock/equipment/armor/set_bonus/when_weapon_skill_enable
# （该函数末尾再调 #pld:equipment_lock/when_weapon_skill_enable，DLC 的 ctx/skill 也在那个 tag 里）。
# 只调 tag 不会触发防具 2/4 件套；这里按本体同一入口调用，保证镜武技能与本体武器技一致。
scoreboard players set @s skill_success 1
function pld:equipment_lock/equipment/armor/set_bonus/when_weapon_skill_enable
scoreboard players set @s skill_success 0

execute at @s run particle minecraft:dust 0.45 0.9 1 1 ~ ~1 ~ 0.45 0.55 0.45 0.02 18
execute at @s run playsound minecraft:block.amethyst_block.chime master @a ~ ~ ~ 0.6 1.8
