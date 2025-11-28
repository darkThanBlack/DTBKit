//
//  AlertActionCreater.swift
//  DTBKit
//
//  Created by moonShadow on 2025/11/28
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    ///
    open class AlertActionCreater: Kitable, Chainable {
        
        public var title: String? = nil
        
        public var attrTitle: NSAttributedString? = nil
        
        public var extra: Any? = nil
        
        public var handler: ((AlertActionCreater) -> Void)? = nil
        
        public init(title: String? = nil, attrTitle: NSAttributedString? = nil, extra: Any? = nil, handler: ((AlertActionCreater) -> Void)? = nil) {
            self.title = title
            self.attrTitle = attrTitle
            self.extra = extra
            self.handler = handler
        }
    }
}
