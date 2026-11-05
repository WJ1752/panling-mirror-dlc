# 底部阴阳面板：黑白棋盘固定，外圈/中心显示当前底部色
execute if score #arena mirror_bottom_color matches 1 run function plm:arena/panel/bottom/black
execute if score #arena mirror_bottom_color matches 2 run function plm:arena/panel/bottom/white
