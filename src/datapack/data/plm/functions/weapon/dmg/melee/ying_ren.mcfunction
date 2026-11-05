# 映刃（ying_ren）— 武器技伤害（近战侧）
# 近战技能（镜映反射 / 裂痕引爆）都直接写 #temp entity_hurt_temp 再调 plm:mirror/damage/armor，
# 不经过 attack_damage/multiply_base，因此本文件在近战普攻管线（ctx/melee）里没有可达条件。
# 实际结算统一在 plm:weapon/dmg/skill_hit（advancement plm:weapon/skill_hit），近战与弓弩共用。
# 保留本文件是为了保持 12 DMG 分支文件齐全与 ctx/melee 调用点稳定；不要再往这里加猜测逻辑。
return 0
