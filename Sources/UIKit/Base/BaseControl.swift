//
//  BaseControl.swift
//  DTBKit
//
//  Created by moonShadow on 2025/11/22
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    ///
    @objc(DTBBaseControl)
    open class BaseControl: UIControl {
        
        ///
        open func match<T>(_ dict: [UInt: T]) -> T? {
            if let result = dict[state.rawValue] {
                return result
            }
            /// Note: state.contains(0) always true
            if let bestKey = dict
                .compactMap({ UIControl.State(rawValue: $0.key) })
                .filter({ $0 == .normal ? (state == .normal) : state.contains($0) })
                .max(by: { $0.rawValue.nonzeroBitCount < $1.rawValue.nonzeroBitCount }) {
                return dict[bestKey.rawValue]
            }
            return dict[UIControl.State.normal.rawValue]
        }
        
    }
}
