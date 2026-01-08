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
        
        private var titles: [UInt: String] = [:]
        
        private var textColors: [UInt: UIColor] = [:]
        
        private var fonts: [UInt: UIFont] = [:]
        
        private var attrTitles: [UInt: NSAttributedString] = [:]
        
        private var images: [UInt: UIImage] = [:]
        
        private var contentEdgeInsets: UIEdgeInsets = .zero
        
        private var imageDirection: DTB.FourDirection = .left
        
        private var imageOffset: CGVector = .zero
        
        ///
        public func setTitle(_ text: String?, for state: UIControl.State = .normal) {
            titles[state.rawValue] = text
            updateAppearance()
        }
        
        ///
        public func setTitleColor(_ color: UIColor?, for state: UIControl.State = .normal) {
            textColors[state.rawValue] = color
            updateAppearance()
        }
        
        ///
        public func setFont(_ font: UIFont?, for state: UIControl.State = .normal) {
            fonts[state.rawValue] = font
            updateAppearance()
        }
        
        ///
        public func setAttributedTitle(_ text: NSAttributedString?, for state: UIControl.State = .normal) {
            attrTitles[state.rawValue] = text
            updateAppearance()
        }
        
        ///
        public func setImage(_ image: UIImage?, for state: UIControl.State = .normal) {
            images[state.rawValue] = image
            updateAppearance()
        }
        
        ///
        public func setContentEdgeInsets(_ insets: UIEdgeInsets) {
            contentEdgeInsets = insets
            updateLayout()
        }
        
        /// left: image | title / right: title | image
        ///
        /// 指 image 在 title 的 左/右/上/下侧
        public func setImageDirection(_ direction: DTB.FourDirection) {
            imageDirection = direction
            updateLayout()
        }
        
        /// image - | offset | - title
        ///
        /// 指 image 相对于 title 中心点的偏移量
        public func setImageOffset(_ offset: CGVector) {
            imageOffset = offset
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
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            
            loadViews(in: self)
        }
        
        required public init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadViews(in box: UIView) {
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
            if let attr = match(attrTitles) {
                titleLabel.attributedText = attr
            } else {
                titleLabel.text = match(titles)
                titleLabel.textColor = match(textColors)
                titleLabel.font = match(fonts)
            }
            imageView.image = match(images)
            
            titleLabel.dtb.hiddenWhenEmpty()
            imageView.isHidden = imageView.image == nil
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
            
            updateAppearance()
            layoutSubviewWithSize(bounds.size)
        }
        
        @discardableResult
        private func layoutSubviewWithSize(_ size: CGSize) -> CGSize {
            let insets = contentEdgeInsets
            let tSize: CGSize = titleLabel.isHidden ? .zero : titleLabel.sizeThatFits(size)
            let iSize: CGSize = imageView.isHidden ? .zero : imageView.sizeThatFits(size)
            
            if tSize.dtb.isEmpty() && iSize.dtb.isEmpty() {
                titleLabel.frame = .zero
                imageView.frame = .zero
                return .zero
            }
            
            // 只有图片显示，此时不用考虑实际大小是否大于 inferSize，直接随着自身大小而缩放即可
            if tSize.dtb.isEmpty() {
                titleLabel.frame = .zero
                imageView.frame = CGRect(
                    x: insets.left,
                    y: insets.top,
                    width: size.width - (insets.left + insets.right),
                    height: size.height - (insets.top + insets.bottom)
                )
                return iSize.dtb.margin(only: insets).value
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

