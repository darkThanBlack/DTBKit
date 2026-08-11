# Theme — 样式系统

> subspec: `DTBKit/Theme` | 源码: `Sources/Theme/Styles/`

## 概述

在颜色/字体/国际化基础上，Theme 模块提供了一套 UI 样式系统，用于统一管理按钮、文本、容器等 UI 元素的外观。

## 核心协议

### StylesProvider

```swift
public protocol StylesProvider {
    // 获取指定类型的默认样式
}
```

注册方式：
```swift
DTB.Providers.register(DTB.DefaultStylesProvider(), key: DTB.Providers.stylesKey)
```

## 样式类型

### ButtonStyle

按钮的外观配置（背景色、圆角、边框、字体、间距等）。

### TextStyle

文本标签的外观配置（字体、颜色、行间距、对齐方式等）。

### ContainerStyle

容器视图的外观配置（margin, padding, backgroundColor, shape, gradient）。

**创建方式**：

```swift
// 从 Provider 或字典解析（推荐）
let style = DTB.ContainerStyle.style(someParam)
// 优先走 StylesProvider.createContainerStyle(_:)，fallback 到 [String: Any] 字典解析

// 从字典解析
let style = DTB.ContainerStyle(dict: ["margin": ..., "padding": ...])

// 直接构造
let style = DTB.ContainerStyle(
    margin: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16),
    padding: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16),
    backgroundColor: .white,
    shape: DTB.ShapeStyle(...),
    gradient: DTB.GradientStyle(...)
)
```

**已废弃**: `singleCard()` 和 `listCard(_:)` 静态方法已移除。卡片样式应通过 JSON 配置文件（如 `container_style.json`）+ `StylesProvider` 管理，而非硬编码在源码中。

### ShapeStyle / CornerRadiusStyle

形状和圆角配置。

### GradientStyle

渐变背景配置。

### DirectionStyle（EightDirection / FourDirection）

> 源码: `Sources/Theme/Styles/DirectionStyle.swift`，原位于 `Sources/UIKit/DTBKit+UI.swift`

方向枚举，从 UIKit 层迁入 Theme/Styles：

```swift
// 顺时针入方向
DTB.EightDirection.right       // 右
DTB.EightDirection.bottomRight
DTB.EightDirection.bottom
DTB.EightDirection.bottomLeft
DTB.EightDirection.left
DTB.EightDirection.topLeft
DTB.EightDirection.top
DTB.EightDirection.topRight

// 四方向（与 UIEdgeInsets 一致）
DTB.FourDirection.top
DTB.FourDirection.left
DTB.FourDirection.bottom
DTB.FourDirection.right
```

## 使用方式

```swift
// 通过样式配置 UI 组件
button.dtb.apply(ButtonStyle.primary)
label.dtb.apply(TextStyle.heading)
container.dtb.apply(ContainerStyle.card)
```

## ThemeConfigFile

主题可以从配置文件加载：

```swift
// Theme/Theme/ThemeConfigFile.swift
// 支持 JSON 或 plist 格式的主题配置
```

## SportTheme 资源包

```swift
pod 'DTBKit/SportTheme'
```

提供一套默认的运动主题资源（颜色、图标、TabBar 图片等）。位于 `Sources/Resources/SportTheme/`。

## 关联
- [[theme]] — 颜色/字体/国际化基础
- [[uikit]] — UIKit 组件使用了样式系统
