[English](./README.EN.md) | 简体中文

# DayZ 模组开发调试工具

本仓库用于在本地快速开发与调试 DayZ 客户端/服务端模组，提供统一的目录结构与脚本。

## 项目结构
```text
DayZDevelopmentTool/
├── .vscode/                      # VS Code 调试配置
│   ├── launch.json
│   ├── settings.json
│   └── tasks.json
├── bin/                          # 第三方可执行文件（PBO 打包）
│   ├── PBOConsole.exe
│   └── PBOLib.DLL
├── build/                        # 构建输出（开发态）
│   ├── @ClientMod/
│   │   └── Addons/               # 客户端模组 pbo 输出
│   └── @ServerMod/
│       └── Addons/               # 服务端模组 pbo 输出
├── data/                         # 模组与地图任务资源
│   ├── Battleye/                 # Battleye 配置（启动时自动映射，无需手动创建）
│   ├── Mod/
│   │   ├── client/
│   │   └── server/
│   ├── Profiles/                 # Profile 文件夹
│   │   ├── client/
│   │   └── server/
│   └── Mpmissions/               # 地图任务（启动时自动映射，无需手动创建）
│       ├── dayzOffline.chernarusplus/
│       ├── dayzOffline.enoch/
│       └── dayzOffline.sakhal/
├── src/                          # 模组源代码
│   ├── CLIENT_MOD/               # 客户端模组源代码
│   └── SERVER_MOD/               # 服务端模组源代码
├── config.json                   # 项目配置
├── killAll.ps1                   # 终止所有 DayZ 相关进程
└── run.ps1                       # 启动 DayZServer 与 DayZ 客户端
```

## 环境准备
- 安装完整的 `DayZ` 与 `DayZServer`，并确保 `DayZServer` 中包含 `mpmissions` 文件夹。
- 使用 SteamCMD 安装的 `DayZServer` 默认不会包含 `mpmissions`；需从官方仓库下载并放入 `DayZServer/mpmissions`：
  - 仓库地址：[BohemiaInteractive/DayZ-Central-Economy](https://github.com/BohemiaInteractive/DayZ-Central-Economy)
  - 下载官方三张地图任务并置于 `DayZServer/mpmissions`（重要）。

## 配置
- 克隆路径不要包含中文、空格或连字符（`-`）。
- 编辑 `config.json`，设置本地 `DayZ` 与 `DayZServer` 的安装路径；同样不要使用中文、空格或连字符（`-`）。

## 添加模组
- 客户端模组：将第三方模组（如 `@CF`）复制到 `./data/Mod/client/`。
- 服务端模组：将服务端模组复制到 `./data/Mod/server/`。

## 构建与运行
- 在 VS Code 中按 `F5` 运行 `run.ps1`，脚本会自动构建模组到 `./build/`。
- 本项目仅用于测试，打包的 `pbo` 文件未签名；不建议在生产环境使用。
- 生产发布请使用官方 DayZTools 进行打包签名后分发。

## 注意事项
- 测试环境请勿启用模组验证；默认的 `serverDZ.cfg` 已关闭模组验证。
- 切换地图任务无需修改 `serverDZ.cfg`，在 VS Code 调试面板中选择对应调试任务即可。
- 若需新增地图任务以调试：
  - 按照现有格式编辑 `./.vscode/launch.json` 添加调试条目。
  - 将对应地图任务文件放置于 `./data/Mpmissions/`。
