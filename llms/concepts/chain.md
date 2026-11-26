# 链式语法

## 实例链式（`@dynamicMemberLookup`）

`Wrapper` 对引用类型提供 keyPath 写入，方法的返回值仍是 `Wrapper`，可连续调用：

```swift
UIView().dtb
    .backgroundColor(.white)
    .isHidden(false)
    .value

UIImageView().dtb
    .image(image)
    .tintColor(.red)
    .contentMode(.scaleAspectFill)
    .value

UILabel().dtb
    .text("hello")
    .font(.systemFont(ofSize: 13))
    .textColor(.black)
    .value
```

实现位于 Core 的 `Wrapper`：

```swift
extension Wrapper where Base: AnyObject {
    public subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<Base, Value>)
        -> ((Value) -> Wrapper<Base>)
}
```

因此不需要为每个属性单独写链式方法；`DTBKit/Chain` 已删除。

## 值类型构造（`callAsFunction`）

值类型没有 keyPath 写入能力，改用构造入口：

```swift
UIEdgeInsets.dtb(all: 8)
CGSize.dtb(320, 480)
Date.dtb(s: 1764000000)
```

详见 [[../modules/factory]]。

## 已删除

- `Chainable` / `StructChainable` / `def_()`
- `MutableWrapper` 与 `StaticWrapper.create`
- 属性字典构建（`.dtb.create.font(...)`）→ 改用 `DTB.AttributedStyle`

## 关联

- [[namespace]] — 链式语法基于命名空间系统
- [[../modules/factory]] — 系统类型构造入口
