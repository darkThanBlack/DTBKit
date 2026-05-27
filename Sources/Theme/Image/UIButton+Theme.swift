//
//  UIButton+Theme.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/27
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension Wrapper where Base: UIButton {
    
    @discardableResult
    public func setImage(_ param: Any?) -> Self {
        if let p = DTB.Providers.get(DTB.Providers.uiButtonSetImageKey) {
            p.setup(button: me, param: param, completedHandler: nil)
        }
        return self
    }
}
