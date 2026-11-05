# 未到期的队首条目移到队尾：先 append 副本，再删队首。
data modify storage plm:mirror echo append from storage plm:mirror echo[0]
data remove storage plm:mirror echo[0]
