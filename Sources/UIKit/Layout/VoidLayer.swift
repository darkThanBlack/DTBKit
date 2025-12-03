//
//  VoidLayer.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/2
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// Empty layer without render.
    @objc(DTBVoidLayer)
    public final class VoidLayer: CALayer {
        
        override init() {
            super.init()
            setup()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
        
        override init(layer: Any) {
            super.init(layer: layer)
            setup()
        }
        
        private func setup() {
            needsDisplayOnBoundsChange = false
            shouldRasterize = false
        }
        
        ///
        public override func draw(in ctx: CGContext) { }
        
        ///
        public override func display() { }
    }
    
}
