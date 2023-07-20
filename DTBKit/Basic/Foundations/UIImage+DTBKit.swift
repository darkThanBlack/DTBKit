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

extension DTBKitWrapper where Base == UIImage? {
    
    /// Create resource image by name
    ///
    /// Will recursion searh all "types" in:
    ///
    /// * ``Proj.xcassets``
    ///   * same as ``UIImage(named:)``
    ///
    /// * ``Proj.main``
    ///   * when you put image in main proj source code
    ///
    /// * ``Proj.main/*.bundle/*.*``
    ///   * when you put bundle in main proj source code
    ///
    /// * ``Proj.main/*.bundle/*.{xcassets, car}/*.*``
    ///   * when you use ``*.xcassets`` in custom bundle
    ///
    /// * ``Proj.{SPM, Pods, framework, ...}/``
    ///   * when your code is third part
    ///
    /// Sample:
    /// ```
    ///   // type is UIImage?
    ///   let image = DTBKitWrapper<UIImage?>(named: "logo", bundleName: "DTBKit")?.me
    ///
    ///   // or you can use UIImageView extension in ``UIImageView+DTBKit.swift``
    ///   let imageView = UIImageView()
    ///   imageView.dtb.setImage(named: "logo", bundleName: "DTBKit")
    /// ```
    ///
    /// [refer](https://juejin.cn/post/6844903559931117581)
    ///
    /// - Parameters:
    ///   - name: image name
    ///   - bundleName: ``/*.bundle/``
    ///   - frameworkName: ``/*.framework/``，default is equal to "bundleName"
    ///   - classType: ``Bundle(for: )``, pass ``nil`` or ``self``
    ///   - types: image suffix
    public init?(
        named name: String,
        bundleName: String? = nil,
        frameworkName: String? = nil,
        classType: AnyClass? = nil,
        types: [String] = ["png", "jpg", "webp", "jpeg"]
    ) where Base == UIImage? {
        ///
        func bundleImage(
            named name: String,
            type: String,
            mainBundle: Bundle
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
            guard let biz = bundleName else {
                return nil
            }
            // main/*.bundle/*.*
            if let path = mainBundle.path(forResource: biz, ofType: "bundle"),
               let bundle = Bundle(path: path),
               let image = create(by: bundle) {
                return image
            }
            // main/*.bundle/*.{xcassets, car}/*.*
            if let path = mainBundle.resourcePath,
               let bundle = Bundle(path: path + "/\(biz).bundle"),
               let image = create(by: bundle) {
                return image
            }
            // main/Frameworks/*.framework/*.bundle/*.*
            if let path = mainBundle.resourcePath,
               let bundle = Bundle(path: path + "/Frameworks/\(frameworkName ?? biz).framework/\(biz).bundle"),
               let image = create(by: bundle) {
                return image
            }
            return nil
        }
        
        /// recursion for every type
        func image(index: Int = 0, main: Bundle) -> UIImage? {
            guard index < types.count else {
                return nil
            }
            if let image = bundleImage(named: name, type: types[index], mainBundle: main) {
                return image
            } else {
                return image(index: index + 1, main: main)
            }
        }
        
        // Default
        if bundleName == nil, let image = UIImage(named: name) {
            me = image
            return
        }
        // Proj.{SPM, Pods, framework, ...}
        var bundle: Bundle? = nil
#if SWIFT_PACKAGE
        bundle = SWIFTPM_MODULE_BUNDLE
#else
        if let t = classType {
            bundle = Bundle(for: t)
        }
#endif
        if let third = bundle,
           let image = image(main: third) {
            me = image
            return
        }
        // Proj.main
        if let image = image(main: Bundle.main) {
            me = image
            return
        }
        // Proj.xcassets
        me = UIImage(named: name)
    }
}

extension DTBKitWrapper where Base: UIImage {
    
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
