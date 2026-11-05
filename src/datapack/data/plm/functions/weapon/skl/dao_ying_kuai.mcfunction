# 本文件由 .work/weapon-phase1/gen_phase1.py 生成；双生炉实现覆盖，请勿再手改后回跑生成器。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。

# SKL dao_ying_kuai（max 30）— 双生炉「倒映·快」
# 单位（契约 §5）：objective = 实际值 ×10；满值 300 = 3.0s 冷却缩减（10s → 7s）。
# 本文件不参与运行；消费点：
#   - plm:mirror/skill/furnace/twin/echo/main_cast.mcfunction：
#     mirror_cd_int = 40 − wp_affix_skl_dao_ying_kuai/25（个 5t 单位，下限 28 = 7s）
#   - 真影律（4 件防具映度全 5）：main_cast 在本计算后强制写 28（7s），覆盖词条结果
return 0
