//
//  DiskUsageModel.swift
//  XMSport
//
//  Created by moonShadow on 2025/7/2
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// 存储空间
    class DiskUsageModel {
        
        var rawPhoneInfo: DTB.DiskCacheManager.PhoneInfo? = nil
        
        var rawAppUsage: Int64? = nil
        
        var updateTime: Double? = nil
        
        var isLoading: Bool = false
        
        private lazy var dateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return f
        }()
    }
    
}

extension DTB.DiskUsageModel: DTB.DiskUsageProgressViewDataSource, DTB.DiskUsageHintViewDataSource {
    
    var appUsedPercent: CGFloat {
        guard let total = rawPhoneInfo?.total, total > 0,
              let app = rawAppUsage, app > 0 else {
            return 0.01
        }
        var result = CGFloat(app) / CGFloat(total)
        result = (result * 100).rounded() / 100
        // 至少展示 0.01%
        return max(DTB.DiskUsageDepends.minUsedPercent(), result)
    }
    
    var otherUsedPercent: CGFloat {
        guard let total = rawPhoneInfo?.total, total > 0,
              let totalUsed = rawPhoneInfo?.totalUsed, totalUsed > 0,
              let app = rawAppUsage, app > 0 else {
            return 0
        }
        let result = CGFloat(abs(totalUsed - app)) / CGFloat(total)
        return (result * 100).rounded() / 100
    }
    
    var hintText: String? {
        return  DTB.DiskUsageDepends.usageHintText()
    }
    
    var usageText: String? {
        guard let app = rawAppUsage, isLoading == false else {
            return DTB.DiskUsageDepends.loadingText()
        }
        return DTB.DiskCacheManager.shared.formatFileSize(app)
    }
    
    var percentText: String? {
        return DTB.DiskUsageDepends.usagePercentText("\(appUsedPercent)")
    }
    
    var updateText: String? {
        guard let time = updateTime else {
            return DTB.DiskUsageDepends.unloadText()
        }
        return DTB.DiskUsageDepends.loadTimeText(self.dateFormatter.string(from: Date(timeIntervalSince1970: time)))
    }
}
