//
//  MJRefreshHeaderProvider.swift
//  Ring
//
//  Created by moonShadow on 2026/6/17
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import MJRefresh

extension DTB.Providers {
    
    public static let mjRefreshHeaderKey = DTB.ConstKey<any MJRefreshHeaderProvider>("dtb.providers.mjrefresh.header")
    
    public protocol MJRefreshHeaderProvider {
        func create(_ param: Any?) -> MJRefreshHeader?
    }
}
