//
//  DefaultLocalImageProvider.swift
//  Pods
//
//  Created by moonShadow on 2026/5/26
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    public final class DefaultLocalImageProvider: DTB.Providers.LocalImageProvider {
        
        public init() {}
        
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
        ///   - imageName: image name / path
        ///   - bundle: same as Bundle.dtb.create(:)
        public func create(_ param: Any?, bundle: Any?) -> UIImage? {
            
            /// 尝试在指定的 bundle 中创建
            ///
            /// Search image with name in specify bundle.
            func getImage(name: String, in target: Bundle) -> UIImage? {
                // - .bundle/*.{xcassets/car}/
                // - .bundle/*.{png/jpg/jpeg}
                if let result = UIImage(named: name, in: target, compatibleWith: nil) {
                    return result
                }
                // .bundle/**/*.{png/jpg/jpeg/webp}
                let fallbackTypes: [String] = {
                    if #available(iOS 14.0, *) {
                        return ["png", "jpg", "jpeg", "webp"]
                    } else {
                        return ["png", "jpg", "jpeg"]
                    }
                }()
                for type in fallbackTypes {
                    if let path = target.path(forResource: name, ofType: type),
                       let image = UIImage(contentsOfFile: path) {
                        return image
                    }
                }
                return nil
            }
            
            /// file url
            if let url = param as? URL, url.isFileURL,
               let image = UIImage(contentsOfFile: url.path) {
                return image
            }
            
            guard let name = param as? String, name.isEmpty == false else {
                return nil
            }
            
            // Absolute string path
            if name.contains("/"),
               FileManager.default.fileExists(atPath: name),
               let image = UIImage(contentsOfFile: name) {
                return image
            }
            // 如果指定了 bundle, 尝试 ``*.bundle/*.{xcassets/car}/name.{png/jpg/jpeg}``
            if let target = Bundle.dtb.create(bundle),
               let image = getImage(name: name, in: target) {
                return image
            }
            // Main
            if let image = UIImage(named: name) {
                return image
            }
            // SF Symbol
            if #available(iOS 13.0, *) {
                if let image = UIImage(systemName: name) {
                    return image
                }
            }
            // TODO: SwiftPM
            // I got ``Cannot find 'SWIFTPM_MODULE_BUNDLE' in scope`` in SPM
            // https://gist.github.com/bradhowes/4cd0b3da56b24166243e88d77329e909
            //#if SWIFT_PACKAGE
            //            if let result = createWithBundle(SWIFTPM_MODULE_BUNDLE) {
            //                return result
            //            }
            //#endif
            return nil
        }
    }
}
