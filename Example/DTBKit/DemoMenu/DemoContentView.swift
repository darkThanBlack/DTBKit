//
//  DemoContentView.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/30
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
class DemoContentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(gradient)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradient.frame = bounds
    }
    
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.white.cgColor,
            UIColor.black.cgColor
        ]
        gradient.startPoint = CGPointMake(0.0, 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradient
    }()
}
