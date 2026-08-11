# 命名空间系统

## 概述

DTBKit 的核心机制。通过在现有类型上添加 `.dtb` 命名空间，在不污染全局命名空间的前提下为任意类型添加扩展方法。

## 核心类型

### DTB

```swift
public enum DTB {}
```

静态命名空间根。所有全局配置、工具入口、Provider 注册点都挂载在 `DTB` 枚举下。

### Kitable — 引用类型协议

```swift
public protocol Kitable: AnyObject {}
```

任何遵守 `Kitable` 的**引用类型**自动获得实例和静态命名空间。

```swift
// UIKit 类型默认遵守
extension NSObject: Kitable {}  // → 所有 UIView/UIViewController 均可使用

// 实例访问
UIView().dtb           // → Wrapper<UIView>
// 静态访问
UIView.dtb             // → StaticWrapper<UIView>
```

### Structable — 值类型协议

```swift
public protocol Structable {}
```

用法与 Kitable 一致，但用于值类型。

```swift
extension Int: Structable {}
extension String: Structable {}
extension Array: Structable {}
extension CGFloat: Structable {}
extension Data: Structable {}
// ... 等等

// 实例访问
"hello".dtb            // → Wrapper<String>
// 静态访问
Int.dtb                // → StaticWrapper<Int>
```

### Wrapper\<Base\> — 实例包装器

```swift
@dynamicMemberLookup
public struct Wrapper<Base> {
    public let me: Base
    public var value: Base { return me }
}
```

- `me` — 被包装的原始对象
- `value` — 拆箱，返回原始对象
- `@dynamicMemberLookup` — 支持通过 keyPath 直接设置属性

### StaticWrapper\<T\> — 静态包装器

```swift
public struct StaticWrapper<T> {
    public init() {}
}
```

仅作为静态方法的挂载点。本身不持有实例，通常配合 `create` 用于链式创建。

## 自定义命名空间

如果你希望某个模块的方法只在该模块可见，可以定义自己的命名空间关键字：

```swift
// 在模块 B 中定义
extension Wrapper where Base: UIView {
    public func testB() { /* ... */ }
}

// 使用时
UIView().dtb.testB()  // 总是可以访问（dtb 是全局命名空间）
```

如果你想要模块隔离（未导入 B 则无法调用 `testB`），需要使用自定义 wrapper 类型，具体见 `concepts/provider.md` 中的高级用法。

## 关键理解

1. `.dtb` 返回 Wrapper，`Wrapper.value` 返回原始对象
2. 大部分方法返回 `Self`（即 Wrapper），支持链式调用
3. 引用类型用 `Kitable`，值类型用 `Structable`
4. Swift 原生类型（Int, String, Array...）默认已实现 Structable
5. UIKit 类型通过 `NSObject: Kitable` 默认获得命名空间

## 关联
- [[chain]] — 链式语法在此基础上构建
- [[provider]] — Provider 系统使用 ConstKey 注册
