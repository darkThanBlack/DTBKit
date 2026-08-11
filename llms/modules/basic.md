# Basic — Foundation 扩展

> subspec: `DTBKit/Basic` | 源码: `Sources/Basic/` | 依赖: Chain + Theme

## 概述

Basic 模块为常用 Foundation 和 UIKit 类型提供实用扩展方法。这是 DTBKit 中覆盖面最广的模块。

本文覆盖 Foundation 类型扩展和 UIKit 类型扩展。数值/时间/几何/转换见 [[basic-types]]，格式化/缓存/工具见 [[basic-utilities]]。

## Foundation 类型扩展

### Data

```swift
// Data → String
data.dtb.string()?.value           // 默认 UTF-8
data.dtb.string(.ascii)?.value     // 指定编码
data.dtb.toString()                // 直接返回 String?（不走 Wrapper）

// Data → NSData
data.dtb.ns().value                // → NSData

// JSON 解析
data.dtb.json()                    // → Any?
data.dtb.jsonDict()                // → [String: Any]?
data.dtb.jsonArray()               // → [Any]?
```

### String

```swift
// String → Data
string.dtb.data()?.value           // 默认 UTF-8
string.dtb.data(.ascii)?.value     // 指定编码
string.dtb.toData()                // 直接返回 Data?

// String → NSString/NSAttributedString
string.dtb.ns().value              // → NSString
string.dtb.attr().value            // → NSAttributedString

// 字符计数（基于 utf16.count，与 NSString.length 一致）
string.dtb.count()                 // → Int

// 空值判断
string.dtb.isEmpty()               // → Bool
string.dtb.isBlank()               // → Bool（仅空白字符也返回 true）
string.dtb.noBlank()               // → Self（去除首尾空白）

// 字符检查
string.dtb.allSatisfy(chars: .decimalDigits)  // 所有字符在指定 CharacterSet 中
string.dtb.isPureInt()             // → Bool（纯数字，不含正负号和小数点）

// NSRange 越界检查
string.dtb.has(nsRange: range)     // → Bool

// 正则匹配
string.dtb.isMatches("[0-9]+")     // → Bool（NSPredicate 正则）
string.dtb.isRegular(.phone())     // → Bool（使用预定义 DTB.Regulars）

// URL 操作
string.dtb.urlAppendParams(["key": "value"])  // → Self
string.dtb.urlParams()             // → [String: String]

// JSON 解析
string.dtb.json()                  // → Any?
string.dtb.jsonDict()              // → [String: Any]?
string.dtb.jsonArray()             // → [Any]?

// Date 转换（通过 formatter）
string.dtb.date(formatter: f)?.value     // → Date?
string.dtb.toDate("yyyy-MM-dd")          // → Date?
```

### NSMutableAttributedString

```swift
mutableAttrString.dtb.string().value    // → String
mutableAttrString.dtb.mString().value   // → NSMutableString

// 追加富文本
mutableAttrString.dtb.append("text",
    .dtb.create.foregroundColor(.black).font(...).value
).value

// 设置子串属性（搜索子串 → 设置属性）
mutableAttrString.dtb.setSub("关键字", attrs: [...])
mutableAttrString.dtb.addSub("关键字", attrs: [...])
```

### UserDefaults

```swift
// 静态扩展
UserDefaults.dtb.read(key)              // → Value?
UserDefaults.dtb.write(value, key: key)
UserDefaults.dtb.clear(key)

// Codable 存储
UserDefaults.dtb.read(codable: key)     // → Value?
UserDefaults.dtb.write(codable: model, key: key)

// 检查类型是否可存储
UserDefaults.dtb.isVaild(key)           // → Bool
```

### Bundle

```swift
// 静态扩展
Bundle.dtb.allBundleUrls()              // → [URL]（搜索 app 内所有 bundle）
Bundle.dtb.create(SomeClass.self)       // → Bundle?（通过 Class 创建）
Bundle.dtb.create(bundleURL)            // → Bundle?（通过 URL 创建）
Bundle.dtb.create("bundleName")         // → Bundle?（通过名称搜索）
```

### Error — NSError 创建

```swift
// 静态扩展
NSError.dtb.create("网络错误")          // → NSError（localizedDescription = message）
NSError.dtb.create("网络错误", code: 404) // 自定义错误码
NSError.dtb.empty("optionalName")       // → NSError（"xxx is nil" 格式）
NSError.dtb.ignore()                    // → NSError（空描述，code: 0）
NSError.dtb.reason("原因")              // → NSError
```

### NSRange

```swift
nsRange.dtb.isEmpty()   // → Bool（location == NSNotFound || length < 0）
```

## UIKit 类型扩展

### UIImage

```swift
// 转换为 CIImage
image.dtb.ci()?.value           // → CIImage?

// 图片缩放（下采样，最长边等比缩放到指定值）
image.dtb.scale(to: 300)?.value  // → UIImage?

// 图片裁剪（按宽高比居中裁剪）
image.dtb.clip(16.0 / 9.0)       // → UIImage
```

### UIImageView

```swift
// 无图片时自动隐藏
imageView.dtb.hiddenWithEmptyImage()  // → Self（image/highlightedImage/animationImages 都为空则隐藏）
```

### UILabel

```swift
// 无文本时自动隐藏
label.dtb.hiddenWithEmptyText()  // → Self（text 和 attributedText 都为空则隐藏）
```

### UITableView

```swift
// 静态方法：快速创建
UITableView.dtb.plain(controller, cells: [Cell.self])
UITableView.dtb.grouped(controller, cells: [Cell.self])

// 实例方法：用类名作重用标识
tableView.dtb.registerCell(MyCell.self)
tableView.dtb.registerHeaderFooterView(MyHeader.self)

let cell: MyCell? = tableView.dtb.dequeueReusableCell(indexPath)
let cell: MyCell = tableView.dtb.dequeueReusableCellEnsured(indexPath)  // 保证非空
let header: MyHeader? = tableView.dtb.dequeueReusableHeaderFooterView()
```

### UICollectionView

```swift
collectionView.dtb.registerCell(MyCell.self)
collectionView.dtb.registerHeader(MyHeader.self)
collectionView.dtb.registerFooter(MyFooter.self)

let cell: MyCell = collectionView.dtb.dequeueReusableCell(for: indexPath)
let header: MyHeader = collectionView.dtb.dequeueReusableSupplementaryViewHeader(for: indexPath)
```

### UIViewController

```swift
// 显示
viewController.dtb.topMost()?.value       // → UIViewController?（递归取栈顶）
UIViewController.dtb.topMost()            // 静态等价方法

viewController.dtb.previous()?.value      // → UIViewController?（取上一个控制器）

// 关闭
viewController.dtb.popAnyway()            // → Bool（依次尝试 pop/dismiss/remove）
UIViewController.dtb.popAnyway()          // 静态等价方法

viewController.dtb.popToMainRootAnyway()  // → Bool（递归回到 root）
```

## 关联
- [[basic-types]] — 数值/时间/几何/转换
- [[basic-utilities]] — 格式化/缓存/Optional/HighFidelity
- [[../quickref]] — 按类型快速索引
