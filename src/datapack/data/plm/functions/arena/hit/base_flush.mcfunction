# @s = 竞技场受击盒。本体补伤绕过吸收直接写 Health；只认参战者发起的攻击事务。
execute if entity @s[tag=mirror_arena_base_pending] run function plm:arena/hit/base_read
tag @s remove mirror_arena_base_pending
tag @a[tag=mirror_arena_base_owner] remove mirror_arena_base_owner
data modify entity @s Health set value 1024.0f
