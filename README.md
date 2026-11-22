# 暗影纪元：神域之战 v0.1

Godot 4.3 经典像素风、2.5D斜45度视觉的单机 RPG 起步工程。

## 当前原型
- 斜45度菱形地面与森林装饰
- 触屏左侧拖动移动
- 攻击按钮、怪物生命值、经验与升级
- 自动存档与手动保存按钮

## 用手机通过 GitHub 云端构建 APK
1. 在 GitHub 新建一个空仓库，例如 `ShadowEra-RPG`。
2. 将本压缩包解压后，把里面所有文件上传到仓库根目录（保持 `.github/workflows/build-android.yml` 路径）。
3. 打开仓库的 **Actions** 页面。
4. 选择 **Build Android APK**，点击 **Run workflow**。
5. 等待任务完成，打开绿色成功的工作流记录。
6. 在页面底部 **Artifacts** 下载 `ShadowEra-Android-APK`，解压后得到 `ShadowEra-debug.apk`。
7. 在安卓手机上安装。首次安装时，按系统提示允许浏览器或文件管理器安装该 APK。

## 注意
- 这是第一版可玩原型，不是完整商业游戏。
- 云端构建使用 Godot CI Docker 镜像；若上游镜像或 Android 导出模板版本变化导致失败，可根据 Actions 日志调整构建环境。
- 当前工程以 Godot 4.3 为目标，后续可以继续增加剧情、职业、地图、技能、装备和音效。
