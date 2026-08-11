# Basic — 数值/时间/几何/转换

> subspec: `DTBKit/Basic` | 源码: `Sources/Basic/Number/` `Sources/Basic/Time/` `Sources/Basic/Frame/` `Sources/Basic/Convert/` `Sources/Basic/String/` `Sources/Basic/Collection/`

## 数值类型

### 数值检查协议（NumberEmptyCheckable）

所有数值类型（Int, Int8, Int16, Int32, Int64, Float, Double）共享：

```swift
value.dtb.isZero()       // → Bool
value.dtb.isPositive()   // → Bool
value.dtb.isNegative()   // → Bool
value.dtb.isFinite()     // → Bool（对浮点类型有意义，Int 始终返回 true）
value.dtb.isEmpty()      // → Bool（浮点: !isFinite, 整数: 始终 false）
value.dtb.emptyValue()   // → Self（静态，返回零值）
```

### Double/Float/CGFloat（BinaryFloatingPoint）

```swift
// 取整（返回 Double）
value.dtb.round(to: 2)       // → Double（默认四舍五入到 2 位小数）
value.dtb.trunc(to: 2)       // → Double（向 0 取整）
value.dtb.ceil(to: 2)        // → Double（向上取整）
value.dtb.floor(to: 2)       // → Double（向下取整）

// 取整（返回 Wrapper<Double>）
value.dtb.rounded(to: 2)     // → Wrapper<Double>
value.dtb.truncated(to: 2)   // → Wrapper<Double>
value.dtb.ceiled(to: 2)      // → Wrapper<Double>
value.dtb.floored(to: 2)     // → Wrapper<Double>
```

### Integer

```swift
int.dtb.hf()                 // → CGFloat（高保真适配）
int.dtb.hf(.width)           // 指定轴向
int.dtb.toMS()               // → Wrapper<Double>（秒 → 毫秒, * 1000）
int.dtb.toS()                // → Wrapper<Double>（毫秒 → 秒, / 1000）
int.dtb.toDurationString(.text)   // → String?（"12小时33分"）
int.dtb.toDurationString(.symbol) // → String?（"12'33\""）
int.dtb.minutesString()      // → String（"02:30" 格式）
int.dtb.weekDayString(.iso)  // → String?（1=周一, 默认 ISO 8601）
int.dtb.weekDayString(.gregorian) // → String?（1=周日）
```

### NSDecimalNumber

高精度小数运算。`scale` 和 `rounding` 为 nil 时使用 `DTB.config.decimalBehavior` 作为默认值。

```swift
// 创建（失败返回 notANumber）
NSDecimalNumber.dtb.create("123.45")   // 支持: String, Double, Int64, NSDecimalNumber

// 转换
num.dtb.double()?.value    // → Double?（notANumber 返回 nil）
num.dtb.string()?.value    // → String?（notANumber 返回 nil）
num.dtb.doubleValue()      // → Double?
num.dtb.stringValue()      // → String?

// 精度运算
num.dtb.plus(2.5)          // + | 支持: NSDecimalNumber, String, Double, Int64
num.dtb.minus(1.0)         // -
num.dtb.multi(3.0)         // *
num.dtb.div(2.0)           // / | 除数为 0 返回 notANumber
num.dtb.power(2)           // ^ | 幂运算
num.dtb.multiPower10(3)    // * 10^ | 10 的幂次方
```

### NSNumber

```swift
// 创建
NSNumber.dtb.create(value)  // 支持: Double, Float, Int, NSNumber
NSNumber.dtb.create(42)     // 失败返回 Double.nan

// 转换
nsNumber.dtb.int().value    // → Int
nsNumber.dtb.int64().value  // → Int64
nsNumber.dtb.double().value // → Double
```

## 时间

### Date 扩展

```swift
// 日期差值
date.dtb.minus(to: otherDate, .day)?.value  // → Int?

// 同日/月/年判断
date.dtb.isSameDay()           // → Bool（与今天比较）
date.dtb.isSameDay(otherDate)  // 与指定日期比较
date.dtb.isSameMonth()         // → Bool
date.dtb.isSameYear()          // → Bool

// 日期增减
date.dtb.addingDay(7)?.value   // → Date?（加 7 天）
date.dtb.addingWeek(1)?.value  // → Date?
date.dtb.addingMonth(1)?.value // → Date?
date.dtb.addingYear(1)?.value  // → Date?

// 起始/结束
date.dtb.startOfDay()?.value   // → Date?（当天 00:00:00）
date.dtb.startOfMonth()?.value // → Date?（当月第一天）
date.dtb.startOfWeek()?.value  // → Date?（当周第一天，周一为始）
date.dtb.startOfYear()?.value  // → Date?
date.dtb.endOfDay()?.value     // → Date?（当天 23:59:59）
date.dtb.endOfMonth()?.value   // → Date?
date.dtb.endOfWeek()?.value    // → Date?
date.dtb.endOfYear()?.value    // → Date?

// 时间戳转换
date.dtb.ms().value            // → Int64（毫秒时间戳）
date.dtb.toString("yyyy-MM-dd") // → String（格式化）
date.dtb.string(formatter: f).value // → String

// 当日经过的分钟数
date.dtb.dayMinutes()?.value   // → Int64?
```

### 相对时间（TimeRelative）

```swift
date.dtb.toRelativeString()    // → String
// 输出示例: "刚刚", "3分钟前", "今天 16:59", "昨天 18:06", "10-09 18:06"

// 自定义规则
let rules: [DTB.DateRelativeRule] = [...]
date.dtb.toRelativeString(barrier: rules, baseDate: now)

// 预置规则
DTB.DateRelativeRule.defRules()     // 完整规则链
DTB.DateRelativeRule.negative()     // 早于当前 → 格式化
DTB.DateRelativeRule.oneMinute()    // 60s 内 → "刚刚"
DTB.DateRelativeRule.oneHour()      // 3600s 内 → "x分钟前"
DTB.DateRelativeRule.today()        // 今天 → "今天 HH:mm"
DTB.DateRelativeRule.yesterday()    // 昨天 → "昨天 HH:mm"
DTB.DateRelativeRule.tomorrow()     // 明天 → "明天 HH:mm"
DTB.DateRelativeRule.sameYear()     // 同年 → "MM-dd HH:mm"
DTB.DateRelativeRule.another()      // 其他 → "yyyy-MM-dd HH:mm"
```

### 时长（TimeDuration）

```swift
// 星期名称规范
DTB.WeekdayTypes.iso        // ISO 8601: 周一=1, 周日=7
DTB.WeekdayTypes.gregorian  // 公历: 周日=1, 周六=7

// 时长字符串转换格式
DTB.DateDurationFormatTypes.text    // "12时33分28秒"
DTB.DateDurationFormatTypes.symbol  // "12'33\""
```

## 几何

### CGSize

```swift
// 安全检查
size.dtb.safe()          // → Self（宽/高为负时改为 0）
size.dtb.isEmpty()       // → Bool（宽 ≤ 0 或高 ≤ 0）
size.dtb.notEmpty()      // → Bool
size.dtb.isSquare()      // → Bool（正方形）

// 计算
size.dtb.center()        // → CGPoint（中心点）
size.dtb.area()          // → CGFloat（面积）
size.dtb.longer()        // → CGFloat（较长边）
size.dtb.shorter()       // → CGFloat（较短边）

// 正方形变换
size.dtb.inSquare()      // → Self（内接正方形，取短边）
size.dtb.outSquare()     // → Self（外接正方形，取长边）

// 间距（返回新尺寸）
size.dtb.margin(all: 10)              // 外加间距
size.dtb.margin(dx: 10, dy: 20)       // 水平/垂直间距
size.dtb.margin(only: UIEdgeInsets)    // 自定义方向
size.dtb.padding(all: 10)             // 内减间距
size.dtb.padding(dx: 10, dy: 20)      // 水平/垂直内减
size.dtb.padding(only: UIEdgeInsets)   // 自定义方向

// 等比缩放
size.dtb.aspectFit(to: targetSize)    // → Self（内接缩放）
size.dtb.aspectFill(to: targetSize)   // → Self（外接缩放）
```

### CGRect

CGRect 自身扩展方法较少，主要通过 Chain 模块的 `CGRect.dtb.create.xxx().value` 进行链式创建。

## 类型转换

### AnyConvert（DTB.any）

从 `Any?` 安全转换为具体类型：

```swift
DTB.any.int64(value)          // → Int64?
DTB.any.int(value)            // → Int?
DTB.any.double(value)         // → Double?
DTB.any.cgFloat(value)        // → CGFloat?
DTB.any.uiEdgeInsets(value)   // → UIEdgeInsets?（从 [String: Any] 解析）
DTB.any.cgSize(value)         // → CGSize?（从 [String: Any] 解析）
DTB.any.cgVector(value)       // → CGVector?（从 [String: Any] 解析）
```

### 专用 Convert

```swift
// DateConvert: 见上面 "时间" 部分的 toString/toDate
// DoubleConvert: 见上面 "数值类型" 部分的取整方法
// IntegerConvert: 见上面 "Integer" 部分
// StringConvert: 见 [[basic]] String 部分
```

## NSString

```swift
nsString.dtb.range(of: "searchString")  // → Wrapper<NSRange>
```

## Collection — 数组安全下标

```swift
// 安全下标（防越界）
array.dtb[0]           // → Element?（越界返回 nil）
array.dtb[..<2]        // → ArraySlice<Element>（安全 Range）
array.dtb[...2]        // → ArraySlice<Element>（安全 ClosedRange）

// Collection 转 JSON 字符串
collection.dtb.jsonString()?.value  // → String?（序列化为 JSON）
collection.dtb.json()               // → T?（解码为 Codable 模型）
```

## 关联
- [[basic]] — Foundation/UIKit 扩展
- [[basic-utilities]] — 格式化/缓存/工具
