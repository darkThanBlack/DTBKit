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

extension DTB {
    
    public static func registerUIProviders() {
        DTB.BasicInterface.registerProvider(DefaultHUDProvider(), key: DTB.BasicInterface.hudKey)
        DTB.BasicInterface.registerProvider(DefaultToastProvider(), key: DTB.BasicInterface.toastKey)
    }
}
