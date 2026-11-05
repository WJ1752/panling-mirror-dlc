# 旧版独立 tick 自循环已停用（入口去重为 #minecraft:tick → plm:tick/main）。
# 保留空函数用于吸收旧版本已经排队的 schedule，避免 “Unknown function” 报错。
