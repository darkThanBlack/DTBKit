# Chain — 链式扩展

> subspec: `DTBKit/Chain` | 源码: `Sources/Chain/` | 依赖: Core

## 概述

Chain 模块为常用 UIKit/QuartzCore 类型提供链式属性设置方法。功能单一：每个方法对应一个属性，接收值 → 设置 → 返回 Self。

**不需要仔细阅读每个方法**。模式完全一致：

```swift
extension Wrapper where Base: SomeType & Chainable {
    @discardableResult
    public func propertyName(_ value: PropertyType) -> Self {
        me.propertyName = value
        return self
    }
}
```

## 覆盖的 UIKit 类型

### UIView
```swift
view.dtb
    .backgroundColor(.white)
    .alpha(0.5)
    .isHidden(false)
    .tag(100)
    .frame(.zero)
    .bounds(.zero)
    .center(.zero)
    .transform(.identity)
    .clipsToBounds(true)
    .contentMode(.scaleAspectFill)
    .tintColor(.blue)
    // 视图层级
    .addSubview(childView)
    .insertSubview(childView, at: 0)
    .bringSubviewToFront(childView)
    .removeFromSuperview()
    // 布局
    .translatesAutoresizingMaskIntoConstraints(false)
    .setContentHuggingPriority(.required, for: .vertical)
    .layoutIfNeeded()
    // 手势
    .addGestureRecognizer(tapGesture)
    // ... 覆盖 UIView 几乎所有属性
```

### UILabel
```swift
label.dtb
    .text("标题")
    .textColor(.black)
    .font(.systemFont(ofSize: 14))
    .textAlignment(.center)
    .numberOfLines(0)
```

### UIButton
```swift
button.dtb
    .title("按钮", for: .normal)
    .titleColor(.blue, for: .normal)
    .image(UIImage(named: "icon"), for: .normal)
```

### UIImageView
```swift
imageView.dtb
    .image(UIImage(named: "placeholder"))
    .highlightedImage(UIImage(named: "highlight"))
```

### UITextView
```swift
textView.dtb
    .text("内容")
    .font(.systemFont(ofSize: 14))
    .textColor(.darkText)
```

### UITableView
```swift
tableView.dtb
    .separatorStyle(.none)
    .rowHeight(44)
    .estimatedRowHeight(44)
```

### UIStackView
```swift
stackView.dtb
    .axis(.vertical)
    .spacing(8)
    .alignment(.fill)
    .distribution(.fill)
```

### UIControl
```swift
control.dtb
    .isEnabled(true)
    .isSelected(false)
```

### CALayer
```swift
layer.dtb
    .cornerRadius(8)
    .borderWidth(1)
    .borderColor(UIColor.gray.cgColor)
    .shadowOpacity(0.3)
```

### 值类型 — NSAttributedString.Key
```swift
let attributes: [NSAttributedString.Key: Any] = .dtb.create
    .foregroundColor(.black)
    .font(.systemFont(ofSize: 13))
    .paragraphStyle(style)
    .value
```

### 值类型 — 几何
```swift
CGRect.dtb.create.x(10).y(20).width(100).height(50).value
CGSize.dtb.create.width(100).height(50).value
UIEdgeInsets.dtb.create.top(10).left(15).bottom(10).right(15).value
```

### 格式化
```swift
NumberFormatter().dtb
    .decimal(2)
    .prefix("¥")
    .value

DateFormatter().dtb
    .format("yyyy-MM-dd")
    .value
```

## 关键理解

1. 所有 Chain 方法遵循相同模式，不需要逐个记忆，按需查阅源码即可
2. 使用前必须让对象遵守 `Chainable`（DTBKit 默认的 UIKit 组件已遵守）
3. 不要为值类型的链式中间变量赋值，直接 `.create...value` 一步到位

## 关联
- [[../concepts/chain]] — 链式语法设计原理
- [[uikit]] — UIKit 模块提供了更高级的组件
