## 如何理解：DTBKitAdapter 系列



#### 引言

一般来说，三方库的方法声明为 ``public`` 或者更准确的 ``open`` 就可以方便地被重载， ``DTBKit`` 虽然允许彻底的自定义，但反而 *难以改变某个内置方法的行为*，因为它鼓励你开发并使用自己的方法。

* 通过定义接口并提供默认实现可以一定程度解决这个问题；

* 同时考虑到工作量的平衡，目前只会对满足：

    * 常用；
    * 强业务；

    等条件的一些方法进行处理。



#### DTBKitAdapterForUIColor

绝大多数的项目都会弄一份自己的色值定义来对齐设计规范，或者诸如 ``Color(hex: 0xFF8534)`` 之类的代码充斥着整个项目。为了避免话题太大，我只会点明痛点，简单来说，涉及到颜色的常见麻烦事主要有

* 跨项目依赖
* 暗黑模式
* 主题色

首先，解决跨项目依赖需要调用方法统一，比如， A 工程内调用的是 ``Color(aHex: )``，B 工程内调用的是 ``Color(bHex: )``，你需要有一个共用的 ``Color(hex: )`` 接口方法；

其次，考虑暗黑模式和主题色等需求的共性，本质上是将一对一变成了一对多的关系：

* 之前：hex 色值 = UIColor
* 之后：hex 色值 +（其他描述：深色/浅色主题，用户的主题库）= UIColor

换言之：

* 之前：``func init(hex: Int64)``
* 之后：``func init(hex: Int64, extra: ThemeParams)``

参数个数和类型必然不同，那么上层的抽象接口就无法规定具体参数，所以需要使用 ``associatedtype`` ：

```swift
public protocol DTBKitAdapterForUIColor {
    
    associatedtype ColorParam
    
    func create(_ key: ColorParam) -> UIColor
}

extension DTBKitStaticWrapper: DTBKitAdapterForUIColor where T: UIColor {}
```

``associatedtype`` 可以提供默认值[^1]：

```swift
associatedtype ColorParam = Int64
```

于是，对调用方来说，可以根据自己工程的情况指定 ``ColorParam``，而无需逐个调整调用代码：

```swift
/// ProjA | 在你自己的工程内

/// Your own Color definition may like this:
///
/// 假设这是你自己的色值定义，变成了枚举类型:
enum ColorKeys: String, CaseIterable {
    /// 606871
    case arrow01
    /// F5F7FA
    case background01
}

/// 实现接口方法
extension DTBKitStaticWrapper where T: UIColor {
    typealias ColorParam = ColorKeys
    
    public func create(_ key: ColorParam) -> UIColor {
        /// generate color from your own params
        ///
        /// 调用你自己工程的色值生成方法
        return ThemeManager.shared.query(key.rawValue)
    }
}

/// 业务代码调用
ProjA.label.backgroundColor = .dtb.create(.background01)
```



#### DTBKitAdapterForString

设计思路大体如上所述，后面就简单地提一下关键点，项目里的静态文本主要考虑

* 国际化

这必然牵扯到

* 动态下发
* 拼接

还可能涉及

* 词序



#### DTBKitAdapterForHUD

#### DTBKitAdapterForToast

#### DTBKitAdapterForAlert

hud: 菊花圈，例如 [MBProgressHUD](https://github.com/jdg/MBProgressHUD)

toast: 仿安卓样式的轻量级弹出提示，例如 [Toast-Swift](https://github.com/scalessec/Toast-Swift)

alert: ``UIAlertController`` 样式；

它们的共性是非常常用，但项目中基本上都会做一些自己的微调和设计。



#### DTBKitAdapterForUIWindowScene

#### DTBKitAdapterForUIWindow

无法 100% 保证获取到的 ``keyWindow`` 就是业务所需要的，参见 [BP | 最佳实践](https://darkthanblack.github.io/blogs/04-bp-keywindow)





[^1]: [泛型约束重载语法](https://zhuanlan.zhihu.com/p/80672557)
