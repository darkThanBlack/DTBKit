# 命名空间系统

## 概述

DTBKit 的核心机制。通过在现有类型上添加 `.dtb` 命名空间，在不污染全局命名空间的前提下为任意类型添加扩展方法。

## 核心类型

所有核心类型都嵌套在 `DTB` 下。

### DTB

```swift
public enum DTB {}
```

静态命名空间根。`DTB.Wrapper`、`DTB.StaticWrapper`、`DTB.Kitable`、`DTB.Structable` 以及所有全局配置、Provider 注册点都挂载在 `DTB` 下。

### DTB.Kitable — 引用类型协议

```swift
extension DTB {
    public protocol DTB.Kitable: AnyObject {}
}
```

任何遵守 `DTB.Kitable` 的**引用类型**自动获得实例和静态命名空间。

```swift
// UIKit 类型默认遵守
extension NSObject: DTB.Kitable {}  // → 所有 UIView/UIViewController 均可使用

// 实例访问
UIView().dtb           // → DTB.Wrapper<UIView>
// 静态访问
UIView.dtb             // → DTB.StaticWrapper<UIView>
```

### DTB.Structable — 值类型协议

```swift
extension DTB {
    public protocol DTB.Structable {}
}
```

用法与 `DTB.Kitable` 一致，但用于值类型。

```swift
extension Int: DTB.Structable {}
extension String: DTB.Structable {}
extension Array: DTB.Structable {}
extension CGFloat: DTB.Structable {}
extension Data: DTB.Structable {}

// 实例访问
"hello".dtb            // → DTB.Wrapper<String>
// 静态访问
Int.dtb                // → DTB.StaticWrapper<Int>
```

### DTB.Wrapper\<Base\> — 实例包装器

```swift
extension DTB {
    @dynamicMemberLookup
    public struct DTB.Wrapper<Base> {
        public let me: Base
        public var value: Base { return me }
    }
}
```

- `me` — 被包装的原始对象
- `value` — 拆箱，返回原始对象
- `@dynamicMemberLookup` — 引用类型可通过 keyPath 直接设置属性

### DTB.StaticWrapper\<T\> — 静态包装器

```swift
extension DTB {
    public struct DTB.StaticWrapper<T> {
        public init() {}
    }
}
```

仅作为静态方法的挂载点，本身不持有实例。`callAsFunction` 工厂挂在这里，例如 `UIEdgeInsets.dtb(all: 8)`。

## 自定义命名空间

如果你希望某个模块的方法只在该模块可见，可以定义自己的命名空间关键字：

```swift
extension DTB.Wrapper where Base: UIView {
    public func testB() { }
}

UIView().dtb.testB()
```

如果你想要模块隔离（未导入 B 则无法调用 `testB`），需要使用自定义 wrapper 类型，具体见 `concepts/provider.md` 中的高级用法。

## 关键理解

1. `.dtb` 返回 `DTB.Wrapper`，`DTB.Wrapper.value` 返回原始对象
2. 大部分方法返回 `Self`（即 `DTB.Wrapper`），支持链式调用
3. 引用类型用 `DTB.Kitable`，值类型用 `DTB.Structable`
4. Swift 原生类型（Int, String, Array...）默认已实现 `DTB.Structable`
5. UIKit 类型通过 `NSObject: DTB.Kitable` 默认获得命名空间

## 关联
- [[chain]] — 链式语法在此基础上构建
- [[provider]] — Provider 系统使用 ConstKey 注册
