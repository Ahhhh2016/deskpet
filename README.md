# 🐾 DeskPet Seiko — AI 桌宠小八版

![image](https://github.com/user-attachments/assets/68136ceb-f19a-4691-8d84-20a885957150)
![image](https://github.com/user-attachments/assets/3fc7412d-94f0-4ef0-ba06-713dc23927fe)


## ✨ 功能 Features

* 💬 **对话功能**：点击宠物旁边的💬即可进入 AI 聊天模式（使用qwen-plus模型）
* 📚 **学习模式**：宠物进入读书动画并可开启番茄钟专注计时器
* 💤 **睡眠机制**：长时间未交互时进入睡眠动画
* 🐭 **鼠标交互**：左键点击唤醒、右键拖动随意移动位置
* ⚙️ **设置面板**：支持设置 API Key、开启/关闭静音等
* 🔊 **语音**：自带打招呼、告别等音效，可静音切换

## 🧩 技术栈 Tech Stack

* **引擎**：Godot 4.x (GDScript)
* **动画**：AnimatedSprite2D
* **网络请求**：通过 AIChat 节点发送 API 请求
* **持久化配置**：使用 `ConfigFile` 存储用户设置（API Key、静音状态等）

如何实现API请求和鼠标穿透请看[视频](https://www.bilibili.com/video/BV1St34zMEkF/)

## 🚀 启动和配置方式 Getting Started

详细教程请看[视频](https://www.bilibili.com/video/BV1No79zdEt5/)

第一次配置apikey后需要退出后重新打开


## 🔧 TODO

* [ ] 支持多模型
* [ ] 支持番茄钟调节专注时长
* [ ] windows配置文件位置读不到，所以导出的win版本无法运行，现在手头没有win没法测orz
* [ ] windows多边形外的区域无法渲染，需要重新绘制多边形


## ❤️ 鸣谢

* 图像素材来源：[十口木木Seiko](https://space.bilibili.com/572948)
