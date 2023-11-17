//
//  NSDecimalTypeAdapter.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/11/17
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

public protocol DTBKitNSDecimalNumberType {}

extension Double: DTBKitNSDecimalNumberType {}

extension String: DTBKitNSDecimalNumberType {}
