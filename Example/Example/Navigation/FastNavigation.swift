//
//  FastNavigations.swift
//  XMKit
//
//  Created by moonShadow on 2024/1/3
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// 导航栏页面默认实现
public protocol FastNavigationViewType: UIView {
    
    /// 主题
    associatedtype Themes
    
    /// 左侧单个按钮类型
    associatedtype LeftStyles
    
    /// 右侧单个按钮类型
    associatedtype RightStyles
    
    func fastUpdate(title: String?, theme: Themes, leftStyle: LeftStyles, rightStyle: RightStyles?)
    
    /// 左侧单个按钮事件 注意赋值时机
    var leftHandler: (() -> Void)? { get set }
    
    /// 右侧单个按钮事件 注意赋值时机
    var rightHandler: (() -> Void)? { get set }
}

/// 自定义导航栏协议
public protocol FastNavigation: UIViewController {
    
    associatedtype NavigationType: UIView, FastNavigationViewType = NavigationView
    
    var navigationView: NavigationType { get }
    
    /// 方便联动
    var navigationTheme: NavigationType.Themes { get set }
    
    func loadNavigation(title: String?, theme: NavigationType.Themes?, leftStyle: NavigationType.LeftStyles, rightStyle: NavigationType.RightStyles?)
}

extension FastNavigation where Self: UIViewController, Self.NavigationType: NavigationView {
    
    public func loadNavigation(title: String? = nil, theme: NavigationType.Themes? = .clear, leftStyle: NavigationView.LeftStyles = .dismiss, rightStyle: NavigationView.RightStyles? = nil) {
        if let t = theme {
            self.navigationTheme = t
        }
        navigationView.fastUpdate(title: title, theme: self.navigationTheme, leftStyle: leftStyle, rightStyle: rightStyle)
        
        view.addSubview(navigationView)
        
        [navigationView].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            navigationView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0),
            navigationView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0),
        ])
        
        navigationView.leftHandler = {
            UIViewController.dtb.popAnyway()
        }
    }
}
