//
//  DiskUsageViewModel.swift
//  XMSport
//
//  Created by moonShadow on 2025/6/27
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

protocol DiskUsageViewModelDelegate: AnyObject {
    
    /// loading 处理
    func needUpdateLoadingUIState(_ isLoading: Bool)
}

/// 存储空间
class DiskUsageViewModel {
    
    weak var delegate: DiskUsageViewModelDelegate?
    
    private(set) var usage = DiskUsageModel()
    
    private(set) var caches: [DiskCacheHintViewDataSource] = []
    
    func reloadData(_ completed: (() -> ())?) {
        guard usage.isLoading == false else {
            return
        }
        usage.isLoading = true
        self.delegate?.needUpdateLoadingUIState(true)
        
        var phoneInfo: DTB.DiskCacheManager.PhoneInfo? = nil
        var appUsage: Int64? = nil
        let appCache = DiskCacheModel(bizType: .dataCache)
        
        /// 异步并行
        let group = DispatchGroup()
        
        group.enter()
        DTB.DiskCacheManager.shared.calculatePhoneDiskInfo { result in
            phoneInfo = result
            group.leave()
        }
        
        group.enter()
        DTB.DiskCacheManager.shared.calculateAppDiskUsage { result in
            appUsage = result
            group.leave()
        }
        
        group.enter()
        DTB.DiskCacheManager.shared.calculateDiskSizes { result in
            let allUsage = result.reduce(0) { res, next in
                return res + next.value
            }
            appCache.usage = allUsage
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.usage.isLoading = false
            self.delegate?.needUpdateLoadingUIState(false)
            
            self.usage.rawPhoneInfo = phoneInfo
            self.usage.rawAppUsage = appUsage
            self.usage.updateTime = Date().timeIntervalSince1970
            self.caches = [appCache]
            completed?()
        }
    }
}
