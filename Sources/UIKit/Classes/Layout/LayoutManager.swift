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
    
    /// Lowest priority on all edges.
    @inline(__always)
    public func spacer() -> DTB.VoidView {
        let view = DTB.VoidView()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        view.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        view.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        view.setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
        return view
    }
    
    /// Normarl priority with constant width or height.
    @inline(__always)
    public func sizedBox(width: CGFloat? = nil, height: CGFloat? = nil) -> DTB.Container {
        let view = DTB.Container()
        view.lazyFire(.onAdded) { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            if let w = width, w > 0 {
                v.widthAnchor.constraint(equalToConstant: w).isActive = true
            }
            if let h = height, h > 0 {
                v.heightAnchor.constraint(equalToConstant: h).isActive = true
            }
        }
        return view
    }
    
}
