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

extension Int: Structable {}

extension Int8: Structable {}

extension Int16: Structable {}

extension Int32: Structable {}

extension Int64: Structable {}

extension Float: Structable {}

extension Double: Structable {}

extension String: Structable {}

extension CGFloat: Structable {}

extension Decimal: Structable {}

extension Array: Structable {}

extension Data: Structable {}

// MARK: - Abstract, more details in ``dtbkit_adapter.md``

extension StaticWrapper: DTBKitHUD where T: UIView {}

extension Wrapper: DTBKitHUD where Base: UIView {}

extension StaticWrapper: DTBKitToast where T: UIView {}

extension Wrapper: DTBKitToast where Base: UIView {}

@available(iOS 13.0, *)
extension StaticWrapper: DTBKitUIWindowScene where T: UIWindowScene {}

extension StaticWrapper: DTBKitUIWindow where T: UIWindow {}
