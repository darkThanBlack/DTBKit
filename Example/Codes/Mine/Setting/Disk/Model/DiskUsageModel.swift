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

extension DiskUsageModel: DiskUsageProgressViewDataSource, DiskUsageHintViewDataSource {
    
    var appUsedPercent: CGFloat {
        guard let total = rawPhoneInfo?.total, total > 0,
              let app = rawAppUsage, app > 0 else {
            return 0.01
        }
        var result = CGFloat(app) / CGFloat(total)
        result = (result * 100).rounded() / 100
        // 至少展示 0.01%
        return max(DiskUsageDepends.minUsedPercent(), result)
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
        return  DiskUsageDepends.appName() + "已用空间"
    }
    
    var usageText: String? {
        guard let app = rawAppUsage, isLoading == false else {
            return "正在计算..."
        }
        return DTB.DiskCacheManager.shared.formatFileSize(app)
    }
    
    var percentText: String? {
        return "占据手机 \(appUsedPercent)% 存储空间"
    }
    
    var updateText: String? {
        guard let time = updateTime else {
            return "尚未计算"
        }
        return "上次计算: \(self.dateFormatter.string(from: Date(timeIntervalSince1970: time)))"
    }
}
