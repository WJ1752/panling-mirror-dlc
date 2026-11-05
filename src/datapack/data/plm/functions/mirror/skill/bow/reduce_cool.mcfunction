# 兼容旧调用：把玩家 mirror_cd_a 交给共享 plm:mirror/skill/reduce_cool。
# 新代码请直接用 plm:mirror/skill/reduce_cool（输入 #cd mirror_skill_tmp）。
scoreboard players operation #cd mirror_skill_tmp = @s mirror_cd_a
function plm:mirror/skill/reduce_cool
scoreboard players operation @s mirror_cd_a = #cd mirror_skill_tmp
