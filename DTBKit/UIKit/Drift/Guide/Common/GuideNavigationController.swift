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

/// 动画容器
///
/// 使用 push / pop 代理方法会和 Thrio 冲突, 暂用 present / dismiss 替代来避免
class GuideNavigationController: UINavigationController {
    
    private let animation = GuideAnimation()
    
    var animatePair: (show: GuideAnimation.Types, hide: GuideAnimation.Types)?
    
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
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
}

extension GuideNavigationController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animation.to(animatePair?.show ?? .none)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animation.to(animatePair?.hide ?? .none)
    }
}
