# Factory — 系统类型构造入口

> 源码: `Sources/Basic/Factory/` | 依赖: Core

为 Foundation / CoreGraphics / UIKit 的值类型提供 `.dtb` 接入与构造入口。

## DTB.Structable conformance

```swift
extension CGSize: DTB.Structable {}
extension CGRect: DTB.Structable {}
extension Date: DTB.Structable {}
extension NSRange: DTB.Structable {}
extension UIEdgeInsets: DTB.Structable {}
```

`DTB.Structable` 协议定义在 Core；没有这组 conformance，上述类型无法使用 `.dtb`。

## 构造入口（callAsFunction）

```swift
UIEdgeInsets.dtb(1, 2, 3, 4)
UIEdgeInsets.dtb(all: 8)
UIEdgeInsets.dtb(horizontal: 12, vertical: 8)

CGSize.dtb(320, 480)
CGSize.dtb(square: 8)
CGSize.dtb(width: 320, height: 480)

CGRect.dtb(0, 0, 100, 50)
CGRect.dtb(x: 0, y: 0, width: 100, height: 50)

NSRange.dtb(0, 10)

Date.dtb(s: 1764000000)
Date.dtb(ms: 1764000000000)
```

重载约束见 `CLAUDE.md` 的「便捷初始化与重载规范」：位置参数重载必须全参数、同参数个数不并存可隐式互转的类型、语义不同用标签区分。

## 已移除

原 `DTBKit/Chain` 模块已删除：

- UIKit / QuartzCore 的属性链式 setter → 由 `DTB.Wrapper` 的 `@dynamicMemberLookup` 承担
- `Chainable` / `StructChainable` / `MutableWrapper` / `when` → 无消费者，已删除
- 属性字典构建 → 由 `DTB.AttributedStyle`（Basic）承担
