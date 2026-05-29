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
            shape.fillRule =        ui.fillRule ?? .nonZero
            shape.strokeColor =     ui.strokeColor?.cgColor
            shape.strokeStart =     ui.strokeStart ?? 0.0
            shape.strokeEnd =       ui.strokeEnd ?? 1.0
            shape.lineWidth =       ui.lineWidth ?? 0.0
            shape.miterLimit =      ui.miterLimit ?? 10.0
            shape.lineCap =         ui.lineCap ?? .round
            shape.lineJoin =        ui.lineJoin ?? .round
            shape.lineDashPhase =   ui.lineDashPhase ?? 0.0
            shape.lineDashPattern = ui.lineDashPattern
            
            lazyFire(.onLayoutSubviews) { v in
                guard let me = v as? Self else { return }
                
                // 自定义路径
                if let path = ui.path {
                    me.shape.path = path
                    return
                }
                
                // 构建圆角
                guard let roundCorners = ui.roundCorners else { return }
                let roundRadii = {
                    if let radii = ui.roundRadii {
                        return radii
                    }
                    if let radius = ui.roundRadius {
                        return CGSize(width: radius, height: radius)
                    }
                    if let p = ui.roundRadiusHeightPrecent {
                        return CGSize(width: me.bounds.height * p, height: me.bounds.height * p)
                    }
                    return CGSize.zero
                }()
                
                me.shape.path = UIBezierPath(
                    roundedRect: me.bounds,
                    byRoundingCorners: roundCorners,
                    cornerRadii: roundRadii
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
