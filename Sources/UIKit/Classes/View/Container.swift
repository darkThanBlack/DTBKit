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
    
    /// 设计为没有 update
    public final class Container<C: UIView>: UIView {
        
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

extension DTB {
    
    /// 简单地对 shape 和 gradient 做一个整合，没有 child，不会响应 margin / padding
    @objc(DTBContainerView)
    public final class ContainerView: UIView {
        
        private var style = DTB.ContainerStyle()
        
        public func updateUI(_ value: DTB.ContainerStyle?) {
            guard let style = value else { return }
            guard self.style != style else { return }
            self.style = style
            
            self.backgroundColor = style.backgroundColor
            
            if let gradient = style.gradient {
                gradientView.isHidden = false
                gradientView.updateUI(gradient)
            } else {
                gradientView.isHidden = true
            }
            if let shape = style.shape {
                shapeView.isHidden = false
                shapeView.updateUI(shape)
            } else {
                shapeView.isHidden = true
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
            box.addSubview(shapeView)
            box.addSubview(gradientView)
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            guard bounds.isEmpty == false else { return }
            
            shapeView.frame = bounds
            gradientView.frame = bounds
        }
        
        private lazy var shapeView = {
            let v = DTB.ShapeView()
            v.isHidden = true
            return v
        }()
        
        private lazy var gradientView = {
            let v = DTB.GradientView()
            v.isHidden = true
            return v
        }()
    }
}
