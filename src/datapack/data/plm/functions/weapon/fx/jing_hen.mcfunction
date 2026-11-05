# 镜痕（jing_hen）— 伤害侧：带痕目标受到「留痕者」的伤害 +5%
# 留痕由 plm:weapon/fx/jing_hen/mark 在命中后写入；这里只读取，不改状态。
# mirror_jinghen_until / mirror_jinghen_owner 是目标实体身上的分数（objective 在 load/combat 声明）。
execute unless score @s wp_affix_fx_jing_hen matches 1.. run return 0
execute unless entity @e[tag=plm_ctx_target,limit=1] run return 0
execute unless score @e[tag=plm_ctx_target,limit=1] mirror_jinghen_until >= #sys mirror_game_time run return 0
execute unless score @e[tag=plm_ctx_target,limit=1] mirror_jinghen_owner = @s player_uid run return 0
scoreboard players operation @s mirror_ctx_extra += @s wp_affix_fx_jing_hen
