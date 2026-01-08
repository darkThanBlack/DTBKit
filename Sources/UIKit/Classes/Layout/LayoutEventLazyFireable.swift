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
    
    public enum LayoutEventLazyFireTiming: String, CaseIterable {
        /// ``didMoveToSuperview``
        case onAdded
        /// ``layoutSubviews``
        case onLayout
    }
    
    /// Use ``Self`` to lock in ``final`` class.
    ///
    /// Reason: if some subview override layoutSubviews and do some business code, trigger in superview func is too early.
    public protocol LayoutEventLazyFireable: UIView {
        
        var lazyLayoutEventsPool_: [DTB.LayoutEventLazyFireTiming: [(Self) -> ()]] { set get }
        
        /// Must be call on layoutSubviews
        func lazyLayoutsWhenLayoutSubviews_()
        
        /// Must be call on didMoveToSuperview
        func lazyLayoutsWhenDidMoveToSuperview_()
        
        /// Wait for a timed event to trigger all events. FIFO.
        func lazyFire(_ type: DTB.LayoutEventLazyFireTiming, eventHandler: @escaping ((Self) -> ()))
    }
}

public extension DTB.LayoutEventLazyFireable {
    
    /// Wait for a timed event to trigger all events. FIFO.
    ///
    /// - Note:
    ///   ``eventHandler`` param is same as ``self`` to avoid circular references.
    ///   ```
    ///     let view = DTB.Container()
    ///     view.lazyFire(.onAdded) { v in
    ///         // **NO**
    ///         view.backgroundColor = .yellow
    ///         // **YES**
    ///         v.backgroundColor = .yellow
    ///     }
    ///
    func lazyFire(_ type: DTB.LayoutEventLazyFireTiming = .onLayout, eventHandler: @escaping ((Self) -> ())) {
        switch type {
        case .onAdded:
            if superview != nil {
                eventHandler(self)
                return
            }
        case .onLayout:
            if bounds.isEmpty == false {
                eventHandler(self)
                return
            }
            // Ensure ``layoutSubviews`` will be fired
            setNeedsLayout()
        }
        // create array if needed
        if lazyLayoutEventsPool_[type] == nil {
            lazyLayoutEventsPool_[type] = []
        }
        // Too much event means unexpect error
        if lazyLayoutEventsPool_[type]?.count ?? 0 > 200 {
            DTB.console.error("\(type.rawValue) events too much, check logic")
            lazyLayoutEventsPool_[type]?.removeAll()
        }
        lazyLayoutEventsPool_[type]?.append(eventHandler)
    }
    
    func lazyLayoutsWhenDidMoveToSuperview_() {
        if superview != nil {
            fireEvents(by: .onAdded)
        } else {
            clearEvents(by: .onAdded)
        }
    }
    
    func lazyLayoutsWhenLayoutSubviews_() {
        guard bounds.isEmpty == false else {
            return
        }
        fireEvents(by: .onLayout)
    }
    
    private func clearEvents(by type: DTB.LayoutEventLazyFireTiming) {
        if lazyLayoutEventsPool_[type]?.count ?? 0 > 0 {
            DTB.console.error("event clear too early, check logic")
        }
        lazyLayoutEventsPool_[type]?.removeAll()
    }
    
    private func fireEvents(by type: DTB.LayoutEventLazyFireTiming) {
        guard var events = lazyLayoutEventsPool_[type], events.isEmpty == false else { return }
        lazyLayoutEventsPool_[type] = []
        // FIFO
        while events.count > 0 {
            events.removeFirst()(self)
        }
    }
    
}
