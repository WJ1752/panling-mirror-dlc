# 槽 5 的防具（拼镜输出）→ storage 副本 → 重写 Lore → 写回
data modify storage plm:tbl lore_item set from block ~ ~ ~ Items[{Slot:5b}]
function plm:mirror/table/lore/build
data modify block ~ ~ ~ Items[{Slot:5b}].tag.display.Lore set from storage plm:tbl lore_item.tag.display.Lore
