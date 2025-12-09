//
//  LayoutManager.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/9
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// UIKit constraints
public final class LayoutManager {
    
    public static let shared = LayoutManager()
    private init() {}
    
    @inline(__always)
    public func setPriorityLow(_ view: UIView, _ axis: NSLayoutConstraint.Axis) {
        view.setContentHuggingPriority(.defaultLow, for: axis)
        view.setContentCompressionResistancePriority(.defaultLow, for: axis)
    }
    
    @inline(__always)
    public func setPriorityHigh(_ view: UIView, _ axis: NSLayoutConstraint.Axis) {
        view.setContentHuggingPriority(.defaultHigh, for: axis)
        view.setContentCompressionResistancePriority(.defaultHigh, for: axis)
    }
    
    @inline(__always)
    public func setPriority(_ view: UIView, _ priority: UILayoutPriority, _ axis: NSLayoutConstraint.Axis) {
        view.setContentHuggingPriority(priority, for: axis)
        view.setContentCompressionResistancePriority(priority, for: axis)
    }
    
    @inline(__always)
    public func getSpacer(_ axis: NSLayoutConstraint.Axis) -> DTB.VoidView {
        let view = DTB.VoidView()
        view.setContentHuggingPriority(.fittingSizeLevel, for: axis)
        view.setContentCompressionResistancePriority(.fittingSizeLevel, for: axis)
        return view
    }
}

extension Wrapper where Base: UIView {
    
}
