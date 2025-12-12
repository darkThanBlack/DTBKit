# DTBKit

![version](https://img.shields.io/badge/version-0.0.1-orange) ![coverage](https://img.shields.io/badge/coverage-70%25-green)

[English](https://github.com/darkThanBlack/DTBKit/blob/main/README.md) |  [简体中文](https://github.com/darkThanBlack/DTBKit/blob/main/README.zh-CN.md)



## What is this?


#### A Personal Development Toolkit

* Provides commonly used functionalities
* Demonstrates best practices

#### Provides Dependency Isolation

This is a vast topic, and my design focuses on:

* Cross-project compatibility
* Painless integration



## How to Read?

#### General Guidelines

I can't provide too much information in README, so you need to:

* Download this repository and run the Example project
  * Check the main project code for best practice demonstrations
  * Run XCTest to view test cases and learn usage methods
* Read the [wiki](https://github.com/darkThanBlack/DTBKit/wiki) 
* You can refer to the [API documentation](https://darkthanblack.github.io/DTBKit/Structs/DTBKitWrapper.html), but updates may not be timely



#### Successfully Running Example

You need to ensure:

* [XcodeGen ~> 2.41.0](https://github.com/yonaskolb/XcodeGen) is installed to generate `*.xcodeproj` files
* [CocoaPods ~> 1.15.2](https://cocoapods.org/) is installed

In the `Example` directory, execute the following commands in sequence:

```shell
# Example.xcodeproj will be created.
xcodegen
# Link to development pods.
pod install
```



#### Successfully Running Unit Tests

Using Xcode 16.3 and the Example project as an example, you can:

* Add and select `DTBKit` in `Manage Schemes...`
* Press `Command + B` to build the `DTBKit` project
* Press `Command + U` to execute tests
* View test reports in the `Reports` (`Command + 9`) tab
* Code coverage statistics need to be manually configured in `Edit Scheme - Test - Options - Code Coverage - Gather coverage for...`

Observing the Example project's Podfile, you can see that CocoaPods mode unit testing is already supported:

```ruby
pod 'DTBKit/Basic', :testspecs => ['Tests']
```

So if your main project uses CocoaPods, you can also complete testing in the main project.



## How to Integrate?

#### CocoaPods

Not pushed to the main pods repository. Recommended to use specific commit:

```shell
# Change commit id to latest main.
pod 'DTBKit/Core', git: 'https://github.com/darkThanBlack/DTBKit', commit: '3f93179af6c2caa1e8bd0c418820947fe1aae899'
pod 'DTBKit/Chain'
pod 'DTBKit/Basic'
pod 'DTBKit/Theme'
pod 'DTBKit/UIKit'
pod 'DTBKit/Map'
```

You can use a private source, but updates are not timely:

```ruby
source 'https://github.com/darkThanBlack/Specs.git'
pod 'DTBKit', tag: '0.0.1'
```

#### Carthage

Supported. The `DTBKit.xcodeproj` in the repository root is also generated using `XcodeGen`, but updates are not timely.

#### SPM

Supported. The `Package.swift` in the repository root is manually edited, but updates are not timely.



## Quick Start

#### Basic Usage

* Any object can have a so-called "namespace":

  ```swift
  // Object.
  UIView().dtb
  // Static.
  UIView.dtb
  ```

* All wrappers implement the `value` property for unwrapping, and most methods support method chaining:

  ```swift
  lazy var titleLabel = UILabel().dtb
    .title("moon")
    .backgroundColor(.white)
    .value
  ```

* Most class methods for quickly creating objects are named `create` and don't require unwrapping:

  ```swift
  // Create custom font.
  UILabel().font = .dtb.create("Lora", size: 10)
  let frame = CGRect.dtb.create(8.0, 12.0, 20.0, 20.0)
  
  // Creator for special dict.
  let attr = NSAttributedString(
      string: "attr",
      attributes: .dtb.create
          .foregroundColor(.black)
          .font(.dtb.create("Gloock", size: 13.0, weight: .regular))
          .value
  )
  ```

* Most class declarations and static objects are placed inside the `DTB` enum:

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

#### Plugin Registration

Some functionalities use the provider pattern, serving as an interface specification; the actual implementation often requires complete customization. Whether you intend to use the provided default implementation or a completely custom one, you need to explicitly register it at the appropriate time. See ``AppDelegate.swift`` in the example project:
```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // --- Provider 注册示例 ---
        // 很明显大部分功能需要在业务初始化之前创建
        
        // scene 主要是为了 keyWindow 的自动实现
        if #available(iOS 13.0, *) {
            DTB.Providers.register(DTB.DefaultSceneProvider(), key: DTB.Providers.sceneKey)
        }
        // 确保 topMost 方法无误，最稳妥的方法就是传入 window 实例
        DTB.Providers.register(DTB.DefaultWindowProvider(window), key: DTB.Providers.windowKey)
        
        // 如果需要国际化 / 自定义主题
        DTB.Providers.register(DTB.ColorManager.shared, key: DTB.Providers.colorKey)
        DTB.Providers.register(DTB.I18NManager.shared, key: DTB.Providers.stringKey)
        DTB.Providers.register(DTB.FontManager.shared, key: DTB.Providers.fontKey)
        
        // UI 组件
        DTB.Providers.register(DTB.DefaultHUDProvider(), key: DTB.Providers.hudKey)
        DTB.Providers.register(DTB.DefaultToastProvider(), key: DTB.Providers.toastKey)
        DTB.Providers.register(DTB.DefaultAlertProvider(), key: DTB.Providers.alertKey)
        
        // --- Provider 注册结束 ---
        
        /// 假设这是业务
        NotificationCenter.default.addObserver(self, selector: #selector(appRestartEvent), name: Self.restartNotificationKey, object: nil)
        appRestartEvent()
        
        window?.makeKeyAndVisible()

        adapter()
        debugger()
        
        return true
    }
```

#### Advanced Usage

Suppose you have two different modules A and B, where module B has a method called `testB`. You can replace `dtb` with your own custom keyword `b` and prevent modules that haven't imported B from using that method:

```swift
// In project B
UIView().b.testB()  // OK
UIView().dtb.testB()  // OK

// In Project A
UIView().dtb.testB()  // fatal error.
```

I recommend reading the detailed explanation in the [wiki](https://github.com/darkThanBlack/DTBKit/wiki) and taking action only after fully understanding the source code.



## LLM

The markdown files in the root directory focus more on feature development usage. Please have AI read the specified LLM-friendly documentation.



## Change Log

> Update: 2025/12/11    Clear README.md.
>
> Update: 2024/08/14    Add sample codes for custom namespace.
>
> Update: 2024/09/20    Add Carthage / SwiftPM support.
>
> Update: 2024/09/21    Deploy jazzy docs on gh-pages.

