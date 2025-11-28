//
//  TarotBaseViewController.swift
//  Example
//
//  Created by moonShadow on 2025/10/13
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

class BaseViewController: UIViewController, FastNavigation {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // 隐藏 tabbar
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // 避免 push/pop 动画显示问题
        view.backgroundColor = .dtb.create("background")
    }
    
    // MARK: - FastNavigations  导航栏
    
    lazy var navigationView = NavigationView()
    
    open var navigationTheme: NavigationView.Themes = .pure {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
//        if #available(iOS 13.0, *) {
//            return .darkContent
//        }
//        return .default
    }
    
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()

}
