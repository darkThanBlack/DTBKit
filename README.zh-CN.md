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

查看示例：推荐安装 ``xcodegen``，进入到 ``Example`` 目录下后命令行执行 ``xcodegen`` 和 ``pod install`` 。

工程采用 cocoapods 结构，但尚未正式发布，使用时需要使用类似于

```ruby
pod 'DTBKit', git: 'https://github.com/darkThanBlack/DTBKit', commit: 'dd3acb'
```

的形式指明仓库地址和版本号。

说明文档和注释注定不会非常完善，使用前请通读源码。



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



## Demo

> 提供工程实践和集成示例。

接口设计： [命名空间配合链式语法](https://darkthanblack.github.io/blogs/06-bp-namespace/)



## Example

> 开发工程。



## Basic

> 基础类型扩展。



## UIKit

> UI 层扩展。



## Guide









## 日志





## Playground



#### Segment

* 手势动画
* child 横向切换



#### 粘性吸顶

* 渐变动画
* 点击到指定位置
