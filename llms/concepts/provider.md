# Provider 依赖注入

## 概述

DTBKit 中一些功能（HUD、Toast、Alert、主题、国际化等）采用 Provider 模式。框架只定义**接口规范**，实际实现由调用方注册。这允许完全替换默认行为而不修改框架代码。

## 核心类型

### DTB.Providers

```swift
extension DTB {
    public enum Providers {
        public static func register<T>(_ value: T?, key: DTB.ConstKey<T>)
        public static func unregister<T>(_ key: DTB.ConstKey<T>)
        public static func get<T>(_ key: DTB.ConstKey<T>) -> T?
    }
}
```

### ConstKey\<T\>

```swift
// 无参构造：自动生成唯一标识
let key = DTB.ConstKey<SomeProviderProtocol>()

// 属性
key.key_       // → String，唯一标识符
key.useLock_   // → Bool，是否使用锁（线程安全）
```

类型安全的注册键。每个 Provider 类型有对应的 `ConstKey`，定义在各自模块中。

### AppManager

Provider 的底层存储依赖 `DTB.app`（AppManager），本质是一个线程安全的内存字典。

```swift
DTB.app.set(value, key: key)   // 写入
DTB.app.get(key)                // 读取，返回 T?
DTB.app.set(nil, key: key)     // 移除
```

## 注册模式

### 标准流程

```swift
// 1. 选择合适的时机注册（通常在 AppDelegate 中）
func application(_ application: UIApplication, didFinishLaunchingWithOptions ...) -> Bool {
    // 注册默认实现（或自定义实现）
    DTB.Providers.register(DTB.DefaultHUDProvider(), key: DTB.Providers.hudKey)
    DTB.Providers.register(DTB.DefaultToastProvider(), key: DTB.Providers.toastKey)
    DTB.Providers.register(DTB.DefaultAlertProvider(), key: DTB.Providers.alertKey)
    DTB.Providers.register(DTB.ColorManager.shared, key: DTB.Providers.colorKey)
    DTB.Providers.register(DTB.I18NManager.shared, key: DTB.Providers.stringKey)
    DTB.Providers.register(DTB.FontManager.shared, key: DTB.Providers.fontKey)
    
    // Window/Scene 相关
    DTB.Providers.register(DTB.DefaultWindowProvider(window), key: DTB.Providers.windowKey)
    if #available(iOS 13.0, *) {
        DTB.Providers.register(DTB.DefaultSceneProvider(), key: DTB.Providers.sceneKey)
    }
}
```

### 已经注册后替换

```swift
// 直接调用 register 覆盖
DTB.Providers.register(MyCustomHUDProvider(), key: DTB.Providers.hudKey)
// 或先移除
DTB.Providers.unregister(DTB.Providers.hudKey)
```

### 运行时获取

```swift
// 框架内部通过 get 获取已注册的 Provider
if let hudProvider = DTB.Providers.get(DTB.Providers.hudKey) {
    hudProvider.show(message: "加载中...")
}
```

## 已有 Provider Key 清单

| Key | 类型 | 所在模块 | 说明 |
|-----|------|----------|------|
| `Providers.windowKey` | `WindowProvider` | UIKit | 窗口提供者（获取 keyWindow） |
| `Providers.sceneKey` | `SceneProvider` | UIKit | Scene 提供者（iOS 13+） |
| `Providers.hudKey` | `HUDProvider` | UIKit | 加载指示器 |
| `Providers.toastKey` | `ToastProvider` | UIKit | Toast 提示 |
| `Providers.alertKey` | `AlertProvider` | UIKit | 弹窗 |
| `Providers.colorKey` | `ColorProvider` | Theme | 颜色主题 |
| `Providers.stringKey` | `StringProvider` | Theme | 国际化字符串 |
| `Providers.fontKey` | `FontProvider` | Theme | 字体主题 |
| `Providers.stylesKey` | `StylesProvider` | Theme | UI 样式 |
| — | `LocalImageProvider` | Theme | 本地图片 |
| — | `RemoteImageProvider` | Theme | 远程图片 |

## 关键理解

1. Provider 存储是单例的、内存级的，不会持久化
2. 必须在**使用功能之前**完成注册（通常在 AppDelegate 的 `didFinishLaunching` 中）
3. 未注册的 Provider 不会导致崩溃，但对应功能将无操作
4. `ConstKey` 的类型参数保证类型安全

## 关联
- [[namespace]] — Provider 通过 ConstKey + AppManager 实现
- [[../modules/uikit-system]] — Alert/HUD/Toast 的 Provider 细节
- [[../modules/theme]] — Theme 模块的 Provider 细节
