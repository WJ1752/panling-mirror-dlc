# 重写防具 Lore：优先槽 3（磨镜/定影/映度），否则槽 5（拼镜输出）
# 只在镜装（is_armor:1）上工作，武器/材料不碰。
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1}}] run function plm:mirror/table/lore/at3
execute unless data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,is_armor:1}}] if data block ~ ~ ~ Items[{Slot:5b,tag:{mirror:1,is_armor:1}}] run function plm:mirror/table/lore/at5
