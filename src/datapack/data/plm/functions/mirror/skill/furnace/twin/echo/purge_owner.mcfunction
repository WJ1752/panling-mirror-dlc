# 丢弃 owner == #mirror_clear 的待结算倒影阵条目；单次最多处理 32 条。
# 不扫实体：只轮转 storage 列表（删除匹配项，其余移到队尾）。
scoreboard players set #tw_purge_n mirror_zf_tmp 0
execute store result score #tw_purge_n mirror_zf_tmp run data get storage plm:mirror echo
execute if score #tw_purge_n mirror_zf_tmp matches 33.. run scoreboard players set #tw_purge_n mirror_zf_tmp 32
function plm:mirror/skill/furnace/twin/echo/purge_one
