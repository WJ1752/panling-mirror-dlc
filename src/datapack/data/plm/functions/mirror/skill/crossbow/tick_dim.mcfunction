# 残影弩玩家侧 5t（#mirror_dim = 0/1/2）
# 只处理玩家侧；`as @a at @s if dimension <dim>` 保证每个玩家只匹配一个维度。
# 弩机/弩机箭在 crossbow/tick 里全局只跑一次（`execute in` 在 schedule 源下不限制 @e）。
# 1) 留影：装填完成 Charged 0→1 检测（需要正确的执行维度来 summon 弩机）
execute if score #mirror_dim mirror_calc matches 0 as @a at @s if dimension minecraft:overworld run function plm:mirror/skill/crossbow/liuying/poll
execute if score #mirror_dim mirror_calc matches 1 as @a at @s if dimension minecraft:the_nether run function plm:mirror/skill/crossbow/liuying/poll
execute if score #mirror_dim mirror_calc matches 2 as @a at @s if dimension minecraft:the_end run function plm:mirror/skill/crossbow/liuying/poll
# 2) Multishot 清理（保留 Quick Charge II；需要正确的执行维度来临时 armor_stand）
execute if score #mirror_dim mirror_calc matches 0 as @a at @s if dimension minecraft:overworld run function plm:mirror/skill/crossbow/liuying/strip_multishot
execute if score #mirror_dim mirror_calc matches 1 as @a at @s if dimension minecraft:the_nether run function plm:mirror/skill/crossbow/liuying/strip_multishot
execute if score #mirror_dim mirror_calc matches 2 as @a at @s if dimension minecraft:the_end run function plm:mirror/skill/crossbow/liuying/strip_multishot
# 3) 影随：路径记录 / 5s 到期齐射（fire 会在玩家所在维度 summon 箭）
execute if score #mirror_dim mirror_calc matches 0 as @a[tag=mirror_yingsui_rec] at @s if dimension minecraft:overworld run function plm:mirror/skill/crossbow/yingsui/tick
execute if score #mirror_dim mirror_calc matches 1 as @a[tag=mirror_yingsui_rec] at @s if dimension minecraft:the_nether run function plm:mirror/skill/crossbow/yingsui/tick
execute if score #mirror_dim mirror_calc matches 2 as @a[tag=mirror_yingsui_rec] at @s if dimension minecraft:the_end run function plm:mirror/skill/crossbow/yingsui/tick
