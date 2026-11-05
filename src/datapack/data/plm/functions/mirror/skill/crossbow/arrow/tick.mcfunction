# 技能箭 1t 直接结算循环（弩机 / 影随齐射 / 残影补箭）
# 只处理带 tag 的技能箭，不扫全服；没有箭时不自我调度。
execute as @e[type=arrow,tag=mirror_turret_arrow] at @s run function plm:mirror/skill/crossbow/arrow/hit_check
execute as @e[type=arrow,tag=mirror_yingsui_arrow] at @s run function plm:mirror/skill/crossbow/arrow/hit_check
execute as @e[type=arrow,tag=mirror_can_arrow] at @s run function plm:mirror/skill/crossbow/arrow/hit_check

# 落地/超时清理（真实箭 damage=0，只做视觉）
execute as @e[type=arrow,tag=mirror_turret_arrow] if data entity @s {inGround:1b} run kill @s
execute as @e[type=arrow,tag=mirror_yingsui_arrow] if data entity @s {inGround:1b} run kill @s
execute as @e[type=arrow,tag=mirror_can_arrow] if data entity @s {inGround:1b} run kill @s
execute as @e[type=arrow,tag=mirror_turret_arrow,nbt={Age:60..}] run kill @s
execute as @e[type=arrow,tag=mirror_yingsui_arrow,nbt={Age:60..}] run kill @s
execute as @e[type=arrow,tag=mirror_can_arrow,nbt={Age:60..}] run kill @s

# 还有箭就继续 1t 后处理；全部消失即停
execute if entity @e[type=arrow,tag=mirror_turret_arrow] run schedule function plm:mirror/skill/crossbow/arrow/tick 1t replace
execute if entity @e[type=arrow,tag=mirror_yingsui_arrow] run schedule function plm:mirror/skill/crossbow/arrow/tick 1t replace
execute if entity @e[type=arrow,tag=mirror_can_arrow] run schedule function plm:mirror/skill/crossbow/arrow/tick 1t replace
