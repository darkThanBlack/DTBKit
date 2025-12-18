//
//  Axis.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/18
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// Replacement for ``NSLayoutConstraint.Axis``
    ///
    ///  Reason: to avoid @unknown default from ObjC, if you:
    ///  ```
    ///  extension NSLayoutConstraint.Axis {
    ///      public static let h: Self = .horizontal
    ///      public static let v: Self = .vertical
    ///  }
    ///  ```
    @frozen
    public enum Axis: CaseIterable {
        /// NSLayoutConstraint.Axis.horizontal
        case h
        /// NSLayoutConstraint.Axis.vertical
        case v
        
        public var nsValue: NSLayoutConstraint.Axis {
            switch self {
            case .h:  return .horizontal
            case .v:  return .vertical
            }
        }
    }
}
