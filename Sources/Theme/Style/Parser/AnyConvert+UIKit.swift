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
    
    public func `rectCorner`(_ value: Any?) -> UIRectCorner? {
        if let value = value as? UIRectCorner {
            return value.isEmpty ? nil : value
        }
        if let list = value as? [Any] {
            var result = UIRectCorner()
            for item in list {
                guard let corner = rectCorner(item) else { continue }
                result.formUnion(corner)
            }
            return result.isEmpty ? nil : result
        }
        if let value = value as? String {
            switch value.lowercased() {
            case "all", "allcorners": return .allCorners
            case "topleft": return .topLeft
            case "topright": return .topRight
            case "bottomleft": return .bottomLeft
            case "bottomright": return .bottomRight
            default: break
            }
        }
        guard let raw = int64(value), raw > 0, let rawValue = UInt(exactly: raw) else {
            return nil
        }
        let result = UIRectCorner(rawValue: rawValue)
        return result.isEmpty ? nil : result
    }
    
    public func `fillRule`(_ value: Any?) -> CAShapeLayerFillRule? {
        guard let value = value as? String else { return nil }
        switch value.lowercased() {
        case "nonzero": return .nonZero
        case "evenodd": return .evenOdd
        default: return nil
        }
    }
    
    public func `lineCap`(_ value: Any?) -> CAShapeLayerLineCap? {
        guard let value = value as? String else { return nil }
        switch value.lowercased() {
        case "butt": return .butt
        case "round": return .round
        case "square": return .square
        default: return nil
        }
    }
    
    public func `lineJoin`(_ value: Any?) -> CAShapeLayerLineJoin? {
        guard let value = value as? String else { return nil }
        switch value.lowercased() {
        case "miter": return .miter
        case "round": return .round
        case "bevel": return .bevel
        default: return nil
        }
    }
    
    public func `gradientLayerType`(_ value: Any?) -> CAGradientLayerType? {
        guard let value = value as? String else { return nil }
        switch value.lowercased() {
        case "axial": return .axial
        case "radial": return .radial
        case "conic": return .conic
        default: return nil
        }
    }
    
    public func `textAlignment`(_ value: Any?) -> NSTextAlignment? {
        if let value = value as? NSTextAlignment {
            return value
        }
        guard let value = value as? String else { return nil }
        switch value.lowercased() {
        case "left": return .left
        case "center": return .center
        case "right": return .right
        case "justified": return .justified
        case "natural": return .natural
        default: return nil
        }
    }
}
