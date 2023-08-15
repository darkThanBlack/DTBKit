//
//  Floating.swift
//  DTBKit
//
//  Created by moonShadow on 2023/7/14
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
public class Drift {
    
    public static let shared = Drift()
    private init() {}
    
    weak var appWindow: UIWindow?
    
    var window: DriftWindow?
    
    weak var mainController: DriftMainViewController?
    
    func prepare() {
        guard window == nil else {
            return
        }
        let guide = DriftWindow(frame: UIScreen.main.bounds)
        guide.isHidden = true
        guide.backgroundColor = .clear
        guide.windowLevel = .normal
        
        let root = DriftMainViewController()
        
        let nav = UINavigationController(rootViewController: root)
        guide.rootViewController = nav
        
        mainController = root
        window = guide
        
        // must be call last otherwise nav will be release
        guide.addNoResponseView(root.view)
    }
    
    public func setup(_ window: UIWindow?) {
        self.appWindow = window
        prepare()
    }
    
    public func start() {
        prepare()
        window?.isHidden = false
        
        Drift.shared.mainController?.drift.fireFade(false)
    }
    
    public func stop() {
        window?.isHidden = true
        navigator.clear()
    }
    
    func appTopMost() -> UIViewController? {
        return topMost(appWindow?.rootViewController)
    }
    
    func topMost() -> UIViewController? {
        return topMost(window?.rootViewController)
    }
    
    /// Current controller in stack
    private func topMost(_ controller: UIViewController?) -> UIViewController? {
        ///
        func recursion(_ vc: UIViewController?) -> UIViewController? {
            if let nav = vc as? UINavigationController {
                return recursion(nav.visibleViewController)
            }
            if let tab = vc as? UITabBarController {
                return recursion(tab.selectedViewController)
            }
            if let presented = vc?.presentedViewController {
                return recursion(presented)
            }
            return vc
        }
        return recursion(controller)
    }
    
    public let navigator = GuideNavigator()
}

//MARK: - UserDefaults

extension Drift {
    
    enum DefaultsKey: String {
        ///
        case driftedFrame = "kDriftedFrameKey"
    }
    
    static func defaults(set value: Any?, forKey key: DefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func defaults<T>(getForKey key: DefaultsKey) -> T? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
}
