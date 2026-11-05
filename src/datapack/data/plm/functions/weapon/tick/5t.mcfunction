# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。
#
# 审查备注（#75）：原第 5/7 行（现第 15/17 行）的两处语义变更属于 alpha.41 的已知热修，不是本轮新增。
#   - 第 15 行 jing_jing 增加 `at @s`：修复 alpha.29/alpha.40 中 marker 落在世界原点、
#     不跟随玩家的问题（.work/weapon-phase1/DELIVERY.md:281、:333 R1）。
#   - 第 17 行 trail 改为 `execute if entity @a[tag=mirror_weapon_active]` 条件调用：
#     无人持镜武时不再每 5t 扫三个维度。
#   证据：dist/panling-mirror-1.0.0-alpha.40.zip 的 weapon/tick/5t 仍是
#   `execute as @a[...] run function .../jing_jing` + 无条件 `function .../trail/tick`；
#   dist/panling-mirror-1.0.0-alpha.41.zip 已包含上述两处改动。
#   本轮只补注释，不改这两行逻辑，也不新增 form tick 调用。

execute as @a[tag=mirror_weapon_active] at @s run function plm:weapon/fx/jing_jing
execute as @a[tag=mirror_skill_active] if score @s mirror_skill_until <= #sys mirror_game_time run tag @s remove mirror_skill_active
execute if entity @a[tag=mirror_weapon_active] run function plm:weapon/trail/tick

# 生命快照（×100）+ 快照时间：折光/照心的伤害量只能用「快照 − 当前 Health」近似，
# 快照过期（>10t，例如卸下镜武期间）时 estimate 会拒绝估值，而不是把空窗伤害算进来。
execute as @a[tag=mirror_weapon_active] store result score @s mirror_hp_last run data get entity @s Health 100
execute as @a[tag=mirror_weapon_active] run scoreboard players operation @s mirror_hp_last_t = #sys mirror_game_time
# 素锋：「武器技增益已激活」窗口在实 buff 期间续期（ctx/skill 只覆盖施放瞬间）。
execute as @a[tag=mirror_weapon_active] run function plm:weapon/tick/skill_buff/check
# 双生（镜统 4）：5t 轮询 mirror_furnace_cast，每次成功主阵最多判定一次
execute as @a[tag=mirror_weapon_active] run function plm:weapon/base/base_shuang_sheng
