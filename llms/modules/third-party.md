# 第三方库集成

> subspec: `DTBKit/Kingfisher` `DTBKit/SDWebImage` `DTBKit/ObjectMapper`

## Kingfisher

> subspec: `DTBKit/Kingfisher` | 依赖: Theme + Kingfisher

### 概述

将 Kingfisher 的图片加载能力整合到 DTBKit 的 Theme/Image Provider 体系中。

### Provider 实现

| Provider | 说明 |
|----------|------|
| `KFRemoteImageProvider` | 实现 RemoteImageProvider 协议 |
| `KFImageViewSetImageProvider` | ImageView 设置图片 |
| `KFButtonSetImageProvider` | Button 设置图片 |
| `KFCacheProvider` | 缓存管理 |

### 使用

```swift
// 注册 Kingfisher 作为远程图片 Provider
DTB.Providers.register(KFRemoteImageProvider(), key: ...)

// 之后通过 Theme 模块的图片接口即可使用 Kingfisher 加载
imageView.dtb.setImage(key: "https://...")
```

## SDWebImage

> subspec: `DTBKit/SDWebImage` | 依赖: Theme + SDWebImage

### 概述

与 Kingfisher 模块镜像设计，将 SDWebImage 整合到 DTBKit 体系中。

### Provider 实现

| Provider | 说明 |
|----------|------|
| `SDRemoteImageProvider` | 实现 RemoteImageProvider 协议 |
| `SDImageViewSetImageProvider` | ImageView 设置图片 |
| `SDButtonSetImageProvider` | Button 设置图片 |
| `SDCacheProvider` | 缓存管理 |

### 使用

```swift
DTB.Providers.register(SDRemoteImageProvider(), key: ...)
imageView.dtb.setImage(key: "https://...")
```

## ObjectMapper

> subspec: `DTBKit/ObjectMapper` | 依赖: Core + ObjectMapper

### 概述

为 ObjectMapper 提供自定义的 Transform 扩展。

### DTBObjectMapperTransforms

```swift
// 自定义映射转换器
// 扩展了 ObjectMapper 的 TransformType
```

## 注意

- Kingfisher 和 SDWebImage 二选一即可，它们实现了相同的协议
- ObjectMapper 模块独立，不依赖 Theme 系统
- 这些模块本身代码量很小，主要是适配层

## 关联
- [[theme]] — 图片 Provider 协议的来源
- [[../concepts/provider]] — 使用 Provider 模式注册
