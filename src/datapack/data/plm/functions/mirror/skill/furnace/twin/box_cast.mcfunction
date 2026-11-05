# 在当前执行位置生成镜匣倒影阵并立即结算（不走延迟队列，因此不产生任何实体）。
# 预乘 base×ratio/100 到 #tw_base，并把 #tw_ratio 置 100，保持 echo/hit 的原公式。
scoreboard players operation #tw_base mirror_skill_tmp *= #tw_ratio mirror_skill_ratio
scoreboard players operation #tw_base mirror_skill_tmp /= #const100 mirror_calc
scoreboard players set #tw_ratio mirror_skill_ratio 100
scoreboard players operation #tw_owner mirror_zf_tmp = @s player_uid
function plm:mirror/skill/furnace/twin/echo/damage
