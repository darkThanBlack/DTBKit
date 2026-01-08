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

extension DTB {
    
    /// Memory dict / App data / etc.
    public static let app = AppManager.shared
    
    /// LLDB Console, replacement for ``Swift.print``
    public static let console = ConsoleManager.shared
    
    /// Some features that require users to fully customize.
    ///
    /// 某些需要让开发者可以完全自定义的功能.
    public enum Providers: DTB.ProviderRegister {}
}

//MARK: - Implementation

///
extension NSObject: Kitable {}

