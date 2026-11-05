# 本文件由 .work/weapon-phase1/gen_phase1.py 生成；双生炉实现覆盖，请勿再手改后回跑生成器。
# 武器五纹 Phase 1：激活 parse + 战斗上下文 + DMG/FX/BASE 小特效。

# SKL gong_ming_shang（max 50）— 双生炉「共鸣·上」
# 单位（契约 §5）：objective = 实际百分点 ×10；满值 500 = 50%。
# 本文件不参与运行；消费点：
#   - plm:mirror/skill/furnace/twin/echo/damage.mcfunction：
#     chance_percent = wp_affix_skl_gong_ming_shang/10；rand100 <= chance 时置 #tw_shang=1，
#     由 resonance/stack.mcfunction 额外 +1 层（每个倒影阵只判定一次）
#   - plm:mirror/set/twin/stack_main.mcfunction：2 件套主阵命中叠共鸣时用同一概率额外 +1 层
return 0
