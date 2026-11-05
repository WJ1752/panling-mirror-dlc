# SKL he_yin_sheng（放印·省，max 40 → parse 后满值 400 = 40.0%）
# 消费点：plm:mirror/skill/furnace/rub/release_route.mcfunction
#   roll 0..99，`#rub mirror_rub_cd < wp_affix_skl_he_yin_sheng/10` → @s mirror_rub_free=1，本次不消耗印
# 单位：百分比×10，所以 /10（400 → 40%）；触发时仍然进 15s 冷却
# 真影律（4 件防具映度全 5）另有 120s 免耗：优先写 mirror_rub_free=1 + mirror_rub_true_cd=480（480 个 5t = 120s），
# 并在 actionbar 显示「真影律」而不是「合印·生」
return 0
