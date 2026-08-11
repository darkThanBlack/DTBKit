# 链式语法

## 概述

在命名空间系统之上，DTBKit 提供了流畅的方法链语法来配置对象属性。链式方法是普通的 Wrapper 扩展，通过返回 `Self` 实现连续调用。

## 核心协议

### Chainable

```swift
public protocol Chainable {}
```

标记协议，表示该类型支持链式语法。在 DTBKit 内部，链式方法通过 `extension Wrapper where Base: SomeType & Chainable` 约束来限定可用范围。

**建议只让引用类型遵守。** 值类型也可用，但会与 Swift 的 copy-on-write 语义冲突，目前主要通过在静态上下文中使用 `MutableWrapper` 来规避。

### StructChainable

```swift
public protocol StructChainable: Chainable {
    static func def_() -> Self
}
```

值类型的链式协议。继承 `Chainable`，额外要求提供默认构造对象 `def_()`。

## 引用类型链式 — class chain

```swift
extension Wrapper where Base: UIView & Chainable {
    @discardableResult
    public func backgroundColor(_ value: UIColor?) -> Self {
        me.backgroundColor = value
        return self
    }
}
```

**模式**：方法接收属性值 → 设置到 `me` → 返回 `self`

```swift
// 典型用法
UILabel().dtb
    .text("标题")
    .textColor(.black)
    .font(.systemFont(ofSize: 14))
    .backgroundColor(.clear)
    .value
```

### 条件执行

```swift
// when — 条件为 true 时执行闭包
view.dtb
    .when(needShadow) { me in
        me.layer.shadowOpacity = 0.3
    }
    .backgroundColor(.white)
```

## 值类型链式 — struct chain

```swift
// 静态 .create 入口
extension StaticWrapper where T: Structable & StructChainable {
    public var create: MutableWrapper<T> {
        return MutableWrapper(T.def_())
    }
}
```

### MutableWrapper\<Base\>

```swift
public class MutableWrapper<Base> {
    public var me: Base
    public var value: Base { return me }
}
```

值类型的链式配置使用 `MutableWrapper`（class 类型），避免值类型的 copy 问题。

```swift
// 链式创建值类型
let rect = CGRect.dtb.create
    .x(10).y(20)
    .width(100).height(50)
    .value

let attributes: [NSAttributedString.Key: Any] = .dtb.create
    .foregroundColor(.black)
    .font(.systemFont(ofSize: 13))
    .value
```

## 关键理解

1. 链式方法本质是普通函数，返回 `Self` 实现连续调用
2. 引用类型和值类型的链式入口不同：实例方法 `.dtb.xxx()` vs 静态方法 `.dtb.create.xxx()`
3. 值类型链式用 `MutableWrapper`（class）包裹，避免存储中间变量时的 copy 问题
4. `@dynamicMemberLookup` 允许通过 keyPath 设置任意属性（`label.dtb.text("hello")`），无需为每个属性写链式方法，但不推荐过度依赖

## 关联
- [[namespace]] — 链式语法基于命名空间系统
