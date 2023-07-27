//
//  GuideAnimation.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/26
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
public class GuideAnimationHandler: NSObject {}

extension GuideAnimationHandler: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return GuideAnimation(type: .push)
        case .pop:
            return GuideAnimation(type: .pop)
        case .none:
            return nil
        @unknown default:
            return nil
        }
    }
}

extension GuideAnimationHandler: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GuideAnimation(type: .present)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GuideAnimation(type: .dismiss)
    }
}

///
public class GuideAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    public enum Types {
        // main drift <-> any
        case present, dismiss
        // list <-> docs
        case push, pop
    }
    
    private let type: Types
    
    public init(type: Types) {
        self.type = type
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 10.0
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case .present:
            presentAnimateTransition(using: transitionContext)
        case .dismiss:
            dismissAnimateTransition(using: transitionContext)
        case .push:
            pushAnimateTransition(using: transitionContext)
        case .pop:
            popAnimateTransition(using: transitionContext)
        }
    }
    
    /// No safeArea
    private lazy var scSize = UIScreen.main.bounds.size
    ///
    private let landRadius: CGFloat = 10.0
    /// refer: System.App.Maps
    private let landHeight: CGFloat = 120.0
    
    /// Debug helper
    private func duration(_ value: TimeInterval) -> TimeInterval {
        return value
    }
    
    /// Present
    private func presentAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            assert(false)
            return
        }
        let container = transitionContext.containerView
        
        // Step 1.  浮窗隐藏动画
        Drift.shared.mainController?.drift.fireFade(true)
        
        container.addSubview(coverView)
        coverView.alpha = 0.0
        coverView.frame = CGRect(origin: .zero, size: self.scSize)
        
        container.addSubview(bottomLand)
        bottomLand.alpha = 0.0
        bottomLand.backgroundColor = DriftAdapter.color_FF8534()
        bottomLand.frame = container.convert(Drift.shared.mainController?.drift.frame ?? .zero, to: nil)
        
        // Step 2.1  背景略微变深
        // Step 2.2  浮岛从浮窗当前位置缩放到屏幕最底部
        UIView.animate(withDuration: duration(0.2), delay: 0.2, options: .curveEaseIn) {
            self.coverView.alpha = 0.2
            
            self.bottomLand.alpha = 1.0
            self.bottomLand.backgroundColor = .white
            self.bottomLand.frame = CGRect(x: 0, y: self.scSize.height - (self.landRadius * 2), width: self.scSize.width, height: self.landHeight)
        } completion: { _ in
            // Step 3.  浮岛从底部弹出，弹簧
            UIView.animate(withDuration: self.duration(0.2), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
                self.bottomLand.frame = CGRect(x: 0, y: self.scSize.height - self.landHeight + self.landRadius, width: self.scSize.width, height: self.landHeight)
            } completion: { _ in
                // Step 4.1  略停顿后再下降一点距离，模拟弹簧压缩效果
                // Setp 4.2  背景继续变深
                UIView.animate(withDuration: self.duration(0.4), delay: self.duration(0.1), options: .curveEaseOut) {
                    self.coverView.alpha = 0.35
                    
                    self.bottomLand.frame = CGRect(x: 0, y: self.scSize.height - self.landHeight + (self.landRadius * 2.0), width: self.scSize.width, height: self.landHeight)
                } completion: { _ in
                    container.addSubview(toView)
                    toView.frame = CGRect(x: 0, y: self.bottomLand.frame.origin.y, width: self.scSize.width, height: self.scSize.height)
                    // Step 5.  从浮岛顶部开始普通 present 效果
                    UIView.animate(withDuration: self.duration(0.2), delay: 0.0, options: .curveEaseInOut) {
                        toView.frame = CGRect(origin: .zero, size: self.scSize)
                    } completion: { _ in
                        // Finish.  移除浮岛，保留背景
                        self.bottomLand.removeFromSuperview()
                        transitionContext.completeTransition(true)
                    }
                }
            }
        }
    }
    
    /// Dismiss
    private func dismissAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            assert(false)
            return
        }
         let container = transitionContext.containerView
        
        // 普通 dismiss 效果
        UIView.animate(withDuration: 0.25, animations: {
            self.coverView.alpha = 0
            fromView.frame = CGRect(x: 0, y: self.scSize.height, width: self.scSize.width, height: self.scSize.height)
        }) { _ in
            // 浮窗显示动画
            Drift.shared.mainController?.drift.fireFade(false)
            
            fromView.removeFromSuperview()
            self.coverView.removeFromSuperview()
            
            transitionContext.completeTransition(true)
        }
    }
    
    /// Push
    /// [HACK] main router need delay: 0.25 + 0.2
    private func pushAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            assert(false)
            return
        }
        let container = transitionContext.containerView
        
        // Step 1.  浮窗隐藏动画
        Drift.shared.mainController?.drift.fireFade(true)
        
        // Step 2.1  普通 dismiss 到最底部
        // Step 2.2  背景透明
        UIView.animate(withDuration: self.duration(0.25), delay: 0.0, options: .curveEaseIn) {
            self.coverView.alpha = 0.0
            fromView.frame = CGRect(x: 0, y: self.scSize.height, width: self.scSize.width, height: self.scSize.height)
        } completion: { _ in
            container.addSubview(self.bottomLand)
            self.bottomLand.alpha = 1.0
            self.bottomLand.backgroundColor = .white
            self.bottomLand.frame = CGRect(x: 0, y: self.scSize.height, width: self.scSize.width, height: self.landHeight)
            
            // Step 3.  浮岛从底部弹出，弹簧
            UIView.animate(withDuration: self.duration(0.2), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
                self.bottomLand.frame = CGRect(x: 0, y: self.scSize.height - self.landHeight + self.landRadius, width: self.scSize.width, height: self.landHeight)
            } completion: { _ in
                // Step 4.1  [HACK] 应用路由栈页面执行跳转，等待其动画完成
                // Step 4.2  略停顿后再下降一点距离，模拟弹簧压缩效果
                // Setp 4.3  背景略微变深
                UIView.animate(withDuration: self.duration(0.4), delay: 0.3, options: .curveEaseOut) {
                    self.coverView.alpha = 0.2
                    
                    self.bottomLand.frame = CGRect(x: 0, y: self.scSize.height - self.landHeight + (self.landRadius * 2.0), width: self.scSize.width, height: self.landHeight)
                } completion: { _ in
                    container.addSubview(toView)
                    toView.frame = CGRect(x: 0, y: self.bottomLand.frame.origin.y, width: self.scSize.width, height: self.scSize.height)
                    // Step 5.  从浮岛顶部开始普通 present 效果
                    UIView.animate(withDuration: self.duration(0.2), delay: 0.0, options: .curveEaseInOut) {
                        toView.frame = CGRect(origin: .zero, size: self.scSize)
                    } completion: { _ in
                        // Finish.  移除浮岛，保留背景
                        self.bottomLand.removeFromSuperview()
                        // !transitionContext.transitionWasCancelled
                        transitionContext.completeTransition(true)
                    }
                }
            }
        }
    }
    
    private func popAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            assert(false)
            return
        }
        let container = transitionContext.containerView
        
        // container.subviews.forEach({ $0.removeFromSuperview() })
        
        container.addSubview(toView)
        
        Drift.shared.mainController?.drift.fireAbsorb()
        Drift.shared.mainController?.drift.fireFade(false)
        
        transitionContext.completeTransition(true)
    }
    
    private let coverTag = 20230724
    
    /// 灰色背景
    private lazy var coverView: UIView = {
        let cover = UIView()
        cover.backgroundColor = .black
        cover.frame = CGRect(origin: .zero, size: self.scSize)
        cover.alpha = 0
        cover.tag = coverTag
        return cover
    }()
    
    /// 底部浮岛
    private lazy var bottomLand: UIImageView = {
        let land = UIImageView()
        land.backgroundColor = .white
        land.layer.masksToBounds = true
        land.layer.cornerRadius = 10.0
        
        land.contentMode = .scaleAspectFill
        land.dtb.setImage(named: "guide_header_bg", bundleName: "DTBKit-UIKit", frameworkName: "DTBKit")
        
        return land
    }()
}
