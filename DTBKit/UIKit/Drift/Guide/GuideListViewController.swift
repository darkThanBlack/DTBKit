//
//  GuideListViewController.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/22
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

///
class GuideListViewController: UIViewController {
    
    lazy var contentView: GuideListView = {
        let contentView = GuideListView()
        contentView.backgroundColor = .white
        return contentView
    }()
    
    //MARK: Life Cycle
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        loadViews(in: view)
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(contentView)
        [contentView].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: box.leftAnchor, constant: 0.0),
            contentView.rightAnchor.constraint(equalTo: box.rightAnchor, constant: 0.0),
            contentView.bottomAnchor.constraint(equalTo: box.bottomAnchor, constant: 0.0),
            
            contentView.heightAnchor.constraint(equalTo: box.heightAnchor, multiplier: 0.9)
        ])
    }
}

extension GuideListViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GuideAnimation(type: .dismiss)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GuideAnimation(type: .present)
    }
}

///
class GuideAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum Types {
        
        case present, dismiss
    }
    
    private let type: Types
    
    init(type: Types) {
        self.type = type
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case .present:
            presentAnimateTransition(using: transitionContext)
        case .dismiss:
            dismissAnimateTransition(using: transitionContext)
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
        guard let alertVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        let container = transitionContext.containerView
        
        // Step 1.
        Drift.shared.rootViewController?.drift.fireFade(true)
        
        // Step 2.1  bg alpha...
        container.addSubview(coverView)
        coverView.alpha = 0.0
        coverView.frame = CGRect(origin: .zero, size: self.scSize)
        
        // Step 2.2  sacle land from drift to bottom...
        container.addSubview(bottomLand)
        bottomLand.alpha = 0.0
        bottomLand.backgroundColor = DriftAdapter.color_FF8534()
        bottomLand.frame = container.convert(Drift.shared.rootViewController?.drift.frame ?? .zero, to: nil)
        
        UIView.animate(withDuration: duration(0.2), delay: 0.2, options: .curveEaseIn) {
            self.coverView.alpha = 0.2
            
            self.bottomLand.alpha = 1.0
            self.bottomLand.backgroundColor = .white
            self.bottomLand.frame = CGRect(x: 0, y: self.scSize.height - (self.landRadius * 2), width: self.scSize.width, height: self.landHeight)
        } completion: { _ in
            // Step 2.3  land to alert...
            UIView.animate(withDuration: self.duration(0.2), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
                self.bottomLand.frame = CGRect(x: 0, y: self.scSize.height - self.landHeight + self.landRadius, width: self.scSize.width, height: self.landHeight)
            } completion: { _ in
                // Step 3  reverse compression...
                UIView.animate(withDuration: self.duration(0.4), delay: 0.1, options: .curveEaseOut) {
                    self.coverView.alpha = 0.35
                    
                    self.bottomLand.frame = CGRect(x: 0, y: self.scSize.height - self.landHeight + (self.landRadius * 2.0), width: self.scSize.width, height: self.landHeight)
                } completion: { _ in
                    // Step 4  commen present...
                    container.addSubview(alertVC.view)
                    alertVC.view.frame = CGRect(x: 0, y: self.bottomLand.frame.origin.y, width: self.scSize.width, height: self.scSize.height)
                    UIView.animate(withDuration: self.duration(0.2), delay: 0.0, options: .curveEaseInOut) {
                        alertVC.view.frame = CGRect(origin: .zero, size: self.scSize)
                    } completion: { _ in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    }
                }
            }
        }
    }
    
    private func dismissAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let alertVC = transitionContext.viewController(forKey: .from) else {
            return
        }
        let container = transitionContext.containerView
        let cover = container.viewWithTag(coverTag)
        UIView.animate(withDuration: 0.3, animations: {
            cover?.alpha = 0
            alertVC.view.frame = CGRect(x: 0, y: self.scSize.height, width: self.scSize.width, height: self.scSize.height)
        }) { _ in
            alertVC.view.removeFromSuperview()
            cover?.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private let coverTag = 20230724
    
    private lazy var coverView: UIView = {
        let cover = UIView()
        cover.backgroundColor = .black
        cover.frame = CGRect(origin: .zero, size: self.scSize)
        cover.alpha = 0
        cover.tag = coverTag
        return cover
    }()
    
    ///
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
