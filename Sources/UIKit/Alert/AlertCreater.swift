//
//  AlertCreater.swift
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
    open class AlertCreater: Kitable {
        
        public var title: String? = nil
        
        public var attrTitle: NSAttributedString? = nil
        
        public var message: String? = nil
        
        public var attrMessage: NSAttributedString? = nil
        
        public var extra: Any? = nil
        
        public var actions: [AlertActionCreater] = []
        
        public init(title: String? = nil, attrTitle: NSAttributedString? = nil, message: String? = nil, attrMessage: NSAttributedString? = nil, extra: Any? = nil, actions: [AlertActionCreater] = []) {
            self.title = title
            self.attrTitle = attrTitle
            self.message = message
            self.attrMessage = attrMessage
            self.extra = extra
            self.actions = actions
        }
    }
}
