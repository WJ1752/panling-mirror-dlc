# @s=玩家。任一「武器技增益」仍在生效时，把素锋的判定窗口续到 now+60。
# 只由 plm:weapon/tick/5t 对 @a[tag=mirror_weapon_active] 调用，不额外扫全服。
execute if score @s mirror_parry matches 1.. run function plm:weapon/tick/skill_buff
execute if score @s mirror_flower matches 1.. run function plm:weapon/tick/skill_buff
execute if score @s mirror_taying_buff matches 1.. run function plm:weapon/tick/skill_buff
execute if score @s mirror_resonance_until >= #sys mirror_game_time run function plm:weapon/tick/skill_buff
execute if entity @s[tag=mirror_skill_active] run function plm:weapon/tick/skill_buff
