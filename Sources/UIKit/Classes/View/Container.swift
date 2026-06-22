//
//  Container.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/16
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    public final class Container<C: UIView>: BaseView {
        
        public weak var child: C?
        
        private let style: DTB.ContainerStyle
        
        public init(
            child: @autoclosure (() -> C),
            style: DTB.ContainerStyle
        ) {
            self.style = style
            super.init(frame: .zero)
            
            loadViews(in: self, child: child())
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadViews(in box: UIView, child: C) {
            box.backgroundColor = style.backgroundColor
            
            let margin = style.margin ?? .zero
            let padding = style.padding ?? .zero
            
            if let gradient = style.gradient {
                gradientView.updateUI(gradient)
                box.addSubview(gradientView)
                gradientView.snp.makeConstraints { make in
                    make.edges.equalTo(box).inset(margin)
                }
            }
            if let shape = style.shape {
                shapeView.updateUI(shape)
                box.addSubview(shapeView)
                shapeView.snp.makeConstraints { make in
                    make.edges.equalTo(box).inset(margin)
                }
            }
            
            box.addSubview(child)
            child.snp.makeConstraints { make in
                make.edges.equalTo(box).inset(
                    UIEdgeInsets(
                        top: margin.top + padding.top,
                        left: margin.left + padding.left,
                        bottom: margin.bottom + padding.bottom,
                        right: margin.right + padding.right
                    )
                )
            }
            
            self.child = child
        }
        
        public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            guard let child = child, !child.isHidden, child.alpha > 0.01, child.isUserInteractionEnabled else {
                return super.hitTest(point, with: event)
            }
            
            let childPoint = convert(point, to: child)
            if child.bounds.contains(childPoint) {
                return child.hitTest(childPoint, with: event) ?? child
            }
            
            return super.hitTest(point, with: event)
        }
        
        private lazy var shapeView = ShapeView()
        
        private lazy var gradientView = GradientView()
    }
}
