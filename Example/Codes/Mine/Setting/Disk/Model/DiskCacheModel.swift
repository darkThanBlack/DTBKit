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

/// 业务缓存
class DiskCacheModel {
    
    enum BizTypes: String {
        
        case dataCache
    }
    
    let bizType: BizTypes
    
    var usage: Int64? = nil
    
    init(bizType: BizTypes) {
        self.bizType = bizType
    }
}

extension DiskCacheModel: DiskCacheHintViewDataSource {
    
    var primaryKey: String {
        return bizType.rawValue
    }
    
    var usageText: String? {
        /// 总数值超过 x KB 时再展示，避免用户焦虑
        let fake = {
            if let u = usage, u > DiskUsageDepends.fakeZeroSize() {
                return u
            }
            return 0
        }()
        return DTB.DiskCacheManager.shared.formatFileSize(fake)
    }
    
    var titleText: String? {
        switch bizType {
        case .dataCache:
            return "数据缓存"
        }
    }
    
    var detailText: String? {
        switch bizType {
        case .dataCache:
            return "使用过程中产生的临时数据，清理后流量消耗会增加，但不影响正常使用。"
        }
    }
    
    var buttonTitle: String? {
        switch bizType {
        case .dataCache:
            return "清理"
        }
    }
}
