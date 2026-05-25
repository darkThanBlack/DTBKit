//
//  BaseViewController.swift
//  XMSport
//
//  Created by moonShadow on 2024/1/3
//  Copyright © 2024 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// 考虑到 UIKit 相关限制，不得不设计普通页面基类
    @objc(DTBBaseViewController)
    open class BaseViewController: UIViewController, SimpleNavigationBarHandler {
        
        public lazy var customNavigationBar = DTB.SimpleNavigationBar()
        
        open override var preferredStatusBarStyle: UIStatusBarStyle {
            if #available(iOS 13.0, *) {
                return .darkContent
            }
            return .default
        }
        
        public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            
            // 只放在 Nav.push 会导致页面恢复时无法生效
            hidesBottomBarWhenPushed = true
            
            // iOS 13.x present 效果适配
            modalPresentationStyle = .fullScreen
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        open override func viewDidLoad() {
            super.viewDidLoad()
            
            // 避免 push/pop 动画显示问题
            view.backgroundColor = .dtb.create("background01")
        }
    }
    
}
