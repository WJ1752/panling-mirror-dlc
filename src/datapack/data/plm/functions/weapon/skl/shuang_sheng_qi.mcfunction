# 本文件由 .work/weapon-phase1/gen_phase1.py 生成；双生炉实现覆盖，请勿再手改后回跑生成器。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。

# SKL shuang_sheng_qi（max 12）— 双生炉「双生·契」
# 单位（契约 §5）：objective = 实际百分点 ×10；满值 120 = +12%。
# 本文件不参与运行；消费点：
#   - plm:mirror/skill/furnace/twin/echo/hit.mcfunction：
#     双阵同中（mirror_resonance_mark 且 1s 窗口内）时，倍率×10 直接加 120
return 0
