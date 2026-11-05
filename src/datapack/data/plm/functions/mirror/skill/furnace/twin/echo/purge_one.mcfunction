# purge_owner 的循环体。
execute unless data storage plm:mirror echo[0] run scoreboard players set #tw_purge_n mirror_zf_tmp 0
execute if score #tw_purge_n mirror_zf_tmp matches 1.. run function plm:mirror/skill/furnace/twin/echo/purge_step
execute if score #tw_purge_n mirror_zf_tmp matches 1.. run scoreboard players remove #tw_purge_n mirror_zf_tmp 1
execute if score #tw_purge_n mirror_zf_tmp matches 1.. run function plm:mirror/skill/furnace/twin/echo/purge_one
