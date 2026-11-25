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
DTB.any        // → AnyConvert，Any 安全转换
```

三个入口都定义在 `DTBKit+Core.swift` 中。其他模块会向 `DTB` 添加更多静态入口。

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

### AnyConvert（DTB.any）

从 `Any?` 安全转换为具体类型。多形态输入：整数 / 浮点 / `String` / `NSNumber`，失败返回 `nil`。

```swift
DTB.any.int64(value)          // → Int64?
DTB.any.int(value)            // → Int?
DTB.any.double(value)         // → Double?
DTB.any.cgFloat(value)        // → CGFloat?
```

`uiEdgeInsets` / `cgSize` / `cgVector` 在 Theme 模块以扩展提供，调用方式相同。

### OptionalCheckable / NumberCheckable

对象的「空」与数字的「无效」是两个概念，协议只承诺「能判断可用性 + 有默认值」：

```swift
public protocol OptionalCheckable {
    static func dtb_defaultValue() -> Self   // nil / 无效时的值
    func dtb_isInvalid() -> Bool             // 非 nil 前提下是否不可用
}

public protocol NumberCheckable: OptionalCheckable {
    func dtb_isZero() -> Bool
    func dtb_isPositive() -> Bool
    func dtb_isNegative() -> Bool
}
```

| 类型 | `dtb_isInvalid()` | `dtb_defaultValue()` |
|---|---|---|
| `String` / `Array` / `Dictionary` / `Set` | `isEmpty` | `""` / `[]` / `[:]` |
| `Int` / `Int8` … `Int64` | 恒 `false`（只有 nil 缺失） | `0` |
| `Float` / `Double` | `!isFinite`（NaN / inf） | `0` |

### Optional 扩展

兜底与判定直接挂在 `Optional` 上，统一 `dtb_` 前缀：

```swift
let a: String? = nil
a.dtb_or()                  // ""（nil / 无效 → 默认值）
a.dtb_or("兜底")            // 显式兜底
a.dtb_isInvalid()           // nil / 无效 → true
a.dtb_isValid()             // 非 nil 且有效 → true

// 数字
let d: Double? = .nan
d.dtb_isInvalidOrZero()     // nil / 无效 / 0
d.dtb_isPositive()          // 有效且 > 0
d.dtb_isNegative()          // 有效且 < 0
```

与 `DTB.any` 组合：

```swift
DTB.any.int64(dict["width"]).dtb_or()   // Int64
```

> 为什么没有 `a?.dtb.dtb_or()`：`?` 之后整条链恒为 `Optional`，成员查找落在 `Wrapper` 上，
> 只有已成型的 `Optional` 能命中扩展。

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
