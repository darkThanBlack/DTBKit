# DTBKit


 [![Static Badge](https://img.shields.io/badge/iOS-Swift-green)]() [![Static Badge](https://img.shields.io/badge/Cocoapods-1.12.1-green)]()



[English](https://github.com/darkThanBlack/DTBKit/blob/main/README.md) |  [简体中文](https://github.com/darkThanBlack/DTBKit/README.zh-CN.md)



## 这是什么？

> 一组个人开发套件，旨在展示各个场景下的最佳实践；
>
> 着力于业务代码跨项目间的无痛迁移。



对于第二点可能需要一些额外解释，当业务发展或开发新项目时，我们一般希望

* 复用一部分代码
* 同时将项目隔离开

举个例子：

* 当你想用一下主工程里的某些组件，写个小 demo 的时候，会发现一堆依赖报错，拔出萝卜带出泥，最后不得不把大部分的基础组件全给依赖了

这个话题非常宏大，总之，我认为

* 严格的模块化对独立开发者和小型团队来说并不现实；

*  ``KingFisher`` 首创的隔离方式非常优秀，但要想推广至整个业务工程则需要考虑更多。

本工程即是对该问题的一些思考。



## 快速开始



#### 查看示例

需要先通过 ``homebrew`` 安装 ``xcodegen``，用来生成 ``*.xcodeproj`` 文件。

```shell
# 有快捷脚本
cd Scripts
chmod +x ci.sh
./ci.sh
b1

# 和手动生成是等效的
cd Example
xcodegen
pod install
```



#### Cocoapods

```ruby
# 在主工程的 podfile 中添加
source 'https://github.com/darkThanBlack/Specs.git'
# 然后按需引入
pod 'DTBKit/Core', tag: '0.0.1'

# 不用 source 的话, 直接指定是一样的
pod 'DTBKit/Core', git: 'https://github.com/darkThanBlack/DTBKit', commit: '3f93179af6c2caa1e8bd0c418820947fe1aae899'
```



#### 简介

* 任何对象都可以拥有一个特殊的"命名空间"，以 ``UIView`` 为例，你可以：

    ```swift
    /// 调用
    UIView().dtb
    /// 静态方法
    UIView.dtb
    ```

* 随后，假设你有一个业务方法叫 ``test``，你可以：

    ```swift
    UIView().dtb.test()
    ```

* 对于不同的工程 / 业务，你可以将 ``dtb`` 换成自己定义的：

    ```swift
    UIView().xm.test()
    ```

* 你可以自由地向 ``xm`` 内增加你自己写的方法：

    ```swift
    UIView().xm.test2()
    ```

* 大部分方法支持链式调用：

    ```swift
    let titleLabel = UILabel().dtb.title("moon").value
    titleLabel.backgroundColor = .white
    ```



#### 如何使用提供的方法？

常见的英文单词**肯定**都被各类编程语言和框架瓜分殆尽，所以在命名上需要非常谨慎，并允许用户自行约定习惯的词汇。

目前框架使用仅需要关注以下逻辑：

* 以 ``UIView().dtb`` 形式开头的是对象方法，表示对这个对象的修改
* 以 ``UIView.dtb`` 形式开头的是类方法，一般在需要创建对象和其他操作时使用
* 绝大多数对象会实现以 ``create`` 命名的类方法，用于快速创建；
* ``value``，所有包装对象会实现该属性，用于拆箱。



#### 如何替换名称？

举个例子，默认的调用类似于：

```swift
if (DTB.app.version == "1.0.0") {
    UIView().dtb.toast("is old version")
}
```

你希望将前缀和属性名替换为 ``XM`` 和 ``xm``，以符合你自己的工程命名规则：

```swift
if (XM.app.version == "1.0.0") {
    UIView().xm.toast("is old version")
}
```

那么，新建一个 ``DTBKit+XM.swift`` 文件，添加以下所示代码：

```swift
// === NAMESPACE CONVERT ===

import DTBKit

// - Core

public typealias XM = DTBKit.DTB

public typealias XMKitable = DTBKit.DTBKitable

public typealias XMKitStructable = DTBKit.DTBKitStructable

public typealias XMKitWrapper = DTBKit.DTBKitWrapper

public typealias XMKitStaticWrapper = DTBKit.DTBKitStaticWrapper

extension XMKitable {

    public var xm: XMKitWrapper<Self> { return dtb }

    public static var xm: XMKitStaticWrapper<Self> { return dtb }
}

extension XMKitStructable {

    public var xm: XMKitWrapper<Self> { return dtb }

    public static var xm: XMKitStaticWrapper<Self> { return dtb }
}
```

如果同时用了其他的子仓库，依葫芦画瓢：

```swift
// - Chain

public typealias XMKitChainable = DTBKit.DTBKitChainable

public typealias XMKitStructChainable = DTBKit.DTBKitStructChainable

public typealias XMKitMutableWrapper = DTBKit.DTBKitMutableWrapper
```

现在， ``DTBKit+XM.swift`` 文件的作用域内，即可使用新方法调用。



#### 如何增加自定义方法？

参考源码，对 ``wrapper`` 增加相应的 ``extension`` 即可。



#### 如何隔离作用域？

作用域的控制完全取决于你自己对 extension 和 protocol 声明文件本身的控制。

举个例子，假如有主工程 Main，拥有自定义的模块 XM 和 模块 Other，两者同时依赖于基础模块 Basic。首先，对模块 XM 中的 ``DTBKit+XM.swift`` 做如下调整：

```swift
public typealias XMKitWrapper = DTBKit.DTBKitWrapper

public typealias XMKitStaticWrapper = DTBKit.DTBKitStaticWrapper

public protocol XMKitable: AnyObject {}

public protocol XMKitStructable {}

extension XMKitable {

    public var xm: XMKitWrapper<Self> {
        return XMKitWrapper(self)
    }

    public static var xm: XMKitStaticWrapper<Self> {
        return XMKitStaticWrapper()
    }
}

extension XMKitStructable {

    public var xm: XMKitWrapper<Self> {
        return XMKitWrapper(self)
    }

    public static var xm: XMKitStaticWrapper<Self> {
        return XMKitStaticWrapper()
    }
}
```

这样，我们得到了一个干净的 ``protocol``，现在

* 对象依然未拥有 ``xm`` 属性；
* ``xm`` 属性本身无法使用在其他模块中实现的方法，包括 ``DTBKit`` 本身提供的；

接着，在 XM 模块中创建 ``CGSize+XM.swift``，写一点业务：

```swift
// Mark 1
extension CGSize: XMKitStructable {}

// Mark 2
extension XMKitWrapper where Base == CGSize {
	public func area() -> CGFloat {
		return me.width * me.height
	}
}
```

很明显，CGSize 在什么时候可以使用 ``xm`` 属性，取决于 ``Mark 1`` 的作用域，而 CGSize 的 ``xm`` 属性拥有哪些方法，取决于 ``Mark 2`` 的作用域。你只要将以上几种方式结合起来按需实现即可。



#### 如何在你的私有 Cocoapods 中使用？

直接将以上代码放到你的私有库中，同时

```ruby
# 私有库的 dependency 无法具体指定版本等信息
ss.dependency 'DTBKit/Core'

# 所以要在集成了你的私有库的主工程中添加 source
source 'https://github.com/darkThanBlack/Specs.git'

# 不用 source 的话, 直接指定是一样的
pod 'DTBKit/Core', git: 'https://github.com/darkThanBlack/DTBKit', commit: '3f93179af6c2caa1e8bd0c418820947fe1aae899'
```



#### 单元测试

已支持 cocoapods 单元测试：

```ruby
pod 'DTBKit/Basic', :testspecs => ['Tests']
```

1. 以 Example 工程为例，打开后，在 Schemes 中直接选择 DTBKit；如果没有，在 manager 里面自行添加；
2. 任意选一个已经编译/运行通过的模拟器或真机；
3. ``Command + U`` 执行测试即可；
4. 代码覆盖率开关需要自行在 Scheme 里打开。



## 源码解析

 [如何设计命名空间与链式语法](https://darkthanblack.github.io/blogs/06-bp-namespace/)



## ~~Demo~~

> 提供工程实践和集成示例。



## Example

> 开发工程与测试用例。



## Core

> 仅提供对 class 类型的最基础声明。



## Chain

> 将重点集中在对象的创建和赋值上，避免功能性扩展。



## Basic

> 无横向依赖的基础能力扩展。



## UIKit

> UI 层扩展。



### 接口文档

在 [这里](https://darkthanblack.github.io/DTBKit) 有一份通过 [jazzy](https://github.com/realm/jazzy) 自动生成的文档。

```shell
# Deploy scripts
git checkout main;
xcodegen;
git add .;
git commit . -m 'daily';
git pull --ff;
git push;
jazzy \
  --clean \
  --author darkThanBlack \
  --author_url https://darkthanblack.github.io \
  --source-host github \
  --source-host-url https://github.com/darkThanBlack/DTBKit \
  --exclude "Sources/Chain/*" \
  --output docs \
  --theme apple;
mv docs ~/Documents/docs;
git checkout gh-pages;
git pull --ff;
mv ~/Documents/docs ./;
rm -rf ~/Documents/docs;
git add .;
git commit . -m 'deploy from jazzy';
git push;
git checkout main
```



## 日志

> Update: 2024/08/14    增加别名集成示例代码。
>
> Update: 2024/09/20    Add Carthage / SwiftPM support.
>
> Update: 2024/09/21    Deploy jazzy docs on gh-pages.

