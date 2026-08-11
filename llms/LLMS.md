# DTBKit — LLM 调用指南

> **源码基准**: `1d2d540` — 本文档基于此 commit 的 `Sources/` 生成。
> 更新时以 `git diff <此commit>..HEAD -- Sources/` 找出变更，只改受影响的文件，然后更新此处的 commit。

## 这是什么

DTBKit 是一个 Swift iOS 工具包，核心设计理念：

1. **命名空间隔离**：所有扩展通过 `.dtb` 访问，不污染全局命名空间
2. **链式 API**：支持流畅的方法链配置对象
3. **Provider 模式**：通过依赖注入实现可替换的行为

## 核心约定

阅读本文档前，先理解以下固定模式。本文档所有 API 均遵循这些约定，不再逐处解释。

### 访问入口

```swift
// 实例扩展 — 任何遵守 Kitable/Structable 的对象
object.dtb.method()

// 静态扩展 — 类级别方法
Type.dtb.method()
```

### 拆箱规则

```swift
// Wrapper<T> — 非可选，用 .value
object.dtb.someProperty(.black).value  // → 原始对象

// Wrapper<T?> — 可选，用 ?.value
data.dtb.string()?.value  // → String?

// 直接返回 — Bool、Void 等不需要解包
string.dtb.isEmpty()  // → Bool
```

### 链式创建

```swift
// 值类型的快速创建，.create 返回 MutableWrapper
CGRect.dtb.create.x(10).y(20).width(100).height(50).value
NSAttributedString.Key.dtb.create.foregroundColor(.black).font(...).value

// 引用类型的链式配置
UILabel().dtb
    .text("hello")
    .backgroundColor(.white)
    .value
```

## 文档结构

```
llms/
├── LLMS.md                    # 本文件，总入口
├── concepts/                  # 核心设计模式（先读这个）
│   ├── namespace.md           #   命名空间系统
│   ├── chain.md               #   链式语法
│   └── provider.md            #   Provider 依赖注入
├── modules/                   # 按 subspec 组织的模块文档
│   ├── overview.md            #   模块依赖图与引入方式
│   ├── core.md                #   Core — DTB.app/console/ConstKey
│   ├── basic.md               #   Basic — Foundation 扩展
│   ├── basic-types.md         #   Basic — 数值/时间/几何/转换
│   ├── basic-utilities.md     #   Basic — 格式化/缓存/可选值/高保真
│   ├── chain.md               #   Chain — UIKit 链式扩展
│   ├── theme.md               #   Theme — 颜色/字体/图片/国际化
│   ├── theme-styles.md        #   Theme — 样式系统
│   ├── uikit.md               #   UIKit — 基础组件与视图
│   ├── uikit-system.md        #   UIKit — Alert/HUD/导航/WebView/Window
│   ├── map.md                 #   Map — 地图扩展
│   └── third-party.md         #   Kingfisher/SDWebImage/ObjectMapper
├── quickref.md                # 按类型快速索引
├── CLAUDE.md                  # DTBKit 开发者工作室（不要读这个来使用框架）
└── ../CLAUDE.md               # 项目级 Claude 配置
```

## 与其他文档的关系

| 文档 | 读者 | 用途 |
|------|------|------|
| `llms/` | LLM（调用方） | 查阅 API 契约和调用模式 |
| `README.md` | 人类开发者 | 项目概览和快速开始 |
| `DTBKit.wiki/` | 人类开发者 | 设计原理和使用指南 |
| Jazzy gh-pages | 人类开发者 | 自动生成的 API 文档 |
| `Example/` | LLM + 人类 | 真实项目中的使用示例 |
| `CLAUDE.md` | LLM（开发方） | DTBKit 框架本身的开发 |

## 使用建议

- 先读 `concepts/namespace.md` 理解命名空间系统
- 根据需要的功能找到对应的 `modules/` 文件
- 遇到不熟悉的类型时查 `quickref.md`
- 想看完整调用示例时参考 `Example/Codes/` 目录
