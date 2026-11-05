# 本文件由 .work/weapon-phase1/gen_phase1.py 生成；双生炉实现覆盖，请勿再手改后回跑生成器。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。

# SKL dao_ying_qiang（max 15）— 双生炉「倒映·强」
# 单位（契约 §5）：objective = 实际百分点 ×10；满值 150 = +15pp。
# 本文件不参与运行（Phase 1 没有 SKL 调用链）；技能函数直接读 @s wp_affix_skl_dao_ying_qiang：
#   - plm:mirror/skill/furnace/twin/echo/main_cast.mcfunction：倒映强度 200 + skl → 20%~35%
#   - plm:mirror/skill/furnace/twin/box_route.mcfunction：镜匣强度 500 + skl → 50%~65%
return 0
