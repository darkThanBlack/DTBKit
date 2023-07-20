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
