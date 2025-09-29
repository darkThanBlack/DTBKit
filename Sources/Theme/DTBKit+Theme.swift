//
//  DefaultStringProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2025/9/26
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import Foundation

extension DTB {
    
    public static func registerThemeProviders() {
        DTB.BasicInterface.registerProvider(I18NManager.shared, key: DTB.BasicInterface.stringKey)
    }
}
