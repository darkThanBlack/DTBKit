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

///
extension StaticWrapper where T: UIImage {
    
    /// Create resource image by name.
    ///
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
    /// [refer](https://juejin.cn/post/6844903559931117581)
    ///
    /// - Parameters:
    ///   - imageName: imageName description
    ///   - bundle: bundle description
    /// - Returns: description
    public func create(_ imageName: String?, bundle: Bundle? = nil) -> UIImage? {
        guard let name = imageName, name.isEmpty == false else {
            return nil
        }
        
        let cacheKey = DTB.ConstKey<[String: String]>("DTBKitBundleImagePathKey")
        
        /// 尝试在指定的 bundle 中创建
        ///
        /// Search image with name in specify bundle.
        func createWithBundle(_ target: Bundle) -> UIImage? {
            // ``*.{xcassets, car}/name.*``
            if let result = UIImage(named: name, in: target, compatibleWith: nil) {
                return result
            }
            // ``**/*/name.type``
            for type in DTB.Configuration.shared.supportImageTypes {
                if let path = target.path(forResource: name, ofType: type),
                   let result = UIImage(contentsOfFile: path) {
                    return result
                }
            }
            return nil
        }
        
        if let imageBundle = bundle {
            // Specify bundle
            return createWithBundle(imageBundle)
        } else {
            // FIDTBE: SwiftPM
            // I got ``Cannot find 'SWIFTPM_MODULE_BUNDLE' in scope`` in SPM
            // https://gist.github.com/bradhowes/4cd0b3da56b24166243e88d77329e909
//#if SWIFT_PACKAGE
//            if let result = createWithBundle(SWIFTPM_MODULE_BUNDLE) {
//                return result
//            }
//#endif
            // check cached name
            var cacheDict = DTB.app.get(cacheKey) ?? [:]
            if let path = cacheDict[name],
                path.isEmpty == false,
               let result = UIImage(contentsOfFile: path) {
                return result
            }
            
            // search sub paths
            let subPaths: [String] = {
                var paths: [String] = []
                let suffixs = DTB.Configuration.shared.supportImageTypes.compactMap({ "\(name).\($0)" })
                if let mainPath = Bundle.main.resourcePath,
                   let dirEnum = FileManager.default.enumerator(atPath: mainPath) {
                    while let file = dirEnum.nextObject() as? String {
                        if suffixs.contains(where: { file.hasSuffix($0) }) {
                            paths.append("\(mainPath)/\(file)")
                        }
                    }
                }
                return paths
            }()
            for path in subPaths {
                if let result = UIImage(contentsOfFile: path) {
                    cacheDict[name] = path
                    DTB.app.set(cacheDict, key: cacheKey)
                    return result
                }
            }
            
            // ``Proj.xcassets``
            return UIImage(named: name)
        }
    }
}

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
