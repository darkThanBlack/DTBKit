//
//  GradientView.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/9
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

import UIKit

extension DTB {
    
    /// view with CAGradientLayer + CAShapeLayer mask
    @objc(DTBGradientView)
    public final class GradientView: BaseView {
        
        private var style = DTB.GradientStyle()
        
        public func updateUI(_ value: DTB.GradientStyle?) {
            guard let ui = value else {
                gradient.isHidden = true
                return
            }
            gradient.isHidden = false
            
            guard self.style != ui else {
                return
            }
            self.style = ui
            
            gradient.colors =     ui.colors
            gradient.startPoint = ui.startPoint ?? .zero
            gradient.endPoint =   ui.endPoint ?? CGPoint(x: 1.0, y: 1.0)
            gradient.locations =  ui.locations
            gradient.type =       ui.type ?? .axial
            
            if let sp = ui.shapeMask {
                shape.isHidden = false
                if gradient.mask == nil {
                    gradient.mask = shape
                }
                
                // 用做 mask 时，系统仅使用 fillColor 的 alpha 通道, 所以默认给一个 alpha = 1.0 的 color
                shape.fillColor =       sp.fillColor?.cgColor ?? UIColor.black.cgColor
                shape.fillRule =        sp.fillRule ?? .nonZero
                shape.strokeColor =     sp.strokeColor?.cgColor ?? UIColor.black.cgColor
                shape.strokeStart =     sp.strokeStart ?? 0.0
                shape.strokeEnd =       sp.strokeEnd ?? 1.0
                shape.lineWidth =       sp.lineWidth ?? 0.0
                shape.miterLimit =      sp.miterLimit ?? 10.0
                shape.lineCap =         sp.lineCap ?? .round
                shape.lineJoin =        sp.lineJoin ?? .round
                shape.lineDashPhase =   sp.lineDashPhase ?? 0.0
                shape.lineDashPattern = sp.lineDashPattern
            } else {
                shape.isHidden = true
                gradient.mask = nil
            }
            
            setNeedsLayout()
        }
        
        ///
        private lazy var shape: CAShapeLayer = {
            let shape = CAShapeLayer()
            shape.isHidden = true
            return shape
        }()
        
        ///
        private lazy var gradient: CAGradientLayer = {
            let gradient = CAGradientLayer()
            gradient.isHidden = true
            return gradient
        }()
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            
            // gradient.mask = shape
            
            layer.addSublayer(gradient)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            guard bounds.isEmpty == false else { return }
            
            gradient.frame = bounds
            
            guard let sp = style.shapeMask else { return }
            shape.path = {
                // 完全自定义路径
                if let path = sp.path {
                    return path
                }
                // 圆角
                if let corners = sp.corners,
                   let radii = sp.radius?.radii(for: bounds) {
                    return UIBezierPath(
                        roundedRect: bounds,
                        byRoundingCorners: corners,
                        cornerRadii: radii
                    ).cgPath
                }
                return nil
            }()
        }
    }
    
}
