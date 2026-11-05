# 本文件由 .work/weapon-phase1/gen_phase1.py 生成；双生炉实现覆盖，请勿再手改后回跑生成器。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。

# SKL jing_xia_jiu（max 120）— 双生炉「镜匣·速」
# 单位（契约 §5）：objective = 实际值 ×10；满值 1200 = 12.0s（按完成度 −6~−12s）。
# 本文件不参与运行；消费点：
#   - plm:mirror/skill/furnace/twin/box_route.mcfunction：
#     reduction = wp_affix_skl_jing_xia_jiu/25（个 5t 单位；词条 val 50 → objective 600 → 24=6s，
#      val 100 → objective 1200 → 48=12s；没有词条时 objective 0 → 不缩减）
#     mirror_cd_a = 120 − reduction（120=30s；下限 72 = 18s）
#   - 真影律（4 件防具映度全 5）：box_route 强制 mirror_cd_a = 84（21s），
#     并跳过 reduce_cool；此时本词条不参与镜匣冷却
return 0
