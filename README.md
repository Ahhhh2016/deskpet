# DeskPet 小八版 — AI 桌宠

<div align="center">
  <img src="https://github.com/user-attachments/assets/68136ceb-f19a-4691-8d84-20a885957150" height="300"/>
  <img src="https://github.com/user-attachments/assets/3fc7412d-94f0-4ef0-ba06-713dc23927fe" height="300"/>
</div>


## ✨ 功能

- 💬 **对话功能**：点击宠物旁边的 💬 图标即可进入 AI 聊天模式（使用 qwen-plus 模型）
- 📚 **学习模式**：宠物进入读书动画并可开启番茄钟专注计时器
- 💤 **睡眠机制**：长时间未交互时进入睡眠动画
- 🐭 **鼠标交互**：左键点击唤醒，右键拖动移动宠物位置
- ⚙️ **设置面板**：设置 API Key，开启/关闭静音等功能
- 🔊 **语音提示**：内置问候和告别音效，可在设置中静音


## 🧩 技术栈

- 🎮 引擎：Godot 4.x（GDScript）
- 🎞️ 动画：AnimatedSprite2D
- 🌐 API 通信：通过 AIChat 节点发送 API 请求
- 💾 配置存储：使用 ConfigFile 持久化存储 API Key 与静音设置

📺 **API 请求与鼠标穿透的实现详解**：[视频链接](https://www.bilibili.com/video/BV1St34zMEkF/)



## 🚀 启动与配置

📺 完整安装与使用教程请看：[视频链接](https://www.bilibili.com/video/BV1No79zdEt5/)

- 直接下载 `deskpet-seiko-1.0.dmg` 文件运行
- 如果提示“无法打开xxx，因为Apple无法检查其是否包含恶意软件”，请前往系统设置中手动选择“仍要打开”

⚠️ **首次配置 API Key 后需要重启程序才能生效**



## 🔧 TODO

- [ ] 支持多模型
- [ ] 支持番茄钟调节专注时长
- [ ] 修复 Windows 读取配置失败问题（导出后无法读取 config 文件）
- [ ] Windows 多边形外区域渲染异常（需重绘 Polygon2D）



## ❤️ 鸣谢

- 图像素材来源：[十口木木 Seiko](https://space.bilibili.com/572948)


---

# DeskPet Seiko — AI Desktop Pet Built with Godot

## ✨ Features

- 💬 **AI Chat Mode**: Click the 💬 button beside the pet to chat using the qwen-plus model
- 📚 **Study Mode**: The pet reads a book while a Pomodoro-style focus timer runs
- 💤 **Sleep Behavior**: The pet falls asleep after a period of inactivity
- 🐭 **Mouse Interaction**: Left-click to wake, right-click to drag the pet anywhere
- ⚙️ **Settings Panel**: Configure API key, mute/unmute sounds, and other preferences
- 🔊 **Voice Prompts**: Includes greeting and farewell sound effects (mute available)



## 🧩 Tech Stack

- 🎮 Engine: Godot 4.x (GDScript)
- 🎞️ Animation: `AnimatedSprite2D`
- 🌐 API Requests: Custom `AIChat` node
- 💾 Config Storage: Uses `ConfigFile` to persist API key and mute settings

📺 **Tutorial on API & mouse passthrough (Chinese)**: [Bilibili Video](https://www.bilibili.com/video/BV1St34zMEkF/)



## 🚀 Getting Started

📺 Full setup walkthrough (in Chinese): [Bilibili Link](https://www.bilibili.com/video/BV1No79zdEt5/)

- Download and run `deskpet-seiko-1.0.dmg`
- If macOS shows “Cannot open xxx because Apple cannot check it for malware,” go to system settings and choose “Open Anyway”

⚠️ **You must restart the app after setting the API key for the first time**



## 🔧 TODO

- [ ] Support multiple AI models
- [ ] Adjustable Pomodoro session durations
- [ ] Fix config file path issues on Windows (currently fails to run)
- [ ] Fix polygon mask rendering on Windows



## ❤️ Credits

- Art assets by: [十口木木 Seiko](https://space.bilibili.com/572948)
