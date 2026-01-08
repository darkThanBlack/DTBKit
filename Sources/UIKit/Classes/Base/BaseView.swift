//
//  BaseView.swift
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
    @objc(DTBBaseView)
    open class BaseView: UIView {
        
//        var lazyLayoutEventsPool_: [DTB.LayoutEventLazyFireTiming : [(Self) -> ()]] = [:]
//        
//        open override func didMoveToSuperview() {
//            super.didMoveToSuperview()
//            
//            lazyLayoutsWhenDidMoveToSuperview_()
//        }
//        
//        open override func layoutSubviews() {
//            super.layoutSubviews()
//            
//            lazyLayoutsWhenLayoutSubviews_()
//        }
        
    }
    
}

// TODO: 形状与渐变
/////
//open lazy var shapeLayer: CAShapeLayer = {
//    let shape = CAShapeLayer()
//    shape.isHidden = true
//    return shape
//}()
//
/////
//open lazy var gradientLayer: CAGradientLayer = {
//    let gradient = CAGradientLayer()
//    gradient.isHidden = true
//    return gradient
//}()
//
///// radius == nil: height / 2.0
//public func setCorner(radius: CGFloat? = nil, corners: UIRectCorner = .allCorners) {
//    lazyFire(.frame) { view in
//        guard let view = view as? Self else { return }
//        let path = UIBezierPath(
//            roundedRect: view.bounds,
//            byRoundingCorners: corners,
//            cornerRadii: CGSize(
//                width: radius ?? view.bounds.size.height / 2.0,
//                height: radius ?? view.bounds.size.height / 2.0
//            )
//        )
//        view.shapeLayer.path = path.cgPath
//        
//        view.shapeLayer.isHidden = false
//    }
//}
//
/////
//public func setGradient(
//    colors: [Any]?,
//    startPoint: CGPoint = .init(x: 0.0, y: 0.0),
//    endPoint: CGPoint = .init(x: 1.0, y: 1.0),
//    locations: [NSNumber]? = nil,
//    type: CAGradientLayerType = .axial
//) {
//    lazyFire(.frame) { view in
//        guard let view = view as? Self else { return }
//        view.gradientLayer.colors = colors
//        view.gradientLayer.startPoint = startPoint
//        view.gradientLayer.endPoint = endPoint
//        view.gradientLayer.locations = locations
//        view.gradientLayer.type = type
//        
//        view.shapeLayer.isHidden = false
//        view.gradientLayer.isHidden = false
//    }
//}
//
//public override init(frame: CGRect) {
//    super.init(frame: frame)
//    
//    loadViews(in: self)
//}
//
//public required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//}
//
//private func loadViews(in box: UIView) {
//    gradientLayer.mask = shapeLayer
//    layer.addSublayer(gradientLayer)
//}
