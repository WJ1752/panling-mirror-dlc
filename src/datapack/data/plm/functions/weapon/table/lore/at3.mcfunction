# 重写槽 3 镜武 display.Lore；末行保留占位
data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore set value []

# 读器形/镜统/锻位
scoreboard players set #t wp_form 0
scoreboard players set #t wp_set 0
scoreboard players set #t wp_temper 0
scoreboard players set #t wp_setcount 0
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_sword7"}}] run scoreboard players set #t wp_form 1
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_axe7"}}] run scoreboard players set #t wp_form 2
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_bow7"}}] run scoreboard players set #t wp_form 3
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_crossbow7"}}] run scoreboard players set #t wp_form 4
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_furnace_twin7"}}] run scoreboard players set #t wp_form 5
execute if data block ~ ~ ~ Items[{Slot:3b,tag:{id:"panling:mirror_furnace_rub7"}}] run scoreboard players set #t wp_form 6
execute store result score #t wp_set run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_set
execute store result score #t wp_temper run data get block ~ ~ ~ Items[{Slot:3b}].tag.mirror_temper
# 锻位以实际五纹数（DMG+SKL+FX）为准；旧物品 mirror_temper 不同步时以数组为准。
function plm:weapon/affix/count
scoreboard players operation #t wp_temper = #t wp_count
function plm:weapon/table/full

# 头部
data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§8===== §f§l【镜武】§8====="}'
execute if score #t wp_form matches 1 if score #t wp_set matches 0 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f器形：剑  §7| §f镜统：§b照心"}'
execute if score #t wp_form matches 1 if score #t wp_set matches 1 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f器形：剑  §7| §f镜统：§b裂影"}'
execute if score #t wp_form matches 2 if score #t wp_set matches 0 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f器形：斧  §7| §f镜统：§b照心"}'
execute if score #t wp_form matches 2 if score #t wp_set matches 1 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f器形：斧  §7| §f镜统：§b裂影"}'
execute if score #t wp_form matches 3 if score #t wp_set matches 2 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f器形：弓  §7| §f镜统：§b镜花"}'
execute if score #t wp_form matches 3 if score #t wp_set matches 3 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f器形：弓  §7| §f镜统：§b残影"}'
execute if score #t wp_form matches 4 if score #t wp_set matches 2 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f器形：弩  §7| §f镜统：§b镜花"}'
execute if score #t wp_form matches 4 if score #t wp_set matches 3 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f器形：弩  §7| §f镜统：§b残影"}'
execute if score #t wp_form matches 5 if score #t wp_set matches 4 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f器形：双生炉  §7| §f镜统：§b双生"}'
execute if score #t wp_form matches 5 if score #t wp_set matches 5 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f器形：双生炉  §7| §f镜统：§b拓印"}'
execute if score #t wp_form matches 6 if score #t wp_set matches 4 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f器形：拓印炉  §7| §f镜统：§b双生"}'
execute if score #t wp_form matches 6 if score #t wp_set matches 5 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f器形：拓印炉  §7| §f镜统：§b拓印"}'

# 锻位
data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§8===== §f§l【锻位】§8====="}'
execute if score #t wp_temper matches 0 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f锻位：§b0 §7（未开纹）"}'
execute if score #t wp_temper matches 1 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f锻位：§bI"}'
execute if score #t wp_temper matches 2 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f锻位：§bII"}'
execute if score #t wp_temper matches 3 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f锻位：§bIII"}'
execute if score #t wp_temper matches 4 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f锻位：§bIV"}'
execute if score #t wp_temper matches 5 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f锻位：§bV"}'
execute if score #t wp_full matches 1 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§7（本器形已满：5 条；上限 3/3/1）"}'

# 镜纹
data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§8===== §f§l【镜纹】§8====="}'
execute if score #t wp_temper matches 0 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§7（尚无镜纹）"}'
# 伤害纹 DMG：近战/弓弩 11 条 active；炉形仅映刃（skill_hit 消费）；镜隙 4 设计停用
function plm:weapon/table/lore/dmg_at3
# 技能纹 SKL：按器形输出名称/品阶/实际数值（36 条池，最多 3 条）
function plm:weapon/table/lore/skl_at3
# 特效纹 FX：10 条（名称/品阶/实际值）+ 4 条共鸣
function plm:weapon/table/lore/fx_at3
# 套装
data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§8===== §f§l【套装】§8====="}'
execute if score #t wp_set matches 0 if score @s mirror_set_a matches 0.. run scoreboard players operation #t wp_setcount = @s mirror_set_a
execute if score #t wp_set matches 1 if score @s mirror_set_b matches 0.. run scoreboard players operation #t wp_setcount = @s mirror_set_b
execute if score #t wp_set matches 2 if score @s mirror_set_c matches 0.. run scoreboard players operation #t wp_setcount = @s mirror_set_c
execute if score #t wp_set matches 3 if score @s mirror_set_d matches 0.. run scoreboard players operation #t wp_setcount = @s mirror_set_d
execute if score #t wp_set matches 4 if score @s mirror_set_e matches 0.. run scoreboard players operation #t wp_setcount = @s mirror_set_e
execute if score #t wp_set matches 5 if score @s mirror_set_f matches 0.. run scoreboard players operation #t wp_setcount = @s mirror_set_f
# 台上这把武器按 1 件计入（它不在主手，set/count 不会替它计数）
scoreboard players add #t wp_setcount 1
# 封顶 4：3 防具 + 武器 = 4/4，4 防具 + 武器也按 4/4 显示（§5.2 P0-1）
execute if score #t wp_setcount matches 5.. run scoreboard players set #t wp_setcount 4
execute if score #t wp_set matches 0 if score #t wp_setcount matches 0 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f照心 0/4 §7（含武器）"}'
execute if score #t wp_set matches 0 if score #t wp_setcount matches 1 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f照心 1/4 §7（含武器）"}'
execute if score #t wp_set matches 0 if score #t wp_setcount matches 2 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f照心 2/4 §7（含武器）"}'
execute if score #t wp_set matches 0 if score #t wp_setcount matches 3 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f照心 3/4 §7（含武器）"}'
execute if score #t wp_set matches 0 if score #t wp_setcount matches 4 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f照心 4/4 §7（含武器）"}'
execute if score #t wp_set matches 1 if score #t wp_setcount matches 0 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f裂影 0/4 §7（含武器）"}'
execute if score #t wp_set matches 1 if score #t wp_setcount matches 1 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f裂影 1/4 §7（含武器）"}'
execute if score #t wp_set matches 1 if score #t wp_setcount matches 2 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f裂影 2/4 §7（含武器）"}'
execute if score #t wp_set matches 1 if score #t wp_setcount matches 3 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f裂影 3/4 §7（含武器）"}'
execute if score #t wp_set matches 1 if score #t wp_setcount matches 4 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f裂影 4/4 §7（含武器）"}'
execute if score #t wp_set matches 2 if score #t wp_setcount matches 0 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f镜花 0/4 §7（含武器）"}'
execute if score #t wp_set matches 2 if score #t wp_setcount matches 1 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f镜花 1/4 §7（含武器）"}'
execute if score #t wp_set matches 2 if score #t wp_setcount matches 2 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f镜花 2/4 §7（含武器）"}'
execute if score #t wp_set matches 2 if score #t wp_setcount matches 3 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f镜花 3/4 §7（含武器）"}'
execute if score #t wp_set matches 2 if score #t wp_setcount matches 4 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f镜花 4/4 §7（含武器）"}'
execute if score #t wp_set matches 3 if score #t wp_setcount matches 0 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f残影 0/4 §7（含武器）"}'
execute if score #t wp_set matches 3 if score #t wp_setcount matches 1 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f残影 1/4 §7（含武器）"}'
execute if score #t wp_set matches 3 if score #t wp_setcount matches 2 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f残影 2/4 §7（含武器）"}'
execute if score #t wp_set matches 3 if score #t wp_setcount matches 3 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f残影 3/4 §7（含武器）"}'
execute if score #t wp_set matches 3 if score #t wp_setcount matches 4 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f残影 4/4 §7（含武器）"}'
execute if score #t wp_set matches 4 if score #t wp_setcount matches 0 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f双生 0/4 §7（含武器）"}'
execute if score #t wp_set matches 4 if score #t wp_setcount matches 1 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f双生 1/4 §7（含武器）"}'
execute if score #t wp_set matches 4 if score #t wp_setcount matches 2 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f双生 2/4 §7（含武器）"}'
execute if score #t wp_set matches 4 if score #t wp_setcount matches 3 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f双生 3/4 §7（含武器）"}'
execute if score #t wp_set matches 4 if score #t wp_setcount matches 4 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f双生 4/4 §7（含武器）"}'
execute if score #t wp_set matches 5 if score #t wp_setcount matches 0 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f拓印 0/4 §7（含武器）"}'
execute if score #t wp_set matches 5 if score #t wp_setcount matches 1 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f拓印 1/4 §7（含武器）"}'
execute if score #t wp_set matches 5 if score #t wp_setcount matches 2 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f拓印 2/4 §7（含武器）"}'
execute if score #t wp_set matches 5 if score #t wp_setcount matches 3 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f拓印 3/4 §7（含武器）"}'
execute if score #t wp_set matches 5 if score #t wp_setcount matches 4 run data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§f拓印 4/4 §7（含武器）"}'
data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§8==========================="}'
data modify block ~ ~ ~ Items[{Slot:3b}].tag.display.Lore append value '{"text": "§7（本行留空，交本体写「属性已激活」）"}'
