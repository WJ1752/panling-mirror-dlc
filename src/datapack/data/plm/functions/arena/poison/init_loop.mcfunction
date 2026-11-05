scoreboard players add #arena mirror_poison_i 1
function plm:arena/poison/init_one
execute if score #arena mirror_poison_i matches ..63 if score #arena mirror_poison_count < #arena mirror_poison_need run function plm:arena/poison/init_loop
