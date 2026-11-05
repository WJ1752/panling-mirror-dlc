# 留影 · 给“主人还活着、没死过，并且和弩机在同一维度”的弩机打 mirror_turret_alive
# @s=玩家；调用处是 `as @a at @s`，所以执行维度就是玩家所在维度。
# 弩机把自己的维度存进 mirror_turret_dim（0 主世界 / 1 下界 / 2 末地），逐台比较。
scoreboard players operation #cbown mirror_skill_tmp = @s player_uid
# deathCount 在未死亡时可能没有分数：先归 0，再仅在已设置时复制。
scoreboard players set #cbdeath mirror_skill_tmp2 0
execute if score @s mirror_death matches 0.. run scoreboard players operation #cbdeath mirror_skill_tmp2 = @s mirror_death
# 玩家当前维度
scoreboard players set #pdim mirror_skill_tmp3 0
execute if dimension minecraft:the_nether run scoreboard players set #pdim mirror_skill_tmp3 1
execute if dimension minecraft:the_end run scoreboard players set #pdim mirror_skill_tmp3 2
execute as @e[tag=mirror_turret] if score @s mirror_turret_owner = #cbown mirror_skill_tmp if score @s mirror_turret_prev = #cbdeath mirror_skill_tmp2 if score @s mirror_turret_dim = #pdim mirror_skill_tmp3 run tag @s add mirror_turret_alive
