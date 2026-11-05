# 1..100 均匀随机 → #t wp_rand
# 1.20.1 没有 /random；predicate random_chance 只能返回布尔且概率写死，无法给出数值。
# 用 32-bit LCG（Java int 溢出 = mod 2^32）在计分板上生成，零实体、零方块、零物品栏操作。
# state = state * 1103515245 + 12345；取 bit16 以上再 %100（高位比低位均匀）。
# #sys wp_rand_seed 是跨调用持久状态，保证同一 tick 内多次调用得到不同值。
# 旧实现用 loot 表生成带标记的物品实体再读 Item.Count，每掷一次都会产生一个临时 item 实体；
# 已移除（#64）。loot table 文件保留但不再被引用。
scoreboard players set #rand_a mirror_calc 1103515245
scoreboard players set #rand_c mirror_calc 12345
scoreboard players set #rand_s mirror_calc 65536
scoreboard players set #rand_m mirror_calc 100
scoreboard players set #rand_n mirror_calc -1
scoreboard players add #sys wp_rand_seed 1
scoreboard players operation #sys wp_rand_seed *= #rand_a mirror_calc
scoreboard players operation #sys wp_rand_seed += #rand_c mirror_calc
scoreboard players operation #t wp_rand = #sys wp_rand_seed
scoreboard players operation #t wp_rand /= #rand_s mirror_calc
scoreboard players operation #t wp_rand %= #rand_m mirror_calc
execute if score #t wp_rand matches ..-1 run scoreboard players operation #t wp_rand *= #rand_n mirror_calc
scoreboard players add #t wp_rand 1
