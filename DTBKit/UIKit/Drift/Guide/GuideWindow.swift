//
//  GuideWindow.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/19
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

class GuideWindow: UIWindow {
    
    ///
    weak var noResponseView: UIView?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view?.isEqual(noResponseView) == true {
            return nil
        }
        return view
    }
}
