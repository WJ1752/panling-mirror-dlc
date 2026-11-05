# 梦回盘灵 · 镜中倒影 DLC

这是 Minecraft Java 版 1.20.1 的盘灵扩展项目。当前源码基线为 `1.0.0-alpha.55`，包含镜装、磨镜台、五行影商兑换和影主竞技场的战斗逻辑。

## 项目内容

- `src/datapack/` 包含可打包的 DLC 函数、进度、标签和物品数据。
- `src/resourcepack/` 包含 DLC 模型、贴图、语言文件和对本体资源的合并补丁。
- `src/tools/` 包含构建、贴图生成和静态检查工具。
- [五域与影主 BOSS 战详细设计](./镜中倒影_五域与影主BOSS战详细设计_v1.0.docx) 说明每域的路线、映主机制、首领招式和验收条件。五域正式地图与影主六种强化技属于后续开发内容。

## 本地构建

准备 Python 3 和 Pillow。完整构建依赖开发者自行取得的盘灵本体包，分别放在以下位置。

```text
梦回盘灵服务端/world/datapacks/panling-1.1.0b.zip
梦回盘灵服务端/resourcepack/panling-1.20-resourcepack-1.1.0b.zip
```

首次构建先从自己的 Minecraft Java 1.20.1 客户端生成盔甲纹饰图集与原版调色板，再运行打包工具。将示例路径替换为本机的客户端 JAR。

```sh
python -I src/tools/gen_trim_integration.py --jar "/path/to/1.20.1.jar"
python -I src/tools/build.py --ver 1.0.0-alpha.55
```

构建工具运行静态检查，并将 DLC 数据包、合并资源包和版本清单写入 `dist/`。本体包、世界存档、合并产物与运行凭据保留在本地。
