# 仅血量归零时提示胜利；意外丢失实体或团灭只清理战场。
title @a[tag=mirror_arena_inside,distance=0..] title {"text":"影主已消散","color":"white","bold":true}
function plm:arena/room/close
