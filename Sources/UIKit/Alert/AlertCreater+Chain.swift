//
//  AlertCreater+Chain.swift
//  DTBKit
//
//  Created by moonShadow on 2025/11/28
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension Wrapper where Base: DTB.AlertCreater {

    @discardableResult
    public func title(_ value: String?) -> Self {
        me.title = value
        return self
    }
    
    @discardableResult
    public func attrTitle(_ value: NSAttributedString?) -> Self {
        me.attrTitle = value
        return self
    }
    
    @discardableResult
    public func message(_ value: String?) -> Self {
        me.message = value
        return self
    }
    
    @discardableResult
    public func attrMessage(_ value: NSAttributedString?) -> Self {
        me.attrMessage = value
        return self
    }
    
    @discardableResult
    public func extra(_ value: Any?) -> Self {
        me.extra = value
        return self
    }
    
    @discardableResult
    public func addAction(_ value: DTB.AlertActionCreater) -> Self {
        me.actions.append(value)
        return self
    }
    
    @discardableResult
    public func show(_ params: Any? = nil) -> Self {
        DTB.Providers.get(DTB.Providers.alertKey)?.show(me)
        return self
    }
}
