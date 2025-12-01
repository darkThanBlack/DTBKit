//
//  VoidView.swift
//  DoKit
//
//  Created by moonShadow on 2025/12/1
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

class VoidView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        isUserInteractionEnabled = false
        isOpaque = false
        layer.shouldRasterize = false
    }
    
    override func draw(_ rect: CGRect) { }
    
    override var backgroundColor: UIColor? {
        get { .clear }
        set { }
    }
    
    override func setNeedsDisplay() { }
    override func setNeedsDisplay(_ rect: CGRect) { }
}
