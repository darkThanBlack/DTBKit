//
//  Container.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/2
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    enum LazyLayoutsEventTypes: String, CaseIterable {
        /// 延迟到 view 的 didMoveToSuperview 被调用时执行
        case constraint
        /// 延迟到 view 的 layoutSubviews 被调用时执行
        case frame
    }
    
    protocol LazyLayouts: UIView {
        
        var lazyLayoutEventsPool_: [DTB.LazyLayoutsEventTypes: [(UIView) -> ()]] { set get }
        
        /// Must be call on layoutSubviews
        func lazyLayoutsWhenLayoutSubviews_()
        
        /// Must be call on didMoveToSuperview
        func lazyLayoutsWhenDidMoveToSuperview_()
        
        func lazyLayout(_ type: DTB.LazyLayoutsEventTypes, eventHandler: @escaping ((UIView) -> ()))
    }
}

extension DTB.LazyLayouts {
    
    /// 
    func lazyLayout(_ type: DTB.LazyLayoutsEventTypes = .frame, eventHandler: @escaping ((UIView) -> ())) {
        switch type {
        case .constraint:
            if superview != nil {
                eventHandler(self)
                return
            }
        case .frame:
            if bounds.isEmpty == false {
                eventHandler(self)
                return
            }
        }
        // create array if needed
        if lazyLayoutEventsPool_[type] == nil {
            lazyLayoutEventsPool_[type] = []
        }
        // 兜底
        if lazyLayoutEventsPool_[type]?.count ?? 0 > 200 {
            DTB.console.error("\(type.rawValue) events too much, check logic")
            lazyLayoutEventsPool_[type]?.removeAll()
        }
        // 添加
        lazyLayoutEventsPool_[type]?.append(eventHandler)
    }
    
    func lazyLayoutsWhenDidMoveToSuperview_() {
        if superview != nil {
            fireEvents(by: .constraint)
        } else {
            clearEvents(by: .constraint)
        }
    }

    func lazyLayoutsWhenLayoutSubviews_() {
        guard bounds.isEmpty == false else {
            return
        }
        fireEvents(by: .frame)
    }
    
    private func clearEvents(by type: DTB.LazyLayoutsEventTypes) {
        if lazyLayoutEventsPool_[type]?.count ?? 0 > 0 {
            DTB.console.error("event clear too early, check logic")
        }
        lazyLayoutEventsPool_[type]?.removeAll()
    }
    
    private func fireEvents(by type: DTB.LazyLayoutsEventTypes) {
        guard var events = lazyLayoutEventsPool_[type], events.isEmpty == false else { return }
        lazyLayoutEventsPool_[type] = []
        // 按添加顺序执行
        while events.count > 0 {
            events.removeFirst()(self)
        }
    }
    
}
