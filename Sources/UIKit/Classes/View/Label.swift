//
//  Label.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/9
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// Replacement for UILabel + EdgeLabel.
    @objc(DTBLabel)
    public final class Label: BaseSelfSizingView {
        
        private var config: DTB.LabelStyle? = nil
        
        public func updateUI(_ value: DTB.LabelStyle?) {
            self.config = value
            updateAppearance()
            updateLayout()
        }
        
        public var text: String? {
            get { textLabel.text }
            set {
                textLabel.text = newValue
                updateLayout()
            }
        }
        
        public var attributedText: NSAttributedString? {
            get { textLabel.attributedText }
            set {
                textLabel.attributedText = newValue
                updateLayout()
            }
        }
        
        /// 允许直接操作 UILabel
        ///
        /// 注意: 如果设置了 DTB.LabelStyle，那么相关属性会被 style 覆盖
        public func label(_ handler: ((UILabel) -> Void)?) {
            handler?(textLabel)
            updateLayout()
        }
        
        // MARK: - Subviews
        
        private lazy var textLabel: UILabel = {
            let lb = UILabel()
            lb.isUserInteractionEnabled = false
            return lb
        }()
        
        private lazy var shapeView: DTB.ShapeView = {
            let v = DTB.ShapeView()
            v.isUserInteractionEnabled = false
            v.isHidden = true
            return v
        }()
        
        private lazy var gradientView: DTB.GradientView = {
            let v = DTB.GradientView()
            v.isUserInteractionEnabled = false
            v.isHidden = true
            return v
        }()
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            loadViews(in: self)
        }
        
        required public init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadViews(in box: UIView) {
            box.addSubview(shapeView)
            box.addSubview(gradientView)
            box.addSubview(textLabel)
        }
        
        /// 只处理 style 有值时的情况
        private func updateAppearance() {
            guard let config = config else { return }
            
            // 等确定是普通背景再赋值，避免视觉上把圆角盖住
            self.backgroundColor = nil
            
            textLabel.font = config.font
            textLabel.textColor = config.textColor
            if let lines = config.numberOfLines { textLabel.numberOfLines = lines }
            if let alignment = config.textAlignment { textLabel.textAlignment = alignment }
            
            // 是渐变
            if let gradient = config.gradient {
                gradientView.updateUI(gradient)
                
                shapeView.isHidden = true
                gradientView.isHidden = false
                return
            }
            // 有形状
            if let shape = config.shape {
                shapeView.updateUI(shape)
                
                shapeView.isHidden = false
                gradientView.isHidden = true
                return
            }
            
            // 是普通背景
            self.backgroundColor = config.backgroundColor
            shapeView.isHidden = true
            gradientView.isHidden = true
        }
        
        // MARK: - Layout
        
        private func updateLayout() {
            // invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
        
        public override func layoutInferSize(by size: CGSize) -> CGSize {
            let contentEdgeInsets = config?.contentEdgeInsets ?? .zero
            // 保持内间距不变
            let inner = size.dtb.padding(only: contentEdgeInsets).value
            let innerLabelSize = textLabel.sizeThatFits(inner)
            return innerLabelSize.dtb.margin(only: contentEdgeInsets).value
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            guard bounds.isEmpty == false else { return }
            
            // 背景直接铺满
            shapeView.frame = bounds
            gradientView.frame = bounds
            
            //
            let contentEdgeInsets = config?.contentEdgeInsets ?? .zero
            textLabel.frame = bounds.inset(by: contentEdgeInsets)
        }
    }
    
}
