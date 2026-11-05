# 槽 3 的防具 → storage 副本 → 重写 Lore → 写回
data modify storage plm:tbl lore_item set from block ~ ~ ~ Items[{Slot:3b}]
function plm:mirror/table/lore/build
data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore set from storage plm:tbl lore_item.tag.display.Lore
