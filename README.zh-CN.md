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

查看示例：推荐通过 ``homebrew`` 安装 ``xcodegen``，进入到 ``Example`` 目录下后命令行执行 ``xcodegen`` 和 ``pod install`` 。

工程采用 cocoapods 结构，但尚未正式发布，使用时需要使用类似于

```ruby
pod 'DTBKit', git: 'https://github.com/darkThanBlack/DTBKit', commit: 'dd3acb'
```

的形式指明仓库地址和版本号。

说明文档和注释注定不会非常完善，使用前请通读源码。



#### 简介

代码的用法很简单，首先在理论上，

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

* 对于你自己的新工程或者新业务，你可以将 ``dtb`` 这三个字换成任意自己喜欢的名字：

    ```swift
    UIView().dtb
    ```

* 假设在新业务里有一个业务方法叫 ``test2``：

    ```swift
    UIView().dtb.test()
    UIView().dtb.test()
    
    UIView().dtb.test2()
    UIView().dtb.test()  // 编译出错
    ```

* 对新业务 ``xm`` 来说，它可以直接调用 ``dtb`` 空间内的所有方法，而对于在 ``xm`` 空间内的方法， ``dtb`` 则无法调用，也不会有代码提示。

* 有些方法支持链式调用，会返回一个以 ``wrapper`` 名称结尾的对象，而所有的 ``wrapper`` 对象都有 ``value`` 属性，用于获取内部的真实对象：

    ```swift
    let titleLabel = UILabel().dtb.title("moon").value
    titleLabel.backgroundColor = .white
    ```



#### 关键词约定

常见的英文单词**肯定**都被各类编程语言和框架瓜分殆尽，所以在命名上需要非常谨慎，并允许用户自行约定习惯的词汇。

目前框架使用仅需要关注以下逻辑：

* 以 ``UIView().dtb`` 形式开头的是对象方法，表示对这个对象的修改
* 以 ``UIView.dtb`` 形式开头的是类方法，一般在需要创建对象和其他操作时使用
* 绝大多数对象会实现以 ``create`` 命名的类方法，用于创建对象时使用
* ``value``，所有包装对象会实现该属性，用于拆箱



## Demo

> 提供工程实践和集成示例。



## Example

> 开发工程。



## Core

> 仅提供对 class 类型的最基础声明。



## Chain

> 将重点集中在对象的创建和赋值上，避免功能性扩展。



## Basic

> 无横向依赖的基础能力扩展。



## UIKit

> UI 层扩展。



## 二次开发

> 思路： [命名空间配合链式语法](https://darkthanblack.github.io/blogs/06-bp-namespace/)



目前框架内仅大致遵循以下规则：

* class 对象方法，返回类型一般是 Self，除非：

    * 绝大多数用户需要直接的返回结果
    * 返回一个与当前对象类型不同的基础类型

    举个例子：

    ```swift
    extension DTBKitWrapper where Base: UILabel & DTBKitChainable {
        /// 正常链式
        @discardableResult
        public func text(_ value: String?) -> Self {
            me.text = value
            return self
        }
    
        /// 返回值直接用于判断，不太可能有后续
        public func isEmpty() -> Bool {
            return (me.text == nil) || (me.text?.isEmpty == true)
        }
    }
    
    extension DTBKitWrapper where Base == String {
        /// 虽然发生了类型转换，依然返回包装后的对象
        @discardableResult
        public func ns() -> DTBKitWrapper<NSString>? {
            return NSString(me).dtb
        }
    }
    ```

* class 静态方法的 ``create``，一般返回 ``wrapper<T>``

* struct 静态方法的 ``create``，一般返回 ``T`` 或 ``DTBKitMutableWrapper<T>``



## 日志





## Playground



#### Segment

* 手势动画
* child 横向切换



#### 粘性吸顶

* 渐变动画
* 点击到指定位置
