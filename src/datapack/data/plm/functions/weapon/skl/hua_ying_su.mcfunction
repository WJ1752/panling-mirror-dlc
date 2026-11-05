# SKL hua_ying_su（花影·速，max 50 → 满值 500，actual×10）
# 消费点：plm:mirror/skill/bow/route.mcfunction 快照到 mirror_flower_extra；
#         plm:mirror/skill/bow/flower_add.mcfunction 每层掷一次 1..100 <= (值/10)，成功再 +1 层。
#   500 → 50%；基础每箭最多 2 层，额外层可让单箭继续叠（上限仍受 mirror_flower_max 约束：3 或 2 件套 5）。
# 本文件不在调用路径上，只作为词条说明；具体读取在 route / flower_add 里。
return 0
