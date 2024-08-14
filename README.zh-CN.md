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



#### 约定俗成

常见的英文单词**肯定**都被各类编程语言和框架瓜分殆尽，所以在命名上需要非常谨慎，并允许用户自行约定习惯的词汇。

目前框架使用仅需要关注以下逻辑：

* 以 ``UIView().dtb`` 形式开头的是对象方法，表示对这个对象的修改
* 以 ``UIView.dtb`` 形式开头的是类方法，一般在需要创建对象和其他操作时使用
* 绝大多数对象会实现以 ``create`` 命名的类方法，用于快速创建；
* ``value``，所有包装对象会实现该属性，用于拆箱。



#### 扩展

将以下代码添加到工程中，具体实现自行调整：

```swift
// === NAMESPACE CONVERT ===

@_exported import DTBKit

// - Core

public typealias XM = DTB

public typealias XMKitable = DTBKitable

public typealias XMKitStructable = DTBKitStructable

public typealias XMKitWrapper = DTBKitWrapper

public typealias XMKitStaticWrapper = DTBKitStaticWrapper

extension XMKitable {
    
    public var xm: XMKitWrapper<Self> {
        return dtb
    }
    
    public static var xm: XMKitStaticWrapper<Self> {
        return dtb
    }
}

extension XMKitStructable {
    
    public var xm: XMKitWrapper<Self> {
        return dtb
    }
    
    public static var xm: XMKitStaticWrapper<Self> {
        return dtb
    }
}

extension XMKitWrapper {
    
    internal var me: Base { return value }
}

// - Chain

public typealias XMKitChainable = DTBKitChainable

public typealias XMKitStructChainable = DTBKitStructChainable

public typealias XMKitMutableWrapper = DTBKitMutableWrapper

```



#### 私有 Cocoapods

直接将以上代码放到你的私有库中，同时

```ruby
# 私有库的 dependency 无法具体指定版本等信息
ss.dependency 'DTBKit/Core'

# 所以要在集成了你的私有库的主工程中添加 source
source 'https://github.com/darkThanBlack/Specs.git'

# 不用 source 的话, 直接指定是一样的
pod 'DTBKit/Core', git: 'https://github.com/darkThanBlack/DTBKit', commit: '3f93179af6c2caa1e8bd0c418820947fe1aae899'
```



#### 测试

支持直接通过 cocoapods 测试，或者直接运行 ``Example`` 工程：

```ruby
pod 'DTBKit/Basic', :testspecs => ['Tests']
```

在 Xcode 的 Schemes 中选择 ``DTBKit``，``Command + U`` 即可。



## 源码解析

 [命名空间配合链式语法](https://darkthanblack.github.io/blogs/06-bp-namespace/)



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



## 日志

> Update: 2024/08/14    增加别名集成示例代码。

