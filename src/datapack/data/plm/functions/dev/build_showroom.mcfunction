# 镜中倒影 · 测试展厅（P1 验收用）
# 层级说明：地面方块 y=-61，玩家站立 y=-60
# 用法：/function plm:dev/build_showroom
forceload add 0 0 31 31
gamerule doDaylightCycle false
time set 6000

# 地面（y=-61），外圈立柱
fill -8 -61 -8 24 -61 20 minecraft:smooth_quartz
fill -8 -60 -8 24 -60 -8 minecraft:quartz_pillar
fill -8 -60 20 24 -60 20 minecraft:quartz_pillar
fill -8 -60 -8 -8 -60 20 minecraft:quartz_pillar
fill 24 -60 -8 24 -60 20 minecraft:quartz_pillar
setworldspawn 2 -60 12

# ── 磨镜台 ──
# 投掷器：地面上一层（y=-60），玩家右键它
setblock 2 -60 8 minecraft:dropper{Facing:0b}
# 压力板：地面 y=-61，玩家踩上去
setblock 2 -61 7 minecraft:stone_pressure_plate
# 命令方块：埋在地面下 y=-62，由压力板触发
setblock 2 -62 7 minecraft:command_block{auto:0b,Command:"function plm:mirror/table/trigger"}
# 说明牌
setblock 2 -60 9 minecraft:oak_sign{front_text:{messages:['{"text":"磨镜台"}','{"text":"右键上方投掷器放材料"}','{"text":"踩地面压力板执行"}','{"text":"结果在中排右格"}']}}

# ── 材料箱 ──
setblock 2 -60 11 minecraft:chest{Items:[{Slot:0b,id:"minecraft:flint",Count:1b,tag:{id:"panling:mirror_mold_sword",CustomModelData:370}},{Slot:1b,id:"minecraft:flint",Count:1b,tag:{id:"panling:mirror_mold_axe",CustomModelData:371}},{Slot:2b,id:"minecraft:charcoal",Count:1b,tag:{id:"panling:mirror_mold_helmet",CustomModelData:376}},{Slot:3b,id:"minecraft:charcoal",Count:1b,tag:{id:"panling:mirror_mold_chestplate",CustomModelData:377}}]}
setblock 2 -60 12 minecraft:oak_sign{front_text:{messages:['{"text":"镜胚箱"}','{"text":"剑/斧/盔/甲"}','{"text":"其余 P2 补"}','{"text":""}']}}

tellraw @a {"text":"[镜中倒影] 展厅就绪：投掷器(2,-60,8) 压力板(2,-61,7) 材料箱(2,-60,11)","color":"aqua"}
