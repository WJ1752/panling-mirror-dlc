# 连影 · 重影箭（@s=玩家；目标带 mirror_lian_hit_target）
# 第 4 次命中：缓慢 + 消耗计数。穿透不再在命中回调里改（箭已经停住，且
# 按 tag 选箭可能选到别的箭）；第 3 次命中时写入 mirror_lian_next_pierce，
# 由 weapon/ctx/arrow 在第 4 支箭出膛前写进 PierceLevel。
# 命中缓慢 255：为绕开 advancement reward 上下文把 amplifier 255 压成 0 的问题，
# 用 1t 后的 schedule 在服务端 tick 上下文里给目标上 slowness（设计写 10t，/effect 最小 1s）。
scoreboard players set @s mirror_lian_extra 0

tag @e[tag=monster,tag=mirror_lian_hit_target,limit=1] add mirror_lian_slow_target
schedule function plm:mirror/skill/crossbow/lian/slow 1t replace

scoreboard players set @s mirror_lian 0
scoreboard players set @s mirror_lian_next_pierce 0
function plm:weapon/util/rand100
scoreboard players operation #t wp_rand *= #const10 mirror_calc
execute if score #t wp_rand <= @s wp_affix_skl_lian_ying_yi run scoreboard players set @s mirror_lian 3
