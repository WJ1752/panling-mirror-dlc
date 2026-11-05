# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 20t 一次：吸收“DLC 加入前就已激活/ghost tag 丢失”的镜武，避免必须重新换装。
execute as @a[tag=!mirror_weapon_active] if data entity @s SelectedItem.tag{mirror:1,act:1} run function plm:weapon/parse_hand
