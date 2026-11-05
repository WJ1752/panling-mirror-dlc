# 挂在 plm:mirror/skill/tick（5t）
# @a 是全局选择器（覆盖所有维度），玩家计时只跑一次；按维度展开会 3 倍递减。
# 需要按维度处理的只有 @e 实体扫描，由各器形自己的 tick 包装负责。
# （镜映快照已移到独立的 2t schedule，见 plm:mirror/skill/snapshot）
function plm:mirror/skill/player_tick_dim

# 实体侧各器形自行按维度展开，这里只调用一次，避免重复递减。
function plm:mirror/skill/shadow/tick
function plm:mirror/skill/axe/chongying/tick

# 六器形共享入口（器形代理覆盖同名函数）
function plm:mirror/skill/sword/tick
function plm:mirror/skill/bow/tick
function plm:mirror/skill/crossbow/tick
function plm:mirror/skill/furnace/twin/tick
function plm:mirror/skill/furnace/rub/tick
function plm:mirror/skill/axe/tick
# 镜统 2/4 件套共享 tick
function plm:mirror/set/tick
