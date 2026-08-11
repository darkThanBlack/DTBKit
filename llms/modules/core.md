# Core 模块

> subspec: `DTBKit/Core` | 源码: `Sources/Core/` | 依赖: 无

## 概述

Core 是 DTBKit 的最底层模块，定义了命名空间系统、Wrapper 类型和基础设施。所有其他模块都依赖 Core。

## 核心类型

### DTB 枚举

```swift
public enum DTB {}

// 全局入口
DTB.app        // → AppManager，内存字典 + 应用信息
DTB.console    // → ConsoleManager，日志打印
```

`DTB.app` 和 `DTB.console` 定义在 `DTBKit+Core.swift` 中。其他模块会向 `DTB` 添加更多静态入口。

### Wrapper / StaticWrapper

```swift
Wrapper<Base>        // 实例包装器，通过 object.dtb 获取
StaticWrapper<T>     // 静态包装器，通过 Type.dtb 获取
```

详见 [[../concepts/namespace]]。

### ConstKey\<T\>

```swift
public struct ConstKey<T> {
    public let key_: String       // 唯一标识符（UUID）
    public let useLock_: Bool     // 是否线程安全，默认 true
}
```

Provider 注册的键。泛型参数 `T` 保证类型安全。

```swift
// 创建
let key = DTB.ConstKey<MyProtocol>()

// 作为 Provider Key（通常定义为静态常量）
extension DTB.Providers {
    public static let hudKey = DTB.ConstKey<HUDProvider>()
}
```

### Notifications

```swift
extension DTB {
    public enum Notifications {
        // 各模块在此扩展通知名称
    }
}
```

### AppManager

```swift
public final class AppManager {
    public static let shared = AppManager()
    
    // 存储
    func set<T>(_ value: T?, key: ConstKey<T>)
    func get<T>(_ key: ConstKey<T>) -> T?
    
    // 版本号 (CFBundleShortVersionString)
    var version: String { get }
    // 构建号 (CFBundleVersion)
    var build: String { get }
    // 调试模式判断
    func isDebug() -> Bool
}
```

线程安全的内存 KV 存储。底层是 `[String: Any]` 字典 + 信号量锁。

### ConsoleManager

```swift
public final class ConsoleManager {
    public static let shared = ConsoleManager()
    
    func log(_ items: Any..., separator: String = " ", terminator: String = "\n")
    func dump(_ items: Any..., separator: String = " ", terminator: String = "\n")
}
```

`print` 的替代品。debug 模式下输出，release 模式静默。

### Weaker

弱引用包装器，用于集合中持有弱引用对象。

```swift
public struct Weaker<T: AnyObject> {
    public weak var object: T?
}
```

## 使用示例

```swift
// 存储自定义数据
let key = DTB.ConstKey<String>()
DTB.app.set("hello", key: key)
let value: String? = DTB.app.get(key)

// 日志（仅在 debug 模式下输出）
DTB.console.log("当前版本:", DTB.app.version)

// Provider 注册
DTB.Providers.register(myProvider, key: DTB.Providers.hudKey)
let provider = DTB.Providers.get(DTB.Providers.hudKey)
```

## 关联
- [[../concepts/namespace]] — 命名空间系统详细说明
- [[../concepts/provider]] — Provider 机制详细说明
