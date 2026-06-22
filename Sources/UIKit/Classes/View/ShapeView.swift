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
            guard let sp = value else {
                shape.isHidden = true
                return
            }
            shape.isHidden = false
            
            guard self.style != sp else {
                return
            }
            self.style = sp
            
            shape.fillColor =       sp.fillColor?.cgColor
            shape.fillRule =        sp.fillRule ?? .nonZero
            shape.strokeColor =     sp.strokeColor?.cgColor
            shape.strokeStart =     sp.strokeStart ?? 0.0
            shape.strokeEnd =       sp.strokeEnd ?? 1.0
            shape.lineWidth =       sp.lineWidth ?? 0.0
            shape.miterLimit =      sp.miterLimit ?? 10.0
            shape.lineCap =         sp.lineCap ?? .round
            shape.lineJoin =        sp.lineJoin ?? .round
            shape.lineDashPhase =   sp.lineDashPhase ?? 0.0
            shape.lineDashPattern = sp.lineDashPattern
            
            setNeedsLayout()
        }
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            
            layer.addSublayer(shape)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            guard bounds.isEmpty == false else { return }
            
            shape.path = {
                // 完全自定义路径
                if let path = style.path {
                    return path
                }
                // 圆角
                if let corners = style.corners,
                   let radii = style.radius?.radii(for: bounds) {
                    return UIBezierPath(
                        roundedRect: bounds,
                        byRoundingCorners: corners,
                        cornerRadii: radii
                    ).cgPath
                }
                return nil
            }()
        }
        
        private lazy var shape: CAShapeLayer = {
            let shape = CAShapeLayer()
            shape.isHidden = true
            return shape
        }()
        
    }
    
}
