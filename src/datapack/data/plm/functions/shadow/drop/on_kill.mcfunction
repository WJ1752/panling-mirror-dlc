# advancement限定被击杀者为DLC/影域使用的monster标签，避免击杀鸡、宠物或玩家掉影尘。
advancement revoke @s only plm:shadow/kill

# 五域副本内的DLC怪物击杀概率略高；影域野外只对影域活动玩家有效。
execute if entity @s[tag=plm_d_fire] if predicate plm:shadow/domain_drop run loot spawn ~ ~ ~ loot plm:shadow/dust
execute if entity @s[tag=plm_d_tomb] if predicate plm:shadow/domain_drop run loot spawn ~ ~ ~ loot plm:shadow/dust
execute if entity @s[tag=plm_d_tower] if predicate plm:shadow/domain_drop run loot spawn ~ ~ ~ loot plm:shadow/dust
execute if entity @s[tag=plm_d_valley] if predicate plm:shadow/domain_drop run loot spawn ~ ~ ~ loot plm:shadow/dust
execute if entity @s[tag=plm_d_mountain] if predicate plm:shadow/domain_drop run loot spawn ~ ~ ~ loot plm:shadow/dust
execute if entity @s[tag=plm_shadow_active,tag=plm_shadow_wilderness,tag=!plm_shadow_safe] if predicate plm:shadow/wild_drop run loot spawn ~ ~ ~ loot plm:shadow/dust
