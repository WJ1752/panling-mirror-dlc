# 放印命中单个目标后的显形与次要效果（@s = 被命中的实体）
# 通用：显形 3s（#rub mirror_rub_free = 3 + 显影·久/100 秒）
execute if score #rub mirror_rub_free matches 3 run effect give @s minecraft:glowing 3 0 true
execute if score #rub mirror_rub_free matches 4 run effect give @s minecraft:glowing 4 0 true
execute if score #rub mirror_rub_free matches 5 run effect give @s minecraft:glowing 5 0 true
execute if score #rub mirror_rub_free matches 6.. run effect give @s minecraft:glowing 6 0 true
execute at @s run particle minecraft:dust 1 0.85 0.3 0.9 ~ ~1 ~ 0.35 0.35 0.35 0.02 8

# 次要效果只对 tag=monster；Boss 按设计只吃伤害/显形，不吃定身/击退
execute unless entity @s[tag=monster] run return 0
execute if entity @s[tag=mirror_boss] run return 0
# 类型 1 亡灵：定身 1.5s（30t）。/effect 只能整秒，而 1.20.1 的 /data modify entity
# 会把 ActiveEffects 里 -1b(=255) 的 Amplifier 归一成 0b（实测：写 Duration 或写回
# Amplifier 都会在实体 NBT 重读时被 clamp 回 0），所以不能「给 1s 再改 Duration」。
# 改为 1s 立即施加 + 10t 后由 slow_extend 再补 1s：总时长 30t，两次都保持 255。
execute if score #rub mirror_rub_type matches 1 run effect give @s minecraft:slowness 1 255 true
execute if score #rub mirror_rub_type matches 1 run tag @s add rub_slow_undead
execute if score #rub mirror_rub_type matches 1 run schedule function plm:mirror/skill/furnace/rub/release/slow_extend 10t replace
# 类型 2 远程：灼烧 3s（Fire 单位 tick，60 = 3s）
execute if score #rub mirror_rub_type matches 2 run data merge entity @s {Fire:60s}
# 类型 3 兽：击退 3 格 + 减速 2s
execute if score #rub mirror_rub_type matches 3 run function plm:mirror/skill/furnace/rub/release/knockback
execute if score #rub mirror_rub_type matches 3 run effect give @s minecraft:slowness 2 1 true
# 类型 4 其他（含未记录）：定身 1s
execute if score #rub mirror_rub_type matches 4 run effect give @s minecraft:slowness 1 255 true
