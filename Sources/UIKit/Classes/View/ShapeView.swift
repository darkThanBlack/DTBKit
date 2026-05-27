//
//  ShapeView.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/25
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// view with simple CAShapeLayer
    @objc(DTBShapeView)
    public final class ShapeView: BaseView {
        
        private var style = DTB.ShapeStyle()
        
        public func updateUI(_ value: DTB.ShapeStyle?) {
            guard let ui = value else {
                shape.isHidden = true
                return
            }
            guard self.style != ui else {
                return
            }
            self.style = ui
            
            shape.isHidden = false
            
            shape.fillColor =       ui.fillColor?.cgColor
            shape.fillRule =        ui.fillRule
            shape.strokeColor =     ui.strokeColor?.cgColor
            shape.strokeStart =     ui.strokeStart
            shape.strokeEnd =       ui.strokeEnd
            shape.lineWidth =       ui.lineWidth
            shape.miterLimit =      ui.miterLimit
            shape.lineCap =         ui.lineCap
            shape.lineJoin =        ui.lineJoin
            shape.lineDashPhase =   ui.lineDashPhase
            shape.lineDashPattern = ui.lineDashPattern
            
            lazyFire(.onLayoutSubviews) { v in
                guard let me = v as? Self else { return }
                guard let corners = ui.corners else { return }
                let cornerRadii = {
                    if let radius = ui.radius {
                        return CGSize(width: radius, height: radius)
                    }
                    if let p = ui.radiusHeightPrecent {
                        return CGSize(width: me.bounds.height * p, height: me.bounds.height * p)
                    }
                    return CGSize.zero
                }()
                
                me.shape.path = UIBezierPath(
                    roundedRect: me.bounds,
                    byRoundingCorners: corners,
                    cornerRadii: cornerRadii
                ).cgPath
            }
        }
        
        ///
        private lazy var shape: CAShapeLayer = {
            let shape = CAShapeLayer()
            shape.isHidden = true
            return shape
        }()
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            
            layer.addSublayer(shape)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
