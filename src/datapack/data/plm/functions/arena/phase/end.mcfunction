# 仅血量归零时发奖；团灭/意外丢失实体只清理战场。
title @a[tag=mirror_arena_inside,distance=0..] title {"text":"影主已消散","color":"white","bold":true}
scoreboard players set #arena mirror_arena_outcome 1
function plm:arena/reward/win
function plm:arena/room/close
