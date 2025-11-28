//
//  AlertActionCreater+Chain.swift
//  DTBKit
//
//  Created by moonShadow on 2025/11/28
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension Wrapper where Base: DTB.AlertActionCreater {
    
    @discardableResult
    public func title(_ value: String?) -> Self {
        me.title = value
        return self
    }
    
    @discardableResult
    public func extra(_ value: Any?) -> Self {
        me.extra = value
        return self
    }
    
    @discardableResult
    public func handler(_ value: ((DTB.AlertActionCreater) -> Void)?) -> Self {
        me.handler = value
        return self
    }
}
