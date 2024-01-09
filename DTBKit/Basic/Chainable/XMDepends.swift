//
//  XMDepends.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2024/1/8
//  Copyright © 2024 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

public typealias XMKitWrapper = DTBKitWrapper

public typealias XMKitMutableWrapper = DTBKitMutableWrapper

public typealias XMKitChainable = DTBKitChainable

extension DTBKitable {
    public var xm: DTBKitWrapper<Self> { return dtb }
    public static var xm: DTBKitStaticWrapper<Self> { return dtb }
}

extension DTBKitStructable {
    public var xm: DTBKitWrapper<Self> { return dtb }
    public static var xm: DTBKitStaticWrapper<Self> { return dtb }
}
