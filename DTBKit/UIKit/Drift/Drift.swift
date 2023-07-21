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
    
    static let shared = Drift()
    private init() {}
    
    var window: UIWindow?
    
    public func prepare() {
        guard window == nil else {
            return
        }
        let guide = GuideWindow(frame: UIScreen.main.bounds)
        guide.isHidden = true
        guide.backgroundColor = .clear
        guide.windowLevel = .normal
        
        let root = GuideRootViewController()
        guide.noResponseView = root.view
        
        let nav = UINavigationController(rootViewController: root)
        guide.rootViewController = nav
        
        window = guide
    }
    
    public func start() {
        prepare()
        window?.isHidden = false
    }
    
    public func stop() {
        window?.isHidden = true
    }
}

extension Drift {
    
    public enum DefaultsKey: String {
        ///
        case driftLast = "kLastDragPointKey"
    }
    
    static func defaults(set value: Any?, forKey key: DefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func defaults<T>(getForKey key: DefaultsKey) -> T? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
}
