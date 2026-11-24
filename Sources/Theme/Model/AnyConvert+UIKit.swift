//
//  AnyConvert+UIKit.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/30
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB.AnyConvert {
    
    public func `uiEdgeInsets`(_ value: Any?) -> UIEdgeInsets? {
        guard let dict = value as? [String: Any] else { return nil }
        return UIEdgeInsets(
            top: double(dict["top"]) ?? 0,
            left: double(dict["left"]) ?? 0,
            bottom: double(dict["bottom"]) ?? 0,
            right: double(dict["right"]) ?? 0
        )
    }
    
    public func `cgSize`(_ value: Any?) -> CGSize? {
        guard let dict = value as? [String: Any] else { return nil }
        return CGSize(
            width: double(dict["width"]) ?? 0,
            height: double(dict["height"]) ?? 0
        )
    }
    
    public func `cgVector`(_ value: Any?) -> CGVector? {
        guard let dict = value as? [String: Any] else { return nil }
        return CGVector(
            dx: double(dict["dx"]) ?? 0,
            dy: double(dict["dy"]) ?? 0
        )
    }
}
