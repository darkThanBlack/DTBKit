//
//  AlertProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2025/10/10
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

public protocol AlertProvider {
    
    func show(_ params: AlertCreater)
}

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

extension DTB {
    
    @inline(__always)
    public static func alert() -> Wrapper<AlertCreater> {
        return AlertCreater().dtb
    }
}

///
open class AlertCreater: Kitable, Chainable {
    
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

// MARK: - Chain

extension Wrapper where Base: AlertCreater {

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
    public func addAction(_ value: AlertActionCreater) -> Self {
        me.actions.append(value)
        return self
    }
    
    @discardableResult
    public func show(_ params: Any? = nil) -> Self {
        DTB.app.get(DTB.BasicInterface.alertKey)?.show(me)
        return self
    }
}

extension Wrapper where Base: AlertActionCreater {
    
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
    public func handler(_ value: ((AlertActionCreater) -> Void)?) -> Self {
        me.handler = value
        return self
    }
}
