# DeskPet Seiko — AI 桌宠小八版

**An AI Desktop Pet Built with Godot Engine (Seiko Edition)**

<div align="center">
  <img src="https://github.com/user-attachments/assets/68136ceb-f19a-4691-8d84-20a885957150" height="300"/>
  <img src="https://github.com/user-attachments/assets/3fc7412d-94f0-4ef0-ba06-713dc23927fe" height="300"/>
</div>

---

## ✨ 功能 Features

* 💬 **对话功能**：点击宠物旁边的 💬 图标即可进入 AI 聊天模式（使用 qwen-plus 模型）
* 💬 **AI Chat Mode**: Click the 💬 button beside the pet to chat with it via the qwen-plus model

* 📚 **学习模式**：宠物进入读书动画并可开启番茄钟专注计时器
* 📚*Study Mode**: The pet shows a reading animation and activates a Pomodoro-style focus timer

* 💤 **睡眠机制**：长时间未交互时进入睡眠动画
* 💤 **Sleep Behavior**: The pet falls asleep after a period of inactivity

* 🐭 **鼠标交互**：左键点击唤醒，右键拖动移动宠物位置
* 🐭 **Mouse Interaction**: Left click to wake the pet, right click to drag it anywhere

* ⚙️ **设置面板**：设置 API Key，开启/关闭静音等功能
* ⚙️ **Settings Panel**: Set your API key, toggle mute, and other preferences

* 🔊 **语音提示**：内置问候和告别音效，可在设置中静音
* 🔊 **Voice Prompts**: Built-in sound effects for greetings and farewells (mute available)

---

## 🧩 技术栈 Tech Stack

* 🎮 **引擎 / Engine**: Godot 4.x (GDScript)
* 🎞️ **动画 / Animation**: `AnimatedSprite2D`
* 🌐 **API 通信 / API Requests**: Custom `AIChat` node for sending messages
* 💾 **配置存储 / Config Storage**: `ConfigFile` used to persist API key and mute settings

📺 **API 请求与鼠标穿透的实现详解**：[视频教程](https://www.bilibili.com/video/BV1St34zMEkF/)
📺 **Tutorial on API and mouse passthrough (in Chinese)**: [Bilibili Video](https://www.bilibili.com/video/BV1St34zMEkF/)

---

## 🚀 启动与配置 Getting Started

📺 完整安装与使用教程请看：[视频链接](https://www.bilibili.com/video/BV1No79zdEt5/)
📺 Full setup tutorial (in Chinese): [Video Link](https://www.bilibili.com/video/BV1No79zdEt5/)

可以直接下载deskpet-seiko-1.0.dmg文件运行
You can directly download the deskpet-seiko-1.0.dmg file and run it.
如果报错“无法打开xxx，因为Apple无法检查其是否包含恶意软件“，需要在设置中选择“仍要打开”
If the error message "Cannot open xxx because Apple cannot check whether it contains malware" is displayed, you need to select "Open anyway" in the settings

⚠️ **首次配置 API Key 后需要重启程序才能生效**
⚠️ **You must restart the app after setting the API key for the first time**

---

## 🔧 TODO

* [ ] 支持多模型
  Support multiple AI models
* [ ] 支持番茄钟调节专注时长
  Adjustable Pomodoro session durations
* [ ] 修复 Windows 读取配置失败问题（导出后无法读取 config 文件）
  Fix config file path issues on Windows (currently fails to run)
* [ ] Windows 多边形外区域渲染异常（需重绘 Polygon2D）
  Rendering issues outside polygon mask on Windows (needs fix)

---

## ❤️ 鸣谢 Credits

* 图像素材来源 / Art assets: [十口木木 Seiko](https://space.bilibili.com/572948)


