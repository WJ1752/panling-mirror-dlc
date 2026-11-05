# forceload add 仅对新加入的单块成功；已有强载和重复采样记为 0。退出时只移除本局添加的项。
data modify storage plm:arena room.tickets set value {}
execute store success storage plm:arena room.tickets.c00 byte 1 run forceload add ~-24 ~-24
execute store success storage plm:arena room.tickets.c01 byte 1 run forceload add ~-24 ~-8
execute store success storage plm:arena room.tickets.c02 byte 1 run forceload add ~-24 ~8
execute store success storage plm:arena room.tickets.c03 byte 1 run forceload add ~-24 ~23
execute store success storage plm:arena room.tickets.c10 byte 1 run forceload add ~-8 ~-24
execute store success storage plm:arena room.tickets.c11 byte 1 run forceload add ~-8 ~-8
execute store success storage plm:arena room.tickets.c12 byte 1 run forceload add ~-8 ~8
execute store success storage plm:arena room.tickets.c13 byte 1 run forceload add ~-8 ~23
execute store success storage plm:arena room.tickets.c20 byte 1 run forceload add ~8 ~-24
execute store success storage plm:arena room.tickets.c21 byte 1 run forceload add ~8 ~-8
execute store success storage plm:arena room.tickets.c22 byte 1 run forceload add ~8 ~8
execute store success storage plm:arena room.tickets.c23 byte 1 run forceload add ~8 ~23
execute store success storage plm:arena room.tickets.c30 byte 1 run forceload add ~23 ~-24
execute store success storage plm:arena room.tickets.c31 byte 1 run forceload add ~23 ~-8
execute store success storage plm:arena room.tickets.c32 byte 1 run forceload add ~23 ~8
execute store success storage plm:arena room.tickets.c33 byte 1 run forceload add ~23 ~23
