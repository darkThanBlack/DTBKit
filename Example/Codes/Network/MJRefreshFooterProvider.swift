//
//  MJRefreshFooterProvider.swift
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
    
    public static let mjRefreshFooterKey = DTB.ConstKey<any MJRefreshFooterProvider>("dtb.providers.mjrefresh.footer")
    
    public protocol MJRefreshFooterProvider {
        func create(_ param: Any?) -> MJRefreshFooter?
    }
}
