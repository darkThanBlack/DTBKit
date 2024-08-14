# DTBKit

 [![Static Badge](https://img.shields.io/badge/iOS-Swift-green)]() [![Static Badge](https://img.shields.io/badge/Cocoapods-1.12.1-green)]()

 ![Static Badge](https://img.shields.io/badge/Translate_by-Google-blue)



[English](https://github.com/darkThanBlack/DTBKit/blob/main/README.md) |  [简体中文](https://github.com/darkThanBlack/DTBKit/blob/main/README.zh-CN.md)



## What's this?

> A set of personal bundle kits designed to demonstrate best practices in various scenarios;
>
> Focus on painless migration of business code across projects.



When business grows or new projects are developed, we generally want

* Reuse part of the code
* Also isolate projects

This topic is very grand. In short, I think

* Strict modularity is not realistic for independent developers and small teams;

* The isolation method pioneered by ``KingFisher`` is very good, but if you want to extend it to the entire business project, you need to consider more.

This project is some reflection on this issue.



## Start



#### Run example

需要先通过 ``homebrew`` 安装 ``xcodegen``，用来生成 ``*.xcodeproj`` 文件。

```shell
# Use script
cd Scripts
chmod +x ci.sh
./ci.sh
b1

# Same as:
cd Example
xcodegen
pod install
```



#### Cocoapods

```ruby
# Add to main project podfile:
source 'https://github.com/darkThanBlack/Specs.git'
# then:
pod 'DTBKit/Core', tag: '0.0.1'

# Or:
pod 'DTBKit/Core', git: 'https://github.com/darkThanBlack/DTBKit', commit: '3f93179af6c2caa1e8bd0c418820947fe1aae899'
```



#### Intro

* Any object can have a special "namespace". Taking ``UIView`` as an example, you can:

    ```swift
    /// 
    UIView().dtb
    /// static / class func
    UIView.dtb
    ```

* Then, you can call ``test`` func like this:

    ```swift
    UIView().dtb.test()
    ```

* For different project / module, you can replace ``dtb`` with your own definition:

    ```swift
    UIView().xm.test()
    ```

* Add your own methods:

    ```swift
    UIView().xm.test2()
    ```

* Most of them is chainable:

    ```swift
    let titleLabel = UILabel().dtb.title("moon").value
    titleLabel.backgroundColor = .white
    ```



#### Conventions

Common English words are **definitely** used up by various programming languages and frameworks, so you need to be very careful in naming, and allow users to agree on the words they are used to.

Currently, the use of the framework only needs to pay attention to the following logic:

* Object methods start with ``UIView().dtb``
* Class methods start with ``UIView.dtb``
* Most objects will implement class methods named ``create``, which are used when creating objects
* ``value``, all boxed objects will implement this property, used for unpacking



#### Extension

Add the following code to main project:

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



#### Private Cocoapods

Move the above code into your private library, and

```ruby
# private dependency Unable to specify version
ss.dependency 'DTBKit/Core'

# So add source to your private library's main project
source 'https://github.com/darkThanBlack/Specs.git'

# Or:
pod 'DTBKit/Core', git: 'https://github.com/darkThanBlack/DTBKit', commit: '3f93179af6c2caa1e8bd0c418820947fe1aae899'
```



#### Tests

Cocoapods test supported:

```ruby
pod 'DTBKit/Basic', :testspecs => ['Tests']
```

 Xcode > Schemes > Select ``DTBKit``,  ``Command + U`` .



## Example

> Main dev proj & Test Cases.

## Core

> Namespace declaration.



## Chain

> Fast create.



## Basic

> Basic helper methods.



## UIKit

> UIKit helper methods.



## Author

moonShadow.



## License

DTBKit is available under the MIT license. See the LICENSE file for more info.



## Edited

> Update: 2024/08/14    README - Start
