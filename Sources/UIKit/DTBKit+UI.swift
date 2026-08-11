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

@_exported import SnapKit

extension DTB.Notifications {
    
    public static let appNeedRestart = NSNotification.Name("kDTBKitAppNeedRestartKey")
}

extension DTB {
    
    /// UIKit constraints
    public static let layout = LayoutManager.shared
}
