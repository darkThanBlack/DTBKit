# DTBKit

![version](https://img.shields.io/badge/version-0.0.1-orange) ![coverage](https://img.shields.io/badge/coverage-70%25-green)

[English](https://github.com/darkThanBlack/DTBKit/blob/main/README.md) |  [简体中文](https://github.com/darkThanBlack/DTBKit/README.zh-CN.md)



## 这是什么？


#### 一组个人开发套件

* 提供一些常用的功能
* 最佳实践展示

#### 提供依赖隔离

这个话题非常宏大，我在设计上偏重于

* 跨项目
* 无痛



## 如何阅读？

#### 总则

我难以在 README 中提供过多信息，您需要

* 下载本仓库，运行 Example 项目
  * 查看主工程代码，获取最佳实践展示
  * 运行 XCTest，查看测试用例，获取使用方法
* 阅读 [wiki](https://github.com/darkThanBlack/DTBKit/wiki) 
* 可以参考 [接口文档](https://darkthanblack.github.io/DTBKit/Structs/DTBKitWrapper.html)，但更新没有那么及时



#### 顺利运行 Example

您需要确保

* 已安装 [XcodeGen ~> 2.41.0](https://github.com/yonaskolb/XcodeGen)，用来生成 ``*.xcodeproj`` 文件
* 已安装 [CocoaPods ~> 1.15.2](https://cocoapods.org/)

在 ``Example`` 目录下，依次执行

`````shell
# Example.xcodeproj will be created.
xcodegen
# Link to development pods.
pod install
`````



#### 顺利运行单元测试

以  Xcode 16.3 ，Example 工程为例，您可以

* 在 ``Manage Schemes...`` 中添加并选中 ``DTBKit``
* 按下 ``Command + B`` 编译 ``DTBKit`` 工程
* 按下 ``Command + U`` 执行测试
* 在 ``Reports`` （ ``Command + 9``）选项卡中查看测试报告
* 代码覆盖率统计需要在 ``Edit Scheme - Test - Options - Code Co - Gather coverage for...`` 手动处理

观察示例工程的 Podfile，可以发现已支持 cocoapods 模式的单元测试用例：

```ruby
pod 'DTBKit/Basic', :testspecs => ['Tests']
```

所以如果您的主工程使用了 cocoapods 引入，也可以在主工程中完成测试。



## 如何集成？

#### CocoaPods

未推送到 pods 主仓，推荐使用指定 commit 引入：

```shell
# Change commit id to latest main.
pod 'DTBKit/Core', git: 'https://github.com/darkThanBlack/DTBKit', commit: '3f93179af6c2caa1e8bd0c418820947fe1aae899'
pod 'DTBKit/Chain'
pod 'DTBKit/Basic'
pod 'DTBKit/Theme'
pod 'DTBKit/UIKit'
pod 'DTBKit/Map'
```

可以用私有 Source ，但更新并不及时：

```ruby
source 'https://github.com/darkThanBlack/Specs.git'
pod 'DTBKit', tag: '0.0.1'
```

#### Carthage

支持，仓库根目录下的 ``DTBKit.xcodeproj`` 同样是通过 ``XcodeGen`` 生成的，但更新并不及时。 

#### SPM

支持，仓库根目录下的 ``Package.swift`` 是手动编辑的，但更新并不及时。



## 快速开始

#### 常规使用

* 任何对象都可以拥有一个所谓的"命名空间"：

    ```swift
    // Object.
    UIView().dtb
    // Static.
    UIView.dtb
    ```

* 所有的包装器都会实现 ``value`` 属性用于拆箱，且大部分方法支持链式调用：

    ```swift
    lazy var titleLabel = UILabel().dtb
      .title("moon")
      .backgroundColor(.white)
      .value
    ```

* 绝大多数用于快速创建对象的类方法会以 ``create`` 命名，同时不需要拆箱：

    ```swift
    // Create custom font.
    UILabel().font = .dtb.create("Lora", size: 10)
    let frame = CGRect.dtb.create(8.0, 12.0, 20.0, 20.0)
    
    // Creater for special dict.
    let attr = NSAttributedString(
        string: "attr",
        attributes: .dtb.create
            .foregroundColor(.black)
            .font(.dtb.create("Gloock", size: 13.0, weight: .regular))
            .value
    )
    ```


* 绝大多数类的声明和静态对象都会放在 ``DTB`` 枚举内部：
  ```swift
  // CFBundleShortVersionString.
  print(DTB.app.version)
  // Use custom button.
  lazy var button = {
      let button = DTB.Button()
      button.setImageDirection(.right)
      button.setImageOffset(.init(dx: 4.0, dy: -1.0))
      return button
  }()
  ```



#### 高级使用

假设你有 A，B 两个不同的模块，B 模块拥有方法叫 ``testB``，你可以将 ``dtb`` 换成自己定义的关键字 ``b``，并让没有引入 B 的模块无法使用该方法：

```swift
// In project B
UIView().b.testB()  // OK
UIView().dtb.testB()  // OK

// In Project A
UIView().dtb.testB()  // fatal error.
```

建议您阅读 [wiki](https://github.com/darkThanBlack/DTBKit/wiki) 中的详细说明，并在彻底理解源码后行动。



## LLM

根目录下的 md 文件更侧重于功能开发使用，请让 AI 阅读指定的大模型友好文档。



## 日志

> Update: 2025/12/11    Clear README.md.
>
> Update: 2024/08/14    Add sample codes for custom namespace.
>
> Update: 2024/09/20    Add Carthage / SwiftPM support.
>
> Update: 2024/09/21    Deploy jazzy docs on gh-pages.

