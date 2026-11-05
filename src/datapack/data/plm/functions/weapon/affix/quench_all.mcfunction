# 淬纹：保留类别/id/形状，只重掷五条 val（可能整体变低）
execute if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[0] run function plm:weapon/affix/quench/dmg_0
execute if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[1] run function plm:weapon/affix/quench/dmg_1
execute if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_dmg[2] run function plm:weapon/affix/quench/dmg_2
execute if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[0] run function plm:weapon/affix/quench/skl_0
execute if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[1] run function plm:weapon/affix/quench/skl_1
execute if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_skl[2] run function plm:weapon/affix/quench/skl_2
execute if data block ~ ~ ~ Items[{Slot:3b}].tag.mirror_fx[0] run function plm:weapon/affix/quench/fx_0
