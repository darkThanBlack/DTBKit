//
//  Button.swift
//  DTBKit
//
//  Created by moonShadow on 2025/11/21
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// Replacement for UIButton.
    @objc(DTBButton)
    open class Button: BaseControl {
        
        private var stateConfig: [UInt: DTB.ButtonStyle] = [:]
        
        public func setConfig(_ config: DTB.ButtonStyle?, for state: UIControl.State = .normal) {
            stateConfig[state.rawValue] = config
            updateAppearance()
            updateLayout()
        }
        
        private func ensureConfigExist(for state: UIControl.State) {
            if stateConfig[state.rawValue] == nil {
                stateConfig[state.rawValue] = DTB.ButtonStyle()
            }
        }
        
        // -- appearance
        
        ///
        public func setShape(_ config: DTB.ShapeStyle?, for state: UIControl.State = .normal) {
            ensureConfigExist(for: state)
            stateConfig[state.rawValue]?.shape = config
            updateAppearance()
        }
        
        ///
        public func setGradient(_ config: DTB.GradientStyle?, for state: UIControl.State = .normal) {
            ensureConfigExist(for: state)
            stateConfig[state.rawValue]?.gradient = config
            updateAppearance()
        }
        
        ///
        public func setBackgroundColor(_ color: UIColor?, for state: UIControl.State = .normal) {
            ensureConfigExist(for: state)
            stateConfig[state.rawValue]?.backgroundColor = color
            updateAppearance()
        }
        
        ///
        public func setTitle(_ text: String?, for state: UIControl.State = .normal) {
            ensureConfigExist(for: state)
            stateConfig[state.rawValue]?.title = text
            updateAppearance()
        }
        
        ///
        public func setTextColor(_ color: UIColor?, for state: UIControl.State = .normal) {
            ensureConfigExist(for: state)
            stateConfig[state.rawValue]?.textColor = color
            updateAppearance()
        }
        
        ///
        public func setFont(_ font: UIFont?, for state: UIControl.State = .normal) {
            ensureConfigExist(for: state)
            stateConfig[state.rawValue]?.font = font
            updateAppearance()
        }
        
        ///
        public func setAttributedText(_ text: NSAttributedString?, for state: UIControl.State = .normal) {
            ensureConfigExist(for: state)
            stateConfig[state.rawValue]?.attributedText = text
            updateAppearance()
        }
        
        ///
        public func setImage(_ image: UIImage?, for state: UIControl.State = .normal) {
            ensureConfigExist(for: state)
            stateConfig[state.rawValue]?.image = image
            updateAppearance()
        }
        
        ///
        public func setTintColor(_ color: UIColor?, for state: UIControl.State = .normal) {
            ensureConfigExist(for: state)
            stateConfig[state.rawValue]?.tintColor = color
            updateAppearance()
        }
        
        // --- layout
        
        ///
        public func setContentEdgeInsets(_ insets: UIEdgeInsets, for state: UIControl.State = .normal) {
            ensureConfigExist(for: state)
            stateConfig[state.rawValue]?.contentEdgeInsets = insets
            updateLayout()
        }
        
        ///
        public func setImageSize(_ size: CGSize, for state: UIControl.State = .normal) {
            ensureConfigExist(for: state)
            stateConfig[state.rawValue]?.imageSize = size
            updateLayout()
        }
        
        /// left: image | title / right: title | image
        ///
        /// 指 image 在 title 的 左/右/上/下侧
        public func setImageDirection(_ direction: DTB.FourDirection, for state: UIControl.State = .normal) {
            ensureConfigExist(for: state)
            stateConfig[state.rawValue]?.imageDirection = direction
            updateLayout()
        }
        
        /// image - | offset | - title
        ///
        /// 指 image 相对于 title 中心点的偏移量
        public func setImageOffset(_ offset: CGVector, for state: UIControl.State = .normal) {
            ensureConfigExist(for: state)
            stateConfig[state.rawValue]?.imageOffset = offset
            updateLayout()
        }
        
        ///
        public lazy var titleLabel = {
            let label = UILabel()
            label.isHidden = true
            label.isUserInteractionEnabled = false
            label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
            label.textColor = .black
            label.text = " "
            label.numberOfLines = 0
            label.textAlignment = .center
            return label
        }()
        
        public lazy var imageView: UIImageView = {
            let view = UIImageView()
            view.contentMode = .scaleAspectFit
            return view
        }()
        
        public lazy var shapeBackgroundView = {
            let view = DTB.ShapeView()
            view.isUserInteractionEnabled = false
            view.isHidden = true
            return view
        }()
        
        public lazy var gradientBackgroundView = {
            let view = DTB.GradientView()
            view.isUserInteractionEnabled = false
            view.isHidden = true
            return view
        }()
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            
            loadViews(in: self)
        }
        
        required public init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadViews(in box: UIView) {
            box.addSubview(shapeBackgroundView)
            box.addSubview(gradientBackgroundView)
            box.addSubview(titleLabel)
            box.addSubview(imageView)
        }
        
        open override var isEnabled: Bool {
            didSet {
                updateAppearance()
            }
        }
        
        open override var isSelected: Bool {
            didSet {
                updateAppearance()
            }
        }
        
        open override var isHighlighted: Bool {
            didSet {
                updateAppearance()
            }
        }
        
        //MARK: - Appearance
        
        private func updateAppearance() {
            guard let config = match(stateConfig) else { return }
            
            self.backgroundColor = config.backgroundColor
            
            titleLabel.dtb
                .attributedText(config.attributedText)
                .text(config.title)
                .textColor(config.textColor)
                .font(config.font)
                .hiddenWithEmptyText()
            
            imageView.dtb
                .image(config.image)
                .tintColor(config.tintColor)
                .hiddenWithEmptyImage()
            
            // 渐变
            if let gradient = config.gradient {
                gradientBackgroundView.updateUI(gradient)
                
                shapeBackgroundView.isHidden = true
                gradientBackgroundView.isHidden = false
                return
            }
            // 形状
            if let shape = config.shape {
                shapeBackgroundView.updateUI(shape)
                
                shapeBackgroundView.isHidden = false
                gradientBackgroundView.isHidden = true
                return
            }
            // 普通背景
            shapeBackgroundView.isHidden = true
            gradientBackgroundView.isHidden = true
        }
        
        //MARK: - Layout
        
        private func updateLayout() {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
        
        open override var intrinsicContentSize: CGSize {
            return layoutSubviewWithSize(.zero)
        }
        
        open override func sizeThatFits(_ size: CGSize) -> CGSize {
            return layoutSubviewWithSize(size)
        }
        
        open override func layoutSubviews() {
            super.layoutSubviews()
            
            guard bounds.isEmpty == false else { return }
            
            // updateAppearance()
            layoutSubviewWithSize(bounds.size)
        }
        
        /// 确保性能
        @discardableResult
        private func layoutSubviewWithSize(_ size: CGSize) -> CGSize {
            guard let config = match(stateConfig) else { return .zero }
            
            shapeBackgroundView.frame = bounds
            gradientBackgroundView.frame = bounds
            
            let insets = config.contentEdgeInsets ?? .zero
            let imageDirection = config.imageDirection ?? .left
            let imageOffset = config.imageOffset ?? .zero
            
            let tSize: CGSize = titleLabel.isHidden ? .zero : titleLabel.sizeThatFits(size)
            let iSize: CGSize = imageView.isHidden ? .zero : (config.imageSize ?? imageView.sizeThatFits(size))
            
            if tSize.dtb.isEmpty() && iSize.dtb.isEmpty() {
                titleLabel.frame = .zero
                imageView.frame = .zero
                return .zero
            }
            
            // 只有文字显示，和全部显示时的逻辑相同
            if iSize.dtb.isEmpty() {
                let inferSize = tSize.dtb.margin(only: insets).value
                titleLabel.frame = CGRect(
                    x: (size.width - inferSize.width) / 2.0 + insets.left,
                    y: (size.height - inferSize.height) / 2.0 + insets.top,
                    width: tSize.width,
                    height: tSize.height
                )
                imageView.frame = .zero
                return inferSize
            }
            
            // 只有图片显示，和全部显示时的逻辑相同
            if tSize.dtb.isEmpty() {
                let inferSize = iSize.dtb.margin(only: insets).value
                titleLabel.frame = .zero
                imageView.frame = CGRect(
                    x: (size.width - inferSize.width) / 2.0 + insets.left,
                    y: (size.height - inferSize.height) / 2.0 + insets.top,
                    width: iSize.width,
                    height: iSize.height
                )
                return inferSize
            }
            
            /// 推算主轴上的间距
            let mainGap: CGFloat = {
                guard tSize.dtb.notEmpty() && iSize.dtb.notEmpty() else {
                    return 0.0
                }
                switch imageDirection {
                case .top, .bottom:
                    return imageOffset.dy
                case .left, .right:
                    return imageOffset.dx
                }
            }()
            
            /// 推算副轴上的偏移量
            let crossGap: CGFloat = {
                guard tSize.dtb.notEmpty() && iSize.dtb.notEmpty() else {
                    return 0.0
                }
                switch imageDirection {
                case .top, .bottom:
                    return imageOffset.dx
                case .left, .right:
                    return imageOffset.dy
                }
            }()
            
            /// 推算自身最小的大小
            let inferSize: CGSize = {
                switch imageDirection {
                case .top, .bottom:
                    return CGSize(
                        width: {
                            if crossGap == 0 {
                                return max(tSize.width, iSize.width)
                            }
                            // 步骤1: 虚拟中心点 (0, 0)
                            // 步骤2: 计算各元素相对于中心的边界
                            let titleBounds = (
                                left: -tSize.width / 2.0,
                                right: tSize.width / 2.0
                            )
                            let imageBounds = (
                                left: crossGap - iSize.width / 2.0,  // 考虑偏移后的缩进
                                right: crossGap + iSize.width / 2.0
                            )
                            // 步骤3: 计算总包络
                            let totalLeft = min(titleBounds.left, imageBounds.left)
                            let totalRight = max(titleBounds.right, imageBounds.right)
                            // 步骤4: 包络大小就是内容大小
                            return totalRight - totalLeft
                        }(),
                        height: tSize.height + iSize.height + mainGap
                    )
                case .left, .right:
                    return CGSize(
                        width: tSize.width + iSize.width + mainGap,
                        height: {
                            if crossGap == 0 {
                                return max(tSize.height, iSize.height)
                            }
                            // 垂直方向包络计算 - 使用相同的虚拟中心法
                            let titleBounds = (
                                top: -tSize.height / 2.0,
                                bottom: tSize.height / 2.0
                            )
                            let imageBounds = (
                                top: crossGap - iSize.height / 2.0,
                                bottom: crossGap + iSize.height / 2.0
                            )
                            let totalTop = min(titleBounds.top, imageBounds.top)
                            let totalBottom = max(titleBounds.bottom, imageBounds.bottom)
                            return totalBottom - totalTop
                        }(),
                    )
                }
            }().dtb.margin(only: insets).value
            
            // 需要考虑实际大小是否大于 inferSize;
            // 1. 是，将子视图看做一个整体，然后居中显示
            // 2. 否，按照 size == inferSize 来布局，因为不能压缩子视图
            let inferDx = max(0, (size.width - inferSize.width) / 2.0)
            let inferDy = max(0, (size.height - inferSize.height) / 2.0)
            
            switch imageDirection {
            case .top:
                imageView.frame = CGRect(
                    x: inferDx + (inferSize.width - iSize.width) / 2.0 + crossGap,
                    y: inferDy + insets.top,
                    width: iSize.width,
                    height: iSize.height
                )
                titleLabel.frame = CGRect(
                    x: inferDx + (inferSize.width - tSize.width) / 2.0,
                    y: imageView.frame.maxY + mainGap,
                    width: tSize.width,
                    height: tSize.height
                )
            case .bottom:
                titleLabel.frame = CGRect(
                    x: inferDx + (inferSize.width - tSize.width) / 2.0,
                    y: inferDy + insets.top,
                    width: tSize.width,
                    height: tSize.height
                )
                imageView.frame = CGRect(
                    x: inferDx + (inferSize.width - iSize.width) / 2.0 + crossGap,
                    y: titleLabel.frame.maxY + mainGap,
                    width: iSize.width,
                    height: iSize.height
                )
            case .left:
                imageView.frame = CGRect(
                    x: inferDx + insets.left,
                    y: inferDy + (inferSize.height - iSize.height) / 2.0 + crossGap,
                    width: iSize.width,
                    height: iSize.height
                )
                titleLabel.frame = CGRect(
                    x: imageView.frame.maxX + mainGap,
                    y: inferDy + (inferSize.height - tSize.height) / 2.0,
                    width: tSize.width,
                    height: tSize.height
                )
            case .right:
                titleLabel.frame = CGRect(
                    x: inferDx + insets.left,
                    y: inferDy + (inferSize.height - tSize.height) / 2.0,
                    width: tSize.width,
                    height: tSize.height
                )
                imageView.frame = CGRect(
                    x: titleLabel.frame.maxX + mainGap,
                    y: inferDy + (inferSize.height - iSize.height) / 2.0 + crossGap,
                    width: iSize.width,
                    height: iSize.height
                )
            }
            
            return inferSize
        }
    }
    
}

