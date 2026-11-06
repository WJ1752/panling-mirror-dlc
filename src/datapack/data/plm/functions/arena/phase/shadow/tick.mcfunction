# 首次镜主前只召唤；持械后的追击/普攻统一由 boss/attack 处理。
execute if score #arena mirror_tick matches 10 at @e[tag=mirror_arena_boss,limit=1] run particle minecraft:enchant ~ ~1.5 ~ 0.4 0.6 0.4 0.2 2
