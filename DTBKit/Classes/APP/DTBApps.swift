//
//  SystemAdapter.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/30
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

extension DTB.App {
    
    /// Current scene in general app
    ///
    /// [refer](https://stackoverflow.com/questions/57134259)
    @available(iOS 13.0, *)
    public static func scene() -> UIWindowScene? {
        return UIApplication
            .shared
            .connectedScenes
            .compactMap({ ($0 as? UIWindowScene) })
            .first
    }
    
    /// Current window in general app
    ///
    /// [refer](https://stackoverflow.com/questions/57134259)
    public static func keyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return scene()?
                .windows
                .first(where: { $0.isKeyWindow })
            ?? UIApplication.shared.keyWindow
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    /// [DEPRESSED] Status bar height
    ///
    /// * I suggest using "safe area" instead of "const px" whenever possible.
    /// * Anyway, do *NOT* use it before ``window.makeKeyAndVisable``
    ///
    /// Sample code with "auto layout" + "safe area" may like:
    /// ```
    ///    let father = UIView()
    ///    let son = UIView()
    ///    [father, son].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    ///    if #available(iOS 11.0, *) {
    ///        son.topAnchor.constraint(equalTo: father.safeAreaLayoutGuide.topAnchor, constant: 0.0).isActive = true
    ///    } else {
    ///        son.topAnchor.constraint(equalTo: father.topAnchor, constant: 0.0).isActive = true
    ///    }
    /// ```
    ///
    /// Sample code with "frame" + "safe area" may like:
    /// ```
    ///    if #available(iOS 11.0, *) {
    ///        son.frame.origin.x = father.safeAreaInsets.top + 8.0
    ///    } else {
    ///        son.frame.origin.x = 8.0
    ///    }
    /// ```
    public static var statusBarHeight: CGFloat {
        get {
            ///
            func oldHeight() -> CGFloat {
                let height = UIApplication.shared.statusBarFrame.size.height
                if #available(iOS 11.0, *) {
                    return keyWindow()?.safeAreaInsets.top ?? height
                } else {
                    return height
                }
            }
            
            if #available(iOS 13.0, *) {
                return scene()?.statusBarManager?.statusBarFrame.size.height ?? oldHeight()
            } else {
                return oldHeight()
            }
        }
        set {}
    }
}
