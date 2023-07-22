//
//  MissionListViewController.swift
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
class MissionListViewController: UIViewController {
    
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    //MARK: Life Cycle
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .custom
        // self.transitioningDelegate = self
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func loadView() {
        view = UIView(frame: .zero)
        view.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews(in: view)
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        
        
        loadConstraints(in: box)
    }
    
    private func loadConstraints(in box: UIView) {
        
    }
    
    
    
}

extension MissionListViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GuidePresentAnimation(type: .dismiss)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GuidePresentAnimation(type: .present)
    }
}

///
class GuidePresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
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
    
    private let scSize = UIScreen.main.bounds.size
    
    private func presentAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let alertVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        let container = transitionContext.containerView
        alertVC.view.frame = CGRect(x: 0, y: scSize.height, width: scSize.width, height: scSize.height)
        container.addSubview(coverView)
        container.addSubview(alertVC.view)
        UIView.animate(withDuration: 0.3, animations: {
            alertVC.view.frame = CGRect(origin: .zero, size: self.scSize)
            self.coverView.alpha = 0.35
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
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
    
    private let coverTag = 20200729
    
    private lazy var coverView: UIView = {
        let cover = UIView()
        cover.backgroundColor = .black
        cover.frame = CGRect(origin: .zero, size: self.scSize)
        cover.alpha = 0
        cover.tag = coverTag
        return cover
    }()
}
