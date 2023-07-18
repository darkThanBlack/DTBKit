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

extension DTBKitWrapper where Base: UIImage {
    
    /// Create resource image by name, no matter where it is
    ///
    /// [refer](https://juejin.cn/post/6844903559931117581)
    ///
    /// - Parameters:
    ///   - name: image name
    ///   - bundleName: resource bundle
    ///   - types: image suffix
    /// - Returns: ``UIImage(named:)`` or ``UIImage(contentsOfFile:)``
    public func named(
        _ name: String,
        bundleName: String? = nil,
        types: [String] = ["png", "jpg", "webp", "jpeg"]
    ) -> UIImage? {
        /// single type
        func bundleImage(
            named name: String,
            type: String,
            mainBundle: Bundle,
            bizBundleName: String
        ) -> UIImage? {
            ///
            func create(by target: Bundle) -> UIImage? {
                if let image = UIImage(named: name, in: target, compatibleWith: nil) {
                    return image
                }
                if let path = target.path(forResource: name, ofType: type) {
                    return UIImage(contentsOfFile: path)
                }
                return nil
            }
            // main/*.*
            if let image = create(by: mainBundle) {
                return image
            }
            // main/*.bundle/*.*
            if let path = mainBundle.path(forResource: bizBundleName, ofType: "bundle"),
               let bundle = Bundle(path: path),
               let image = create(by: bundle) {
                return image
            }
            // main/*.bundle/*.{xcassets, car}/*.*
            if let path = mainBundle.resourcePath,
               let bundle = Bundle(path: path + "/\(bizBundleName).bundle"),
               let image = create(by: bundle) {
                return image
            }
            // main/Frameworks/*.framework/*.bundle/*.*
            if let path = mainBundle.resourcePath,
               let bundle = Bundle(path: path + "/Frameworks/%@.framework/\(bizBundleName).bundle"),
               let image = create(by: bundle) {
                return image
            }
            return nil
        }
        
        /// recursion for every type
        func image(index: Int = 0, main: Bundle, biz: String) -> UIImage? {
            guard index < types.count else {
                return nil
            }
            if let image = bundleImage(named: name, type: types[index], mainBundle: main, bizBundleName: biz) {
                return image
            } else {
                return image(index: index + 1, main: main, biz: biz)
            }
        }
        
        guard let biz = bundleName else {
            return UIImage(named: name)
        }
        var bundle: Bundle? = nil
#if SWIFT_PACKAGE
        bundle = SWIFTPM_MODULE_BUNDLE
#else
        bundle = Bundle(for: Base.self)
#endif
        // Proj.{SPM, Pods, framework, ...}
        if let third = bundle,
           let image = image(main: third, biz: biz) {
            return image
        }
        // Proj.main
        if let image = image(main: Bundle.main, biz: biz) {
            return image
        }
        // Proj.xcassets
        return UIImage(named: name)
    }
    
    /// Convert
    public func ci() -> CIImage? {
        if let ci = me.ciImage {
            return ci
        }
        if let cg = me.cgImage {
            return CIImage(cgImage: cg)
        }
        return CIImage(image: me)
    }
    
    /// Down sampling
    ///
    /// [refer](https://juejin.cn/post/6844903988077281288#heading-2)
    ///
    /// - Parameter value: result max side
    /// - Returns: UIImage?
    public func scale(to value: CGFloat) -> UIImage? {
        let nSize = me.size.dtb.aspectFit(to: CGSize(width: value, height: value))
        guard nSize.dtb.isEmpty == false else {
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
        ) else  {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: w, height: h)
        context.draw(cgImage, in: rect)
        guard let ref = context.makeImage() else {
            return nil
        }
        return UIImage(cgImage: ref, scale: me.scale, orientation: me.imageOrientation)
    }
}
