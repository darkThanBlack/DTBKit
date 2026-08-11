//
//  DiskCacheModel.swift
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
    
    /// 将不同业务类型数据归类, 这个 model 是对默认缓存的实现
    class DiskCacheModel {
        
        static let key = "data_cache"
        
        var usage: Int64? = nil
    }
}

extension DTB.DiskCacheModel: DTB.DiskCacheHintViewDataSource {
    
    var primaryKey: String {
        return Self.key
    }
    
    var usageText: String? {
        /// 总数值超过 x KB 时再展示，避免用户焦虑
        let fake = {
            if let u = usage, u > DTB.DiskUsageDepends.fakeZeroSize() {
                return u
            }
            return 0
        }()
        return DTB.DiskCacheManager.shared.formatFileSize(fake)
    }
    
    var titleText: String? {
        return DTB.DiskUsageDepends.cacheText()
    }
    
    var detailText: String? {
        return DTB.DiskUsageDepends.cacheDescText()
    }
    
    var buttonTitle: String? {
        return DTB.DiskUsageDepends.cleanText()
    }
}
