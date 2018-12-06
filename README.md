# dota2_water_tower

基于dota rpg地图《水之td》的dota2重制版.

项目持续迭代开发中

#### 源码下载运行
```git clone https://github.com/564398053/dota2_water_tower.git  ```
由于只上传了源码部分，要运行请先完整编译地图

#### 已完成 
1. 地形框架
2. 关卡逻辑
3. 防御塔建造
4. 怪物行动路径
5. 种族 猎人 9/12
6. 物品合成系统

#### TODO:
1. 地形美化
2. 完成其余种族. 法师， 深海， 远古 etc.
3. 物品掉落系统
4. 商店
5. 黑市商人
6. 怪物完善 已完成 1% 剩余 99%， boss、 最终boss、 伤害测试 、飞机...
7. 天赋系统
8. 难度平衡



#### TODO bug fix:
1. 怪物行动路径不按pathway行走问题修复
2. 时钟正确显示游戏内时间.
3. 建筑不能携带物品bug, ```"MovementCapabilities"        "DOTA_UNIT_CAP_MOVE_NONE"```不能移动就不能拾取和丢弃物品?
4. 隐藏建造者技能栏. 太长了不方便看和使用.
