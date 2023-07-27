//
//  GuideNavigationController.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/27
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// transition 用于实现浮窗 <-> 子页面之间的动画效果
/// navigate 用于实现任务列表 <-> 指南之间的动画效果
class GuideNavigationController: UINavigationController {
    
    private let animateHandler = GuideAnimationHandler()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        prepare()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        self.setNavigationBarHidden(true, animated: false)
        
        self.delegate = animateHandler
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = animateHandler
    }
}
