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
    
    public protocol ControlStateConfigable: UIControl {
        
        associatedtype StateConfigType
        
        var stateConfig: [UInt: StateConfigType] { get set }
        
        func currentConfig() -> StateConfigType?
    }
}

extension DTB.ControlStateConfigable {
    
    func currentConfig() -> StateConfigType? {
        if let result = stateConfig[state.rawValue] {
            return result
        }
        /// Note: state.contains(0) always true
        if let bestKey = stateConfig
            .compactMap({ UIControl.State(rawValue: $0.key) })
            .filter({ $0 == .normal ? (state == .normal) : state.contains($0) })
            .max(by: { $0.rawValue.nonzeroBitCount < $1.rawValue.nonzeroBitCount }) {
            return stateConfig[bestKey.rawValue]
        }
        return stateConfig[UIControl.State.normal.rawValue]
    }
}

extension DTB {
    
    ///
    @objc(DTBBaseControl)
    open class BaseControl: UIControl {
        
//        open preferredState() -> UIControl.State {
//            
//        }
        
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

