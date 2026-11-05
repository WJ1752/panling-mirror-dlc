# 碎镜伤害结算：@s=碎镜主人；目标已打 mirror_dmg_target。
# 若目标已有碎镜易伤，本次碎镜也吃到 +15%；新易伤由 shatter_victim 在伤害后挂。
execute if entity @a[tag=mirror_shatter_true,limit=1] run scoreboard players operation #temp entity_hurt_temp = #zhao_true mirror_calc
execute unless entity @a[tag=mirror_shatter_true,limit=1] run scoreboard players operation #temp entity_hurt_temp = #zhao_dmg mirror_calc
function plm:mirror/set/zhao/vuln
execute if entity @a[tag=mirror_shatter_true,limit=1] run function plm:mirror/damage/true
execute unless entity @a[tag=mirror_shatter_true,limit=1] run function plm:mirror/damage/armor
