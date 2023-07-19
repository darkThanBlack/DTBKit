//
//  GuideDriftView.swift
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
class GuideDriftView: UIView {
    
    //MARK: Interface
    
    //MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        
        
        
    }
    
    //MARK: -
    
    ///
    private var op: CGPoint = .zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else {
            return
        }
        op = p
    }
    
    
    
    /// 越界
    func frameInside(value: CGRect, barrier: CGRect) -> CGRect {
        var newFrame = value
        
        if newFrame.origin.x < 0 {
            newFrame.origin.x = 0
        }
        
        if newFrame.origin.x > (barrier.size.width - newFrame.size.width) {
            newFrame.origin.x = barrier.size.width - newFrame.size.width
        }
        
        if newFrame.origin.y < 0 {
            newFrame.origin.y = 0
        }
        
        if newFrame.origin.y > (barrier.size.height - newFrame.size.height) {
            newFrame.origin.y = barrier.size.height - newFrame.size.height
        }
        
        return newFrame
    }
    
    /// 仿系统贴边
    func frameAbsorbSystem(value: CGRect, barrier: CGRect) -> CGRect {
        var newFrame = frameInside(value: value, barrier: barrier)
        
        let midWidth = newFrame.size.width / 2.0
        let midHeight = newFrame.size.height / 2.0
        
        var needChange = true
        if newFrame.origin.y < midHeight {
            newFrame.origin.y = 0
            needChange = false
        }
        
        if newFrame.origin.y > ((barrier.size.height - newFrame.size.height) - midHeight) {
            newFrame.origin.y = barrier.size.height - newFrame.size.height
            needChange = false
        }
        
        if needChange {
            if (newFrame.origin.x + midWidth) < barrier.size.width / 2 {
                newFrame.origin.x = 0
            } else {
                newFrame.origin.x = barrier.size.width - newFrame.size.width
            }
        }
        
        return newFrame
    }
}

