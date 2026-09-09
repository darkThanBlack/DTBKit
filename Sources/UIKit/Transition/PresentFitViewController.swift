//
//  DTBFitPresentViewController.swift
//  SmartSales
//
//  Created by moonShadow on 2026/8/28
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {
    
    /// - 核心特性：
    ///   - 仿系统，底部向上的 present 效果
    ///   - 整体高度由子类相对于 contentView 的 self-sizing 约束决定
    ///   - 灰色背景由转场层提供
    ///   - 点击关闭由本身提供(盖一个透明 view)
    @objc(DTBPresentFitViewController)
    open class PresentFitViewController: UIViewController {
        
        /// 业务容器
        public lazy var contentView = {
            let v = UIView()
            v.backgroundColor = .clear
            return v
        }()
        
        /// 透明遮罩
        public lazy var maskTapView: UIView = {
            let v = UIView()
            v.backgroundColor = .clear
            let tap = UITapGestureRecognizer(target: self, action: #selector(maskTapped))
            v.addGestureRecognizer(tap)
            return v
        }()
        
        /// 遮罩点击事件
        ///
        /// 默认关闭页面; 子类可以通过赋 nil 或者重写来拦截
        public lazy var maskTapEventHandler: (() -> ())? = { [weak self] in
            self?.dtb.popAnyway()
        }
        
        ///
        private let transitionHandler = PresentTransitioningHandler()
        
        public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nil, bundle: nil)
            modalPresentationStyle = .custom
            transitioningDelegate = transitionHandler
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        open override func viewDidLoad() {
            super.viewDidLoad()
            
            loadSubviews(in: view)
        }
        
        private func loadSubviews(in box: UIView) {
            box.backgroundColor = .clear
            
            maskTapView.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
            maskTapView.setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
            contentView.setContentHuggingPriority(.defaultHigh, for: .vertical)
            contentView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
            
            box.addSubview(maskTapView)
            box.addSubview(contentView)
            
            maskTapView.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(contentView.snp.top)
            }
            contentView.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
            }
        }
        
        @objc private func maskTapped() {
            maskTapEventHandler?()
        }
        
    }
    
}
