//
//  BaseControl.swift
//  DTBKit
//
//  Created by moonShadow on 2025/11/22
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    ///
    @objc(DTBBaseControl)
    open class BaseControl: UIControl {
        
        ///
        open func match<T>(_ dict: [UInt: T]) -> T? {
            if let result = dict[state.rawValue] {
                return result
            }
            /// Note: state.contains(0) always true
            if let bestKey = dict
                .compactMap({ UIControl.State(rawValue: $0.key) })
                .filter({ $0 == .normal ? (state == .normal) : state.contains($0) })
                .max(by: { $0.rawValue.nonzeroBitCount < $1.rawValue.nonzeroBitCount }) {
                return dict[bestKey.rawValue]
            }
            return dict[UIControl.State.normal.rawValue]
        }
        
        private var eventPool: [(() -> ())] = []
        
        ///
        open lazy var shapeLayer: CAShapeLayer = {
            let shape = CAShapeLayer()
            return shape
        }()
        
        ///
        open lazy var gradientLayer: CAGradientLayer = {
            let gradient = CAGradientLayer()
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            return gradient
        }()
        
        /// radius == nil: height / 2.0
        public func setCorner(radius: CGFloat? = nil, corners: UIRectCorner = .allCorners) {
            eventPool.append { [weak self] in
                guard let self = self else { return }
                let path = UIBezierPath(
                    roundedRect: bounds,
                    byRoundingCorners: corners,
                    cornerRadii: CGSize(
                        width: radius ?? bounds.size.height / 2.0,
                        height: radius ?? bounds.size.height / 2.0
                    )
                )
                shapeLayer.path = path.cgPath
            }
            setNeedsLayout()
        }
        
        ///
        public func setGradient(handler: ((CAGradientLayer?) -> ())?) {
            eventPool.append { [weak self] in
                handler?(self?.gradientLayer)
            }
            setNeedsLayout()
        }
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            
            loadViews(in: self)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadViews(in box: UIView) {
            gradientLayer.mask = shapeLayer
            layer.addSublayer(gradientLayer)
        }
        
        open override func layoutSubviews() {
            super.layoutSubviews()
            
            guard bounds.isEmpty == false else { return }
            
            gradientLayer.frame = bounds
            
            while eventPool.count > 0 {
                eventPool.removeLast()()
            }
        }
        
    }
    
}
