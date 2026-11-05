# 返还镜胚（进输出位）
execute if score #t kind matches 1 run item replace block ~ ~ ~ container.5 with minecraft:flint{id:"panling:mirror_mold_sword",CustomModelData:370,display:{Name:'{"translate":"pl.item.name.mirror_mold_sword"}'}} 1
execute if score #t kind matches 2 run item replace block ~ ~ ~ container.5 with minecraft:flint{id:"panling:mirror_mold_axe",CustomModelData:371,display:{Name:'{"translate":"pl.item.name.mirror_mold_axe"}'}} 1
execute if score #t kind matches 3 run item replace block ~ ~ ~ container.5 with minecraft:flint{id:"panling:mirror_mold_bow",CustomModelData:372,display:{Name:'{"translate":"pl.item.name.mirror_mold_bow"}'}} 1
execute if score #t kind matches 4 run item replace block ~ ~ ~ container.5 with minecraft:flint{id:"panling:mirror_mold_crossbow",CustomModelData:373,display:{Name:'{"translate":"pl.item.name.mirror_mold_crossbow"}'}} 1
execute if score #t kind matches 5 run item replace block ~ ~ ~ container.5 with minecraft:flint{id:"panling:mirror_mold_furnace_twin",CustomModelData:374,display:{Name:'{"translate":"pl.item.name.mirror_mold_furnace_twin"}'}} 1
execute if score #t kind matches 6 run item replace block ~ ~ ~ container.5 with minecraft:flint{id:"panling:mirror_mold_furnace_rub",CustomModelData:375,display:{Name:'{"translate":"pl.item.name.mirror_mold_furnace_rub"}'}} 1

# 防具：六套统一按部位返还对应镜胚（kind=10，part 0..3）
execute if score #t kind matches 10 if score #t part matches 0 run item replace block ~ ~ ~ container.5 with minecraft:charcoal{id:"panling:mirror_mold_helmet",CustomModelData:376,display:{Name:'{"translate":"pl.item.name.mirror_mold_helmet"}'}} 1
execute if score #t kind matches 10 if score #t part matches 1 run item replace block ~ ~ ~ container.5 with minecraft:charcoal{id:"panling:mirror_mold_chestplate",CustomModelData:377,display:{Name:'{"translate":"pl.item.name.mirror_mold_chestplate"}'}} 1
execute if score #t kind matches 10 if score #t part matches 2 run item replace block ~ ~ ~ container.5 with minecraft:charcoal{id:"panling:mirror_mold_leggings",CustomModelData:378,display:{Name:'{"translate":"pl.item.name.mirror_mold_leggings"}'}} 1
execute if score #t kind matches 10 if score #t part matches 3 run item replace block ~ ~ ~ container.5 with minecraft:charcoal{id:"panling:mirror_mold_boots",CustomModelData:379,display:{Name:'{"translate":"pl.item.name.mirror_mold_boots"}'}} 1

# 防具额外返还：镜片×2（同 mirror_elem）+ 影尘×5
execute if score #t kind matches 10 if score #t elem matches 0 run give @s minecraft:netherite_scrap{id:"panling:mirror_shard_metal",CustomModelData:300,display:{Name:'{"translate":"pl.item.name.mirror_shard_metal"}'}} 2
execute if score #t kind matches 10 if score #t elem matches 1 run give @s minecraft:netherite_scrap{id:"panling:mirror_shard_wood",CustomModelData:305,display:{Name:'{"translate":"pl.item.name.mirror_shard_wood"}'}} 2
execute if score #t kind matches 10 if score #t elem matches 2 run give @s minecraft:netherite_scrap{id:"panling:mirror_shard_water",CustomModelData:310,display:{Name:'{"translate":"pl.item.name.mirror_shard_water"}'}} 2
execute if score #t kind matches 10 if score #t elem matches 3 run give @s minecraft:netherite_scrap{id:"panling:mirror_shard_fire",CustomModelData:315,display:{Name:'{"translate":"pl.item.name.mirror_shard_fire"}'}} 2
execute if score #t kind matches 10 if score #t elem matches 4 run give @s minecraft:netherite_scrap{id:"panling:mirror_shard_earth",CustomModelData:320,display:{Name:'{"translate":"pl.item.name.mirror_shard_earth"}'}} 2
execute if score #t kind matches 10 run give @s minecraft:gunpowder{id:"panling:mirror_dust",CustomModelData:390,display:{Name:'{"translate":"pl.item.name.mirror_dust"}'}} 5
