# 测试夹具：原子构造“本次受到 10 HP”的生命快照并走真实照心 BASE 入口。
# 与 dev/zhe_guang_10hp 同因：5t tick 会重写 mirror_hp_last，分步设置会被覆盖。
# 要求：@s 已持激活镜武、mirror_parse_ok=1、wp_set=0、mirror_form=0..1。
execute store result score #t mirror_wtmp5 run data get entity @s Health 100
scoreboard players operation @s mirror_hp_last = #t mirror_wtmp5
scoreboard players add @s mirror_hp_last 1000
scoreboard players operation @s mirror_hp_last_t = #sys mirror_game_time
function plm:weapon/base/base_zhao_xin
