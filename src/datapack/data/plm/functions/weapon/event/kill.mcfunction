# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# DLC 自建 player_killed_entity 进度 reward。@s=击杀玩家；reward 里拿不到死者，故只做玩家侧计时/掉落。
advancement revoke @s only plm:weapon/kill
# 余响只看「玩家击杀后 3s」，与击杀时手里拿什么无关：先记时间戳，再决定是否触发拾影。
scoreboard players operation @s mirror_last_kill = #sys mirror_game_time
execute unless data entity @s SelectedItem.tag{mirror:1} run return 0
execute if entity @s[tag=mirror_weapon_active] run function plm:weapon/fx/shi_ying
# 借影：击杀时消费命中快照，复制目标 1 个正面增益 3s（降级口径见 fx/jie_ying）
execute if score @s wp_affix_fx_jie_ying matches 1.. run function plm:weapon/fx/jie_ying
# 拓印（镜统 5：击杀 5% 概率使 3 格内敌人显影 1s）
execute if score @s wp_set matches 5 run function plm:weapon/base/base_ta_yin
