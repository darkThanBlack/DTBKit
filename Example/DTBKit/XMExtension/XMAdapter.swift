//
//  XMAdapter.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/30
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

//@_exported import DTBKit

extension DTBKitable {
    public var xm: DTBKitWrapper<Self> { return dtb }
    public static var xm: DTBKitStaticWrapper<Self> { return dtb }
}

extension DTBKitStructable {
    public var xm: DTBKitWrapper<Self> { return dtb }
    public static var xm: DTBKitStaticWrapper<Self> { return dtb }
}

//MARK: - playground
