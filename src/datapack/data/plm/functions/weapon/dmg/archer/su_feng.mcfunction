# 素锋（su_feng）— 武器技增益未激活时的普攻（弓/弩命中侧）
# 「武器技增益已激活」的持久状态 = @s mirror_skill_buff_until（game_time）：
#   ctx/skill 在 when_weapon_skill_enable 时写入 now+60；tick/5t 在镜映/踏影/花影/共鸣等实 buff 期间续期。
execute unless score @s wp_affix_dmg_su_feng matches 1.. run return 0
execute unless score @s mirror_skill_buff_until matches -2147483648.. run scoreboard players set @s mirror_skill_buff_until 0
execute if score @s mirror_skill_buff_until >= #sys mirror_game_time run return 0
scoreboard players operation @s mirror_ctx_extra += @s wp_affix_dmg_su_feng
