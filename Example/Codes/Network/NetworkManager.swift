//
//  NetworkManager.swift
//  Ring
//
//  Created by moonShadow on 2026/6/3
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    public final class NetworkManager {
        
        public static let shared = NetworkManager()
        private init() {}
        
        ///
        public func host() -> String {
            return "https://dev-edutrip.xiaomai5.com"
        }
        
    }
}
