# 测试夹具：原子构造“本次受到 10 HP”的生命快照并走真实折光入口。
# weapon/tick/5t 每 5t 重写 mirror_hp_last / mirror_hp_last_t；分成多条命令设置会与 tick 竞争，
# 导致 estimate 得到 0 差额。这里在同一个函数链内快照并结算。
# 要求：@s 已持激活镜武、mirror_parse_ok=1、wp_affix_fx_zhe_guang 已按测试设定。
execute store result score #t mirror_wtmp5 run data get entity @s Health 100
scoreboard players operation @s mirror_hp_last = #t mirror_wtmp5
scoreboard players add @s mirror_hp_last 1000
scoreboard players operation @s mirror_hp_last_t = #sys mirror_game_time
function plm:weapon/fx/zhe_guang
