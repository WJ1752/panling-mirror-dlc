# 开发/测试：把四件照心护甲真实写进护甲槽，并把 mirror_degree 设为 5。
# 用法：execute as <玩家> run function plm:dev/equip_degree5_true
# 1.20.1 不能 /data modify entity <玩家>，所以经同 tick 临时 armor_stand 复制→改 NBT→写回。
# 写入后读真实槽位分数并跑真实 #pld:equipment_lock/armor/set_check，再判真影律。

function plm:dev/equip_test_set

kill @e[tag=mirror_degree_helper]
execute at @s run summon minecraft:armor_stand ~ ~ ~ {Tags:["mirror_degree_helper"],Invisible:1b,Marker:1b,NoGravity:1b}

# 头（ArmorItems[3]）
item replace entity @e[tag=mirror_degree_helper,limit=1] armor.head from entity @s armor.head
data modify entity @e[tag=mirror_degree_helper,limit=1] ArmorItems[3].tag.mirror_degree set value 5
item replace entity @s armor.head from entity @e[tag=mirror_degree_helper,limit=1] armor.head
# 胸（ArmorItems[2]）
item replace entity @e[tag=mirror_degree_helper,limit=1] armor.chest from entity @s armor.chest
data modify entity @e[tag=mirror_degree_helper,limit=1] ArmorItems[2].tag.mirror_degree set value 5
item replace entity @s armor.chest from entity @e[tag=mirror_degree_helper,limit=1] armor.chest
# 腿（ArmorItems[1]）
item replace entity @e[tag=mirror_degree_helper,limit=1] armor.legs from entity @s armor.legs
data modify entity @e[tag=mirror_degree_helper,limit=1] ArmorItems[1].tag.mirror_degree set value 5
item replace entity @s armor.legs from entity @e[tag=mirror_degree_helper,limit=1] armor.legs
# 脚（ArmorItems[0]）
item replace entity @e[tag=mirror_degree_helper,limit=1] armor.feet from entity @s armor.feet
data modify entity @e[tag=mirror_degree_helper,limit=1] ArmorItems[0].tag.mirror_degree set value 5
item replace entity @s armor.feet from entity @e[tag=mirror_degree_helper,limit=1] armor.feet

kill @e[tag=mirror_degree_helper]

# 读真实护甲槽 → armor_set_bonus_id_* → 真实 set_check → DLC 套装计数
function plm:dev/armor_scores
function plm:mirror/set/zhao/max
function plm:dev/true_law_snapshot
