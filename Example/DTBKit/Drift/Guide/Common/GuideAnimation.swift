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

/// 新手引导 - 转场动画
class GuideAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// [HACK] 延时执行应用主路由跳转
    static let mainRouterDelay: TimeInterval = 0.45
    
    enum Types {
        ///
        case none
        // 主视图浮窗 -> {列表，详情}
        case show
        // 列表 -> 详情
        case router
        // 普通 present
        case present
        // 普通 dismiss
        case dismiss
    }
    ///
    private var type: Types = .none
    
    /// 保证过渡视图对象相同
    func to(_ type: Types) -> GuideAnimation {
        self.type = type
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 5.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case .show:
            showAnimateTransition(using: transitionContext)
        case .present:
            presentAnimateTransition(using: transitionContext)
        case .dismiss:
            dismissAnimateTransition(using: transitionContext)
        case .router:
            routerAnimateTransition(using: transitionContext)
        case .none:
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
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
    
    /// "show"
    private func showAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        let container = transitionContext.containerView
        
        // Step 1.  浮窗隐藏动画
        Drift.shared.mainController?.drift.fireFade(true)
        
        container.addSubview(grayView)
        grayView.alpha = 0.0
        grayView.frame = CGRect(origin: .zero, size: self.scSize)
        
        container.addSubview(bottomLand)
        bottomLand.alpha = 0.0
        bottomLand.backgroundColor = DriftAdapter.color_FF8534()
        bottomLand.frame = container.convert(Drift.shared.mainController?.drift.frame ?? .zero, to: nil)
        
        // Step 2.1  背景略微变深
        // Step 2.2  浮岛从浮窗当前位置缩放到屏幕最底部
        UIView.animate(withDuration: duration(0.2), delay: 0.2, options: .curveEaseIn) {
            self.grayView.alpha = 0.2
            
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
                    self.grayView.alpha = 0.35
                    
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
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    }
                }
            }
        }
    }
    
    /// "Present"
    private func presentAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        let container = transitionContext.containerView
        
        // Step 1.  浮窗隐藏动画
        Drift.shared.mainController?.drift.fireFade(true)
        
        container.addSubview(grayView)
        grayView.alpha = 0.0
        grayView.frame = CGRect(origin: .zero, size: self.scSize)
        
        self.grayView.alpha = 0
        container.addSubview(toView)
        toView.frame = CGRect(x: 0, y: self.scSize.height, width: self.scSize.width, height: self.scSize.height)
        // Step 2.  普通 present
        UIView.animate(withDuration: self.duration(0.25), animations: {
            self.grayView.alpha = 0.35
            toView.frame = CGRect(origin: .zero, size: self.scSize)
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    /// "Dismiss"
    private func dismissAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        
        // Step 1.  普通 dismiss
        UIView.animate(withDuration: self.duration(0.25), animations: {
            self.grayView.alpha = 0
            fromView.frame = CGRect(x: 0, y: self.scSize.height, width: self.scSize.width, height: self.scSize.height)
        }) { _ in
            // Finish.  浮窗显示动画
            Drift.shared.mainController?.drift.fireFade(false)
            
            fromView.removeFromSuperview()
            self.grayView.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    /// "Router"
    /// [HACK] main router need delay: (dismiss: 0.25) + (bottomLand: 0.2)
    private func routerAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        let container = transitionContext.containerView
        
        // Step 1.  浮窗隐藏动画
        Drift.shared.mainController?.drift.fireFade(true)
        
        container.addSubview(grayView)
        grayView.alpha = 0.0
        grayView.frame = CGRect(origin: .zero, size: self.scSize)
        
        container.addSubview(self.bottomLand)
        self.bottomLand.alpha = 1.0
        self.bottomLand.backgroundColor = .white
        self.bottomLand.frame = CGRect(x: 0, y: self.scSize.height, width: self.scSize.width, height: self.landHeight)
        
        // Step 2.1  浮岛从底部弹出，弹簧
        // Step 2.2  背景略深
        UIView.animate(withDuration: self.duration(0.2), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.grayView.alpha = 0.1
            self.bottomLand.frame = CGRect(x: 0, y: self.scSize.height - self.landHeight + self.landRadius, width: self.scSize.width, height: self.landHeight)
        } completion: { _ in
            // Step 3.1  [HACK] 应用路由栈页面执行跳转，等待其动画完成
            // Step 3.2  略停顿后再下降一点距离，模拟弹簧压缩效果
            // Setp 3.3  背景渐深
            UIView.animate(withDuration: self.duration(0.4), delay: 0.3, options: .curveEaseOut) {
                self.grayView.alpha = 0.2
                
                self.bottomLand.frame = CGRect(x: 0, y: self.scSize.height - self.landHeight + (self.landRadius * 2.0), width: self.scSize.width, height: self.landHeight)
            } completion: { _ in
                container.addSubview(toView)
                toView.frame = CGRect(x: 0, y: self.bottomLand.frame.origin.y, width: self.scSize.width, height: self.scSize.height)
                // Step 4.  从浮岛顶部开始普通 present 效果
                UIView.animate(withDuration: self.duration(0.2), delay: 0.0, options: .curveEaseInOut) {
                    self.grayView.alpha = 0.35
                    toView.frame = CGRect(origin: .zero, size: self.scSize)
                } completion: { _ in
                    // Finish.  移除浮岛，保留背景
                    // fromView.alpha = 1.0
                    self.bottomLand.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            }
        }
    }
    
    /// 灰色背景
    private lazy var grayView: UIView = {
        let cover = UIView()
        cover.backgroundColor = .black
        cover.frame = CGRect(origin: .zero, size: self.scSize)
        cover.alpha = 0
        return cover
    }()
    
    /// 底部浮岛
    private lazy var bottomLand: UIImageView = {
        let land = UIImageView()
        land.backgroundColor = .white
        land.layer.masksToBounds = true
        land.layer.cornerRadius = 10.0
        
        land.contentMode = .scaleAspectFill
        land.image = DriftAdapter.imageNamed("guide_header_bg")
        
        return land
    }()
}
