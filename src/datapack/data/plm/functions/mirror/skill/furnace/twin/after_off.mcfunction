# 双生炉·倒映（炉在主手，元素在副手）—— after 钩子入口
# 由 plm:mirror/furnace/after_off 在 zfsuccess=1 且主手是 panling:mirror_furnace_twin7 时分派。
# 上下文：@s = 玩家，已 at @s（主阵位置）。
# 设计：镜中倒影_武器技能详细设计_v0.1 §2.5.1 / §1.1~§1.4。
execute unless score @s zfsuccess matches 1 run return 0
execute unless entity @s[nbt={SelectedItem:{tag:{id:"panling:mirror_furnace_twin7",act:1}}}] run return 0
# 元素在副手（zf_hold_ldl=-4..-1）；#tw_hand 供 element/snapshot 选择读取面
scoreboard players set #tw_hand mirror_zf_tmp -1
function plm:mirror/skill/furnace/twin/after
