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

extension DTB {
    
    /// Empty view without render.
    @objc(DTBVoidView)
    public final class VoidView: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
        
        private func setup() {
            backgroundColor = nil
            clearsContextBeforeDrawing = false
            isUserInteractionEnabled = false
            isOpaque = false
        }
        
        public override class var layerClass: AnyClass {
            return VoidLayer.self
        }
        
        public override func draw(_ rect: CGRect) { }
        
        public override func setNeedsDisplay() { }
        
        public override func setNeedsDisplay(_ rect: CGRect) { }
    }
    
}
