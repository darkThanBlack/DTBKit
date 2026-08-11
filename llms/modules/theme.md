# Theme — 颜色/字体/图片/国际化

> subspec: `DTBKit/Theme` | 源码: `Sources/Theme/` | 依赖: Core

## 概述

Theme 模块通过 Provider 模式提供可定制的主题系统。调用方注册自定义实现，框架通过统一的接口获取主题资源。

## 子模块

| 子模块 | Provider Key | 说明 |
|--------|-------------|------|
| Color | `Providers.colorKey` | 颜色系统 |
| Font | `Providers.fontKey` | 字体系统 |
| I18N | `Providers.stringKey` | 国际化字符串 |
| Image | `LocalImageProvider` `RemoteImageProvider` | 本地/远程图片 |

## Color — 颜色系统

### ColorProvider 协议

```swift
// 核心协议，定义颜色获取接口
public protocol ColorProvider {
    func color(for key: String) -> UIColor?
}
```

### ColorManager（默认实现）

```swift
DTB.ColorManager.shared   // 默认的颜色管理器
```

注册方式：
```swift
DTB.Providers.register(DTB.ColorManager.shared, key: DTB.Providers.colorKey)
```

### UIColor 实例扩展

```swift
color.dtb.xxx()  // UIColor 的 Theme 相关扩展
```

## Font — 字体系统

### FontProvider 协议

```swift
public protocol FontProvider {
    // 获取指定样式的字体
    func font(for style: FontStyle) -> UIFont
}
```

### FontStyle

```swift
public struct FontStyle {
    // 预定义样式枚举或结构
}
```

### FontManager（默认实现）

```swift
DTB.FontManager.shared
```

注册方式：
```swift
DTB.Providers.register(DTB.FontManager.shared, key: DTB.Providers.fontKey)
```

### UIFont 扩展

```swift
UIFont.dtb.create(10, name: "Lora")          // 创建自定义字体
UIFont.dtb.create("Gloock", size: 13.0, weight: .regular)
```

## I18N — 国际化

### StringProvider 协议

```swift
public protocol StringProvider {
    func string(for key: String) -> String
}
```

### I18NManager（默认实现）

```swift
DTB.I18NManager.shared
```

注册方式：
```swift
DTB.Providers.register(DTB.I18NManager.shared, key: DTB.Providers.stringKey)
```

### String 扩展

```swift
"some_key".dtb.localized()  // → String
```

## Image — 图片管理

### LocalImageProvider

本地图片加载协议。

### RemoteImageProvider

远程图片加载协议，Kingfisher/SDWebImage 模块实现了此协议。

### UIButton / UIImageView / UIImage 扩展

```swift
// 设置图片
button.dtb.setImage(key: "icon_name")
imageView.dtb.setImage(key: "banner")

// UIImage 处理
image.dtb.xxx()
```

## 注册示例

```swift
// AppDelegate 中一次性注册
DTB.Providers.register(DTB.ColorManager.shared, key: DTB.Providers.colorKey)
DTB.Providers.register(DTB.I18NManager.shared, key: DTB.Providers.stringKey)
DTB.Providers.register(DTB.FontManager.shared, key: DTB.Providers.fontKey)
```

## 关联
- [[theme-styles]] — 样式系统（基于 Theme 构建）
- [[../concepts/provider]] — Provider 模式原理
- [[third-party]] — Kingfisher/SDWebImage 实现了远程图片协议
