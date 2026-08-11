# Basic — 格式化/缓存/可选值/高保真

> subspec: `DTBKit/Basic` | 源码: `Sources/Basic/Formatter/` `Sources/Basic/DiskCache/` `Sources/Basic/Optional/` `Sources/Basic/HF/` `Sources/Basic/Manager/`

## 全局配置（DTB.config）

`DTB.config` 是一个全局单例，存储框架各处的默认值。在 `AppDelegate` 中一次性配置即可。

```swift
DTB.config.setDesignBaseSize(CGSize(width: 375, height: 812))
DTB.config.setTime(zone: .current, locale: .current)
DTB.config.setNumberFormatter(customFormatter)
DTB.config.setDateFormatter(customFormatter)
DTB.config.setDecimalBehavior(handler)
```

### 配置项

| 属性 | 类型 | 默认值 | 用途 |
|------|------|--------|------|
| `designBaseSize` | CGSize | (375, 667) | 高保真适配的设计稿基准 |
| `decimalBehavior` | NSDecimalNumberHandler | plain, scale:15 | NSDecimalNumber 默认精度 |
| `timeZone` | TimeZone | Asia/Shanghai | 全局时区 |
| `locale` | Locale | zh-CN | 全局语言环境 |
| `calendar` | Calendar | gregorian | 全局日历 |
| `numberFormatter` | NumberFormatter | locale=zh-CN | 默认数字格式化器 |
| `dateFormatter` | DateFormatter | "yyyy-MM-dd HH:mm:ss" | 默认日期格式化器 |

### 配置方法

```swift
// 设计稿尺寸
DTB.config.setDesignBaseSize(CGSize(width: 390, height: 844))

// 全局时间设置（以 timeZone + locale 为准，自动更新 calendar 和 formatter）
DTB.config.setTime(zone: .current, locale: .current, calendarIdentifier: .gregorian)

// 全局时间设置（以 Calendar 为准，自动提取 timeZone 和 locale）
DTB.config.setCalendar(myCalendar)

// 替换 formatter
DTB.config.setNumberFormatter(myFormatter)
DTB.config.setDateFormatter(myFormatter)

// 替换 decimal behavior
DTB.config.setDecimalBehavior(handler)
```

## 格式化（Formatter）

### DateFormatter — Date ↔ String

```swift
// Date → String
date.dtb.string(formatter: myFormatter).value     // → String
date.dtb.toString("yyyy-MM-dd")                    // → String（快捷方法）

// String → Date
string.dtb.date(formatter: myFormatter)?.value     // → Date?
string.dtb.toDate("yyyy-MM-dd")                    // → Date?（快捷方法）
```

快捷方法内部使用 `DTB.config.dateFormatter`，临时修改其 `dateFormat` 后还原，因此**不是线程安全的**，建议在主线程使用或使用 `string(formatter:)` 传入独立实例。

### NumberFormatter — Number ↔ String

**预置格式（静态方法）：**

```swift
// 等长小数 — "2.10"（始终显示指定位小数）
let a = 2.1.dtb.toString(.dtb.decimal())?.value

// 去零小数 — "2.1"（最多指定位小数，末尾零省略）
let b = 2.1.dtb.toString(.dtb.maxDecimal())?.value

// 人民币 — "¥2.10"
let c = 2.1.dtb.toString(.dtb.CNY)?.value

// 人民币（元） — "2.1元"
let d = 2.1.dtb.toString(.dtb.RMB)?.value
```

**自定义 NumberFormatter 链式配置：**

```swift
let fmt = NumberFormatter().dtb
    .decimal(2)                  // 小数位数
    .rounded(.halfUp)            // 进位规则
    .split(by: ",", size: 3)     // 分组分隔符
    .prefix("¥", negative: "-¥") // 正/负前缀
    .suffix("元")                // 正/负后缀
    .value

let result = 1234.5.dtb.toString(fmt)   // "¥1,234.50元"
```

**链式方法一览：**

| 方法 | 参数 | 说明 |
|------|------|------|
| `.decimal(_:)` | Int (默认 2) | 等长小数 |
| `.maxDecimal(_:)` | Int (默认 2) | 去零小数（末尾零省略） |
| `.split(by:size:)` | String, Int | 分组分隔（千分位等） |
| `.rounded(_:)` | RoundingMode | 进位模式 |
| `.prefix(_:negative:)` | String, String? | 正/负前缀 |
| `.suffix(_:_:)` | String, String? | 正/负后缀 |
| `.string(from:)` | NSNumber? | 格式化输出 → Wrapper\<String\>? |
| `.number(from:)` | String? | 反向解析 → Wrapper\<NSNumber\>? |

**数值 → 字符串（使用 NumberFormatter）：**

```swift
// 浮点类型 (Double/Float/CGFloat)
value.dtb.toString(formatter)    // → String?
value.dtb.string(formatter)?.value // → String?

// 整数类型 (Int/Int64 等)
intValue.dtb.toString(formatter) // → String?
intValue.dtb.string(formatter)?.value // → String?
```

整数类型的 `toString` 内部先转 `Double` 再格式化，因此对超大整数（> 2^53）有精度损失。

**字符串 → 数值（反向解析）：**

```swift
string.dtb.toInt()               // → Int?（使用默认 formatter）
string.dtb.toInt(customFmt)      // → Int?（使用自定义 formatter）
string.dtb.toInt64()             // → Int64?
string.dtb.toInt64(customFmt)    // → Int64?
string.dtb.toDouble()            // → Double?
string.dtb.toDouble(customFmt)   // → Double?
```

## 缓存管理（DiskCache）

DTBKit 提供统一的磁盘缓存管理框架，基于 Provider 模式。业务方注册自定义缓存源后，统一计算大小和清理。

### DiskCacheManager

```swift
// 注册/注销缓存源
DTB.DiskCacheManager.shared.registerDiskProviders([
    DTB.FileCacheProvider.shared,
    DTB.URLCacheProvider(),
    DTB.WebViewCacheProvider()
])
DTB.DiskCacheManager.shared.unregisterDiskProviders(["url_cache"])

// 计算所有已注册缓存大小（主线程回调）
DTB.DiskCacheManager.shared.calculateDiskSizes { results in
    // results: [primaryKey: sizeInBytes]
}

// 指定 key 计算
DTB.DiskCacheManager.shared.calculateDiskSizes(by: ["file_cache"]) { results in }

// 清理所有已注册缓存
DTB.DiskCacheManager.shared.clearDisks { results in
    // results: [primaryKey: success]
}

// 文件大小格式化
let str = DTB.DiskCacheManager.shared.formatFileSize(1024000) // "1 MB"

// 手机磁盘信息
DTB.DiskCacheManager.shared.calculatePhoneDiskInfo { info in
    // info?.total / info?.free / info?.totalUsed
}

// App 占用空间
DTB.DiskCacheManager.shared.calculateAppDiskUsage { bytes in }

// 递归计算指定目录大小（同步，需在后台线程调用）
let size = DTB.DiskCacheManager.shared.querySize(dirURL)
```

### 内置 Provider

| Provider | primaryKey | 说明 |
|----------|------------|------|
| `DTB.FileCacheProvider` | `file_cache` | /Library/Caches + /tmp |
| `DTB.URLCacheProvider` | `url_cache` | URLCache.shared |
| `DTB.WebViewCacheProvider` | `wkwebview_cache` | WKWebView 网站数据 |

**FileCacheProvider：**

```swift
// 注册额外目录
DTB.FileCacheProvider.shared.registerFileUrls([customDirURL])
DTB.FileCacheProvider.shared.unregisterFileUrls([customDirURL])
```

**URLCacheProvider：**

```swift
// 静态清理方法（可直接调用，不注册到 DiskCacheManager 也可使用）
DTB.URLCacheProvider.clear {
    print("URL 缓存已清理")
}
```

**WebViewCacheProvider：**

```swift
// 清理指定数据类型
DTB.WebViewCacheProvider.clear(types: [WKWebsiteDataTypeCookies]) {
    print("Cookies 已清理")
}

// 清理所有（默认 clearDisk 的行为）
DTB.WebViewCacheProvider.clear(
    types: WKWebsiteDataStore.allWebsiteDataTypes()
) { }
```

### 自定义 Provider

实现 `DTB.Providers.CacheProvider` 协议：

```swift
class MyCacheProvider: DTB.Providers.CacheProvider {
    var primaryKey: String { "my_cache" }
    
    func calculateDiskSize(_ completed: ((Result<Int64, Error>) -> ())?) {
        completed?(.success(bytes))
    }
    
    func clearDisk(_ completed: ((Result<Void, Error>) -> ())?) {
        completed?(.success(()))
    }
}
```

## 可选值检查（DTB.check）

`DTB.check` 提供对可选值的安全处理，区分"空对象"和"零值数值"。

### 对象空值检查（EmptyCheckable）

适用类型：`String`、`Array`、`Dictionary`、`Set`

```swift
DTB.check.isEmpty(str)         // → Bool（nil 或空字符串 → true）
DTB.check.isNotEmpty(str)      // → Bool

// 空则取默认值
DTB.check.or(str, def: "默认") // → String（nil/empty 用 def，def 也为 nil 用空值）
DTB.check.or(str)              // → String（nil/empty → ""）
```

### 数值零值检查（NumberEmptyCheckable）

适用类型：`Int`, `Double`, `Float`, `CGFloat` 等

```swift
DTB.check.isEmptyOrZero(value)     // → Bool（nil / NaN / infinite / 0 → true）
DTB.check.isNotEmptyOrZero(value)  // → Bool

// 零则取默认值
DTB.check.orZero(value)            // → Double（nil/NaN/infinite → 0）

// 正负检查
DTB.check.isPositive(value)        // → Bool（> 0 且有限）
DTB.check.isNegative(value)        // → Bool（< 0 且有限）
```

### 与实例方法的关系

| DTB.check 方法 | 对应实例方法 |
|----------------|-------------|
| `DTB.check.isEmpty(s)` | `s.dtb.isEmpty()` |
| `DTB.check.isEmptyOrZero(d)` | `!d.dtb.isFinite() \|\| d.dtb.isZero()` |
| `DTB.check.or(str)` | —（无实例等价物，因需处理 nil） |

## 高保真适配（HighFidelity）

将设计稿像素值按屏幕尺寸等比缩放，解决不同屏幕尺寸下的适配问题。

```swift
// 数值类型
10.dtb.hf()            // → CGFloat（按宽度等比缩放）
10.5.dtb.hf()          // → CGFloat
CGFloat(16).dtb.hf()   // → CGFloat

// 指定轴向
10.dtb.hf(.h)          // 按宽度缩放（默认）
10.dtb.hf(.v)          // 按高度缩放

// 自定义缩放行为
let custom = DTB.HFBehaviors { value in
    return value * 1.5
}
10.dtb.hf(custom)
```

### 缩放公式

```swift
// .h（默认）
result = value * screenWidth / DTB.config.designBaseSize.width

// .v
result = value * screenHeight / DTB.config.designBaseSize.height
```

默认设计稿基准为 iPhone 6/7/8 尺寸（375×667），可通过 `DTB.config.setDesignBaseSize` 修改。

### Axis

```swift
DTB.Axis.h   // 水平轴，等价 NSLayoutConstraint.Axis.horizontal
DTB.Axis.v   // 垂直轴，等价 NSLayoutConstraint.Axis.vertical
```

## 正则表达式（DTB.Regulars）

`DTB.Regulars` 配合 `String.dtb.isRegular(_:)` 做正则匹配，避免散落的魔法字符串。

```swift
// 直接创建
let reg = DTB.Regulars("^[0-9]+$")
string.dtb.isRegular(reg)         // → Bool

// 自定义扩展
extension DTB.Regulars {
    public static func customID() -> Self {
        return DTB.Regulars("^[A-Z]{2}\\\\d{6}$")
    }
}
string.dtb.isRegular(.customID())
```

## 反射（ReflectManager）

```swift
let dict = ReflectManager.shared.mirror(someNSObject)
// → [String: Any]，递归反射所有属性
// 自动处理循环引用，标记为 "[循环引用: TypeName]"
```

## 关联
- [[basic]] — Foundation/UIKit 扩展
- [[basic-types]] — 数值/时间/几何/转换
- [[../quickref]] — 按类型快速索引

