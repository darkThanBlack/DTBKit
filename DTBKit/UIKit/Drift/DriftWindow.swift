//
//  DriftWindow.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/19
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
class DriftWindow: UIWindow {
    
    private class Weaker<T: AnyObject> {
        weak var me: T?
        
        init(_ me: T? = nil) {
            self.me = me
        }
    }
    
    private var noResponses: [Weaker<UIView>] = []
    
    func addNoResponseView(_ value: UIView) {
        noResponses.removeAll(where: { $0.me == nil })
        noResponses.append(Weaker(value))
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if noResponses.filter({ $0.me != nil }).contains(where: { $0.me == view }) {
            return nil
        }
        return view
    }
}
