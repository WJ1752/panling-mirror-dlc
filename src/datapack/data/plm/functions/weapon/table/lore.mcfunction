# 重写 display.Lore：优先槽 5（输出位），否则槽 3（兼容直接调用）
execute if data block ~ ~ ~ Items[{Slot:5b,tag:{mirror:1,mirror_ver:2}}] run function plm:weapon/table/lore/at5
execute unless data block ~ ~ ~ Items[{Slot:5b,tag:{mirror:1,mirror_ver:2}}] if data block ~ ~ ~ Items[{Slot:3b,tag:{mirror:1,mirror_ver:2}}] run function plm:weapon/table/lore/at3
