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

``xcodegen`` is needed, install it from ``homebrew`` firstly:

```shell
# install tools
brew install xcodegen

# Use script
cd DTBKit/Scripts
chmod +x ci.sh
./ci.sh
# shell option
b1

# Same as:
cd DTBKit/Example
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



#### How to use default methods?

Common English words are **definitely** used up by various programming languages and frameworks, so you need to be very careful in naming, and allow users to agree on the words they are used to.

Currently, the use of the framework only needs to pay attention to the following logic:

* Object methods start with ``UIView().dtb``
* Class methods start with ``UIView.dtb``
* Most objects will implement class methods named ``create``, which are used when creating objects
* ``value``, all boxed objects will implement this property, used for unpacking



#### How to replace the name?

For example, the default call looks like this:

```swift
if (DTB.app.version == "1.0.0") {
UIView().dtb.toast("is old version")
}
```

You may want to replace the prefix and property name with ``XM`` and ``xm`` to match your own project naming conventions:

```swift
if (XM.app.version == "1.0.0") {
UIView().xm.toast("is old version")
}
```

Then, create a new ``DTBKit+XM.swift`` file and add the following code:

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

If you use other sub-repositories at the same time, follow the same pattern:

```swift
// - Chain

public typealias XMKitChainable = DTBKit.DTBKitChainable

public typealias XMKitStructChainable = DTBKit.DTBKitStructChainable

public typealias XMKitMutableWrapper = DTBKit.DTBKitMutableWrapper
```

Now, the new method call can be used within the scope of the ``DTBKit+XM.swift`` file.



#### How to add custom methods?

Refer to the source code and add the corresponding ``extension`` to ``wrapper``.



#### How to modulize?

The control of the scope depends entirely on your control over the extension and protocol declaration files themselves.

For example, if there is a main project Main, with a custom module XM and a module Other, both of which depend on the basic module Basic. First, make the following adjustments to ``DTBKit+XM.swift`` in module XM: 

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

Now we have a clean ``protocol``:

* The object still does not have the ``xm`` attribute;

* The ``xm`` attribute itself cannot use methods implemented in other modules, including those provided by ``DTBKit`` itself;

Next, create ``CGSize+XM.swift`` in the XM module and write some business:

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

Obviously, when CGSize can use the ``xm`` attribute depends on the scope of ``Mark 1``, and the scope of CGSize The methods of the ``xm`` attribute depend on the scope of ``Mark 2``. You can combine the above methods to achieve what you need.



#### How to use in your private cocoapods?

Move the above code into your private library, and

```ruby
# private dependency Unable to specify version
ss.dependency 'DTBKit/Core'

# So add source to your private library's main project
source 'https://github.com/darkThanBlack/Specs.git'

# Or:
pod 'DTBKit/Core', git: 'https://github.com/darkThanBlack/DTBKit', commit: '3f93179af6c2caa1e8bd0c418820947fe1aae899'
```



#### Unit Tests

Cocoapods test supported:

```ruby
pod 'DTBKit/Basic', :testspecs => ['Tests']
```

 Xcode > Schemes > Select ``DTBKit``,  ``Command + U`` .



## Blogs

 [Namespace & Chain](https://darkthanblack.github.io/blogs/06-bp-namespace/)



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



### API docs

Auto created by [jazzy](https://github.com/realm/jazzy) and deploy on ``gh-pages``, you can visit it from [HERE](https://darkthanblack.github.io/DTBKit).

```shell
# Deploy scripts
git checkout main;
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
git push
```



## Edited

> Update: 2024/08/14    README - Start.
>
> Update: 2024/09/20    Add Carthage / SwiftPM support.
>
> Update: 2024/09/21    Deploy jazzy docs on gh-pages.

