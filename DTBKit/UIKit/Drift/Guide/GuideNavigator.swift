//
//  GuideNavigatorContext.swift
//  XMBundleLN
//
//  Created by moonShadow on 2023/8/11
//  Copyright © 2023 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

public class GuideNavigator {
    
    private var cacheGuideUrl: String?
    
    func clear() {
        cacheGuideUrl = nil
    }
    
    /// 浮窗 -> Any
    public func open() {
        if let url = cacheGuideUrl, url.isEmpty == false {
            let docsVC = GuideDocsViewController()
            docsVC.load(url: url)
            
            let nav = GuideNavigationController(rootViewController: docsVC)
            nav.animatePair = (.present, .dismiss)
            Drift.shared.topMost()?.present(nav, animated: true)
        } else {
            let listVC = GuideListViewController()
            let nav = GuideNavigationController(rootViewController: listVC)
            nav.animatePair = (.present, .dismiss)
            Drift.shared.topMost()?.present(nav, animated: true)
        }
    }
    
    /// Any -> 浮窗
    public func close() {
        Drift.shared.topMost()?.dismiss(animated: true)
    }
    
    /// 列表 -> 详情
    public func push(with docsUrl: String) {
        Drift.shared.topMost()?.dismiss(animated: true, completion: {
            self.cacheGuideUrl = docsUrl
            
            let docsVC = GuideDocsViewController()
            docsVC.load(url: docsUrl)
            
            let nav = GuideNavigationController(rootViewController: docsVC)
            nav.animatePair = (.push, .dismiss)
            Drift.shared.topMost()?.present(nav, animated: true)
        })
    }
    
    /// 详情 -> 列表
    public func pop() {
        Drift.shared.topMost()?.dismiss(animated: true, completion: {
            self.cacheGuideUrl = nil
            
            let listVC = GuideListViewController()
            let nav = GuideNavigationController(rootViewController: listVC)
            nav.animatePair = (.push, .dismiss)
            Drift.shared.topMost()?.present(nav, animated: true)
        })
    }
}
