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
    public final class VoidView: UIView, DTB.LayoutEventLazyFireable {
        
        public var lazyLayoutEventsPool_: [DTB.LayoutEventLazyFireTiming: [(DTB.VoidView) -> ()]] = [:]
        
        public override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            lazyLayoutsWhenDidMoveToSuperview_()
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            lazyLayoutsWhenLayoutSubviews_()
        }
        
        public override class var layerClass: AnyClass {
            return VoidLayer.self
        }
        
        public override func draw(_ rect: CGRect) { }
        
        public override func setNeedsDisplay() { }
        
        public override func setNeedsDisplay(_ rect: CGRect) { }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
        
        private func setup() {
            clearsContextBeforeDrawing = false
            backgroundColor = nil
            isOpaque = false
        }
        
    }
    
}
