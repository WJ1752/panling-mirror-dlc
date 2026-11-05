# 看队首：owner 匹配则删除，否则移到队尾。
execute store result score #tw_purge_owner mirror_zf_tmp run data get storage plm:mirror echo[0].owner
execute if score #tw_purge_owner mirror_zf_tmp = #mirror_clear mirror_skill_tmp run data remove storage plm:mirror echo[0]
execute if score #tw_purge_owner mirror_zf_tmp = #mirror_clear mirror_skill_tmp run return 0
data modify storage plm:mirror echo append from storage plm:mirror echo[0]
data remove storage plm:mirror echo[0]
