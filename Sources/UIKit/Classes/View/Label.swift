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
    ///
    /// 结构对齐 ``DTB.Button``：自持 label + shapeView + gradientView，
    /// 尺寸由 `contentEdgeInsets` + label 内容推算，背景随 label 变化。
    /// 不响应 margin；除 text / attr 外，其余 UILabel 属性通过 ``update(_:)`` 配置。
    @objc(DTBLabel)
    public final class Label: UIView {
        
        private var config: DTB.LabelStyle?
        
        public func setConfig(_ config: DTB.LabelStyle?) {
            self.config = config
            updateAppearance()
            updateLayout()
        }
        
        private func ensureConfigExist() {
            if config == nil { config = DTB.LabelStyle() }
        }
        
        public var text: String? {
            get { label.text }
            set {
                label.text = newValue
                updateLayout()
            }
        }
        
        public var attributedText: NSAttributedString? {
            get { label.attributedText }
            set {
                label.attributedText = newValue
                updateLayout()
            }
        }
        
        /// 未覆盖的 UILabel 属性在此操作，避免关注 UILabel 具体 API。
        ///
        /// 例如 `label.update { $0.lineBreakMode = .byTruncatingTail; $0.numberOfLines = 1 }`
        public func update(_ handler: ((UILabel) -> Void)?) {
            handler?(label)
            updateLayout()
        }
        
        // MARK: - Subviews
        
        public private(set) lazy var label: UILabel = {
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
            box.addSubview(label)
        }
        
        // MARK: - Appearance
        
        private func updateAppearance() {
            guard let config = config else { return }
            
            // 等确定是普通背景再赋值，避免视觉上把圆角盖住
            self.backgroundColor = nil
            
            label.font = config.font
            label.textColor = config.textColor
            if let lines = config.numberOfLines { label.numberOfLines = lines }
            if let alignment = config.textAlignment { label.textAlignment = alignment }
            
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
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
        
        private var contentEdgeInsets: UIEdgeInsets {
            config?.contentEdgeInsets ?? .zero
        }
        
        public override var intrinsicContentSize: CGSize {
            let insets = contentEdgeInsets
            let size = label.intrinsicContentSize
            return CGSize(
                width: size.width + insets.left + insets.right,
                height: size.height + insets.top + insets.bottom
            )
        }
        
        public override func sizeThatFits(_ size: CGSize) -> CGSize {
            let insets = contentEdgeInsets
            let constrained = CGSize(
                width: max(0, size.width - insets.left - insets.right),
                height: max(0, size.height - insets.top - insets.bottom)
            )
            let fit = label.sizeThatFits(constrained)
            return CGSize(
                width: fit.width + insets.left + insets.right,
                height: fit.height + insets.top + insets.bottom
            )
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            guard bounds.isEmpty == false else { return }
            
            // 背景随 label 变化，直接铺满
            shapeView.frame = bounds
            gradientView.frame = bounds
            
            // 文字内缩 contentEdgeInsets
            let rect = bounds.inset(by: contentEdgeInsets)
            label.frame = rect
            if label.numberOfLines == 0 {
                label.preferredMaxLayoutWidth = rect.width
            }
        }
    }
    
}
