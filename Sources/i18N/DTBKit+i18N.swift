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

// MARK: - Abstract, more details in ``dtbkit_adapter.md``

extension DTBKitStaticWrapper: DTBKitUIColor where T: UIColor {}

extension DTBKitStaticWrapper: DTBKitString where T == String {}
