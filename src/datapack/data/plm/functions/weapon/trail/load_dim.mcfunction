# 本文件由 .work/weapon-phase1/gen_phase1.py 生成，请勿手改。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。
# SKL 全部 deferred（六把武器技未编码）。

# 6 个专用 marker（env 里已有的 plm_trail_* 先清掉；distance 限定在本维度）
kill @e[type=minecraft:marker,tag=plm_trail,distance=..30000000]
summon minecraft:marker ~ ~ ~ {Tags:["plm_trail","plm_trail_0"]}
summon minecraft:marker ~ ~ ~ {Tags:["plm_trail","plm_trail_1"]}
summon minecraft:marker ~ ~ ~ {Tags:["plm_trail","plm_trail_2"]}
summon minecraft:marker ~ ~ ~ {Tags:["plm_trail","plm_trail_3"]}
summon minecraft:marker ~ ~ ~ {Tags:["plm_trail","plm_trail_4"]}
summon minecraft:marker ~ ~ ~ {Tags:["plm_trail","plm_trail_5"]}
