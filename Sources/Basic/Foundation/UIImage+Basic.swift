//
//  UIImage+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/18
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

// MARK: -

/// Convert
extension Wrapper where Base: UIImage {
    
    ///
    public func ci() -> Wrapper<CIImage>? {
        if let ci = me.ciImage {
            return ci.dtb
        }
        if let cg = me.cgImage {
            return CIImage(cgImage: cg).dtb
        }
        return CIImage(image: me)?.dtb
    }
    
}

/// Redraw
extension Wrapper where Base: UIImage {
    
    /// Down sampling to fit.
    ///
    /// 图片下采样。将图片等比缩放至最长边与传入的 value 相等。
    ///
    /// [refer](https://juejin.cn/post/6844903988077281288#heading-2)
    ///
    /// - Parameter value: result will aspect fit to value.
    ///
    /// - Returns: nil if scale fail.
    public func scale(to value: CGFloat) -> Wrapper<UIImage>? {
        let nSize = me.size.dtb.aspectFit(to: CGSize(width: value, height: value)).value
        guard nSize.dtb.isEmpty() == false else {
            return nil
        }
        
        let w = Int(nSize.width)
        let h = Int(nSize.height)
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * w
        let bitsPerComponent = 8
        guard let cgImage = me.cgImage else {
            return nil
        }
        guard let context = CGContext(
            data: nil,
            width: w,
            height: h,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: w, height: h)
        context.draw(cgImage, in: rect)
        guard let ref = context.makeImage() else {
            return nil
        }
        return UIImage(cgImage: ref, scale: me.scale, orientation: me.imageOrientation).dtb
    }
    
    /// 图片裁剪
    /// - Parameter ratio: 宽高比
    /// - Returns: 裁剪之后的图片
    func clip(_ ratio: CGFloat) -> UIImage {
        var rect = CGRect(origin: .zero, size: me.size)
        let width = me.size.width
        let height = me.size.height
        if width / height == ratio || ratio == 0 {
            return me
        }
        if width / height > ratio {
            rect.size.width = height * ratio
            rect.origin.x = (width - rect.size.width) / 2
        } else {
            rect.size.height = width / ratio
            rect.origin.y = (height - rect.size.height) / 2
        }
        guard let img = me.cgImage?.cropping(to: rect) else {
            return me
        }
        return UIImage(cgImage: img)
    }
}
