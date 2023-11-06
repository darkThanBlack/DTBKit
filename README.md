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



## Quick Start

View the example: It is recommended to install ``xcodegen``, enter the ``Example`` directory and execute ``xcodegen`` and ``pod install`` on the command line.

The project uses the cocoapods structure, but it has not been officially released. When using it, you need to use something similar to

```ruby
pod 'DTBKit', git: 'https://github.com/darkThanBlack/DTBKit', commit: 'dd3acb'
```

Specify the warehouse address and version number in the form.

The documentation and comments are bound to not be perfect, so please read the source code thoroughly before using it.



The usage of the code is very simple. First of all, in theory,

* Any object can have a special "namespace". Taking ``UIView`` as an example, you can:

     ```swift
     /// transfer
     UIView().dtb
     /// static method
     UIView.dtb
     ```

* Then, assuming you have a business method called ``test``, you can:

     ```swift
     UIView().dtb.test()
     ```

* For your own new project or business, you can replace the three words ``dtb`` with any name you like:

     ```swift
     UIView().xm
     ```

* Suppose there is a business method called ``test2`` in the new business:

     ```swift
     UIView().xm.test()
     UIView().dtb.test()
        
     UIView().xm.test2()
     UIView().dtb.test() // Compilation error
     ```

* For the new business ``xm``, it can directly call all methods in the ``dtb`` space. However, for the methods in the ``xm`` space, ``dtb`` cannot be called, and There will be no code prompts.

* Some methods support chain calls and will return an object ending with a ``wrapper`` name, and all ``wrapper`` objects have a ``value`` attribute, which is used to obtain the internal real object:

     ```swift
     let titleLabel = UILabel().dtb.title("moon").value
     titleLabel.backgroundColor = .white
     ```



## Demo

> How to import DTBKit & best practices.



## Example

> Main dev proj.



## Basic

> Static. Full test.



## UIKit

> Refer for UI bundles. 





## Author

moonShadow.



## License

DTBKit is available under the MIT license. See the LICENSE file for more info.
