//
//  DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2023/6/28
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import Foundation
import UIKit

extension Int: DTBKitStructable {}

extension Int8: DTBKitStructable {}

extension Int16: DTBKitStructable {}

extension Int32: DTBKitStructable {}

extension Int64: DTBKitStructable {}

extension Float: DTBKitStructable {}

extension Double: DTBKitStructable {}

extension String: DTBKitStructable {}

extension CGFloat: DTBKitStructable {}

extension Decimal: DTBKitStructable {}

extension Array: DTBKitStructable {}

extension Data: DTBKitStructable {}

// MARK: - Abstract, more details in ``dtbkit_adapter.md``

extension DTBKitStaticWrapper: DTBKitHUD where T: UIView {}

extension DTBKitWrapper: DTBKitHUD where Base: UIView {}

extension DTBKitStaticWrapper: DTBKitToast where T: UIView {}

extension DTBKitWrapper: DTBKitToast where Base: UIView {}

@available(iOS 13.0, *)
extension DTBKitStaticWrapper: DTBKitUIWindowScene where T: UIWindowScene {}

extension DTBKitStaticWrapper: DTBKitUIWindow where T: UIWindow {}
