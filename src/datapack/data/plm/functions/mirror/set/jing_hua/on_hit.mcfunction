# 镜花命中入口（由 plm:mirror/set/on_hit 调用；@s=玩家）
# 2 件套的“远程命中叠花影”在 bow/bloom_hit 与 bow/flower_add 中结算；
# 近战 on-hit 不叠花影，因此这里是空实现。
return 0
