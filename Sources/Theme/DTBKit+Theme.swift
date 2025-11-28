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
        DTB.Providers.register(DTB.ColorManager.shared, key: DTB.Providers.colorKey)
        DTB.Providers.register(DTB.I18NManager.shared, key: DTB.Providers.stringKey)
        DTB.Providers.register(DTB.FontManager.shared, key: DTB.Providers.fontKey)
    }
}
