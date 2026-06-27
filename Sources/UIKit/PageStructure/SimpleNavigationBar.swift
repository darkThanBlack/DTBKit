//
//  NavigationView.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/3
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// 真正的业务实现，用 where 代替 typealias
    public protocol SimpleNavigationBarHandler: CustomNavigationBarHandler where BarType == DTB.SimpleNavigationBar {}
}

extension DTB.SimpleNavigationBarHandler {
    
    ///
    public func setupNavigatonBar(with config: DTB.SimpleNavigationBar.Config) {
        if customNavigationBar.superview == nil {
            view.addSubview(customNavigationBar)
            customNavigationBar.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
            }
        }
        
        customNavigationBar.update(with: config)
        
        // 触发状态栏获取, 从 customNavigationBar 中获取合适的状态栏样式
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension DTB.SimpleNavigationBar {
    
    /// 背景
    public enum Themes {
        /// 纯色
        case pure
        /// 渐变
        case gradient
        /// 透明
        case clear
    }
    
    /// 左侧按钮
    public enum LeftButtonStyle {
        /// "<"
        case pop
        /// "x"
        case dismiss
        /// "< x"
        case popAndDismiss
    }
    
    /// 右侧按钮
    public enum RightButtonStyle {
        /// "..."
        case more
    }
    
    /// 页面配置
    public class Config {
        
        var theme: Themes?
        
        var title: String?
        
        /// 左侧按钮
        var leftStyle: LeftButtonStyle?
        
        /// 右侧按钮
        var rightStyle: RightButtonStyle?
        
        /// 有默认实现
        var popHandler: (() -> Void)?
        
        /// 有默认实现
        var dismissHandler: (() -> Void)?
        
        var moreHandler: (() -> Void)?
        
        public init(
            theme: Themes? = .pure,
            title: String? = nil,
            leftStyle: LeftButtonStyle? = .pop,
            rightStyle: RightButtonStyle? = nil,
            popHandler: (() -> Void)? = nil,
            dismissHandler: (() -> Void)? = nil,
            moreHandler: (() -> Void)? = nil
        ) {
            self.theme = theme
            self.title = title
            self.leftStyle = leftStyle
            self.rightStyle = rightStyle
            self.popHandler = popHandler
            self.dismissHandler = dismissHandler
            self.moreHandler = moreHandler
        }
        
    }
}

extension DTB {
    
    /// 自定义的简单导航栏
    ///
    /// 自定义 nav 的一个痛点就是，你总是需要关注所有切图的具体尺寸比例，确保
    ///  - 每个 image 的视觉高度相等
    ///  - image 相对 button 水平居中
    ///  - 按钮大小尽量达到用户适宜的最小点击范围(44 * 44)
    ///
    /// 为什么呢？
    ///
    /// 举个例子，比如 "返回箭头" 和 "x" 切图大小是不同的(没有内间距的情况下)，这时让两者互换位置，
    ///  - 视觉上和屏幕的左间距需要不变
    ///  - 两者之间的间距也不能变
    ///
    /// 试来试去，你最后只能得出结论，先定好每个 image 的宽高，然后分情况设置**每一种**布局，
    /// 同时尽量通过按钮的 insets 实现间距来增大点击范围
    @objc(DTBSimpleNavigationBar)
    public class SimpleNavigationBar: UIView, CustomNavigationBar {
        
        /// 导航栏内容固定高度(不算顶部安全区)
        private let barHeight: CGFloat = 44.0
        
        /// 按钮 image 统一高度
        private let imageHeight: CGFloat = 16.0
        
        private var imageVGap: CGFloat { return (barHeight - imageHeight) / 2.0 }
        
        /// 假定设计上，左侧离屏幕间距统一为 16px
        private let leftEdgeGap: CGFloat = 16.0
        
        /// 假定设计上，左侧按钮之间间距统一为 12px
        private let leftButtonGap: CGFloat = 12.0
        
        /// 假定设计上，右侧离屏幕间距统一为 16px
        private let rightEdgeGap: CGFloat = 16.0
        
        /// 假定设计上，右侧按钮之间间距统一为 12px
        private let rightButtonGap: CGFloat = 12.0
        
        private var current: Config? = nil
        
        ///
        public func getStatusBarStyle() -> UIStatusBarStyle {
            if #available(iOS 13.0, *) {
                return .darkContent
            }
            return .default
        }

        ///
        public func update(with config: Config) {
            self.current = config
            
            reload(with: config)
        }
        
        ///
        private func reload(with config: Config) {
            titleLabel.text = config.title
            
            if let theme = config.theme {
                switch theme {
                case .pure:
                    break
                case .clear:
                    backgroundColor = .clear
                case .gradient:
                    break
                }
            }
            
            leftStack.arrangedSubviews.forEach({ $0.isHidden = true })
            if let style = config.leftStyle {
                switch style {
                case .pop:
                    popButton.isHidden = false
                    popButton.setContentEdgeInsets(UIEdgeInsets(top: imageVGap, left: leftEdgeGap, bottom: imageVGap, right: leftEdgeGap))
                case .dismiss:
                    dismissButton.isHidden = false
                    dismissButton.setContentEdgeInsets(UIEdgeInsets(top: imageVGap, left: leftEdgeGap, bottom: imageVGap, right: leftEdgeGap))
                case .popAndDismiss:
                    [popButton, dismissButton].forEach({ $0.isHidden = false })
                    popButton.setContentEdgeInsets(
                        UIEdgeInsets(
                            top: imageVGap,
                            left: leftEdgeGap,  // 第一个按钮依然吃满左间距
                            bottom: imageVGap,
                            right: leftButtonGap / 2.0  // 平分按钮间距
                        )
                    )
                    dismissButton.setContentEdgeInsets(
                        UIEdgeInsets(
                            top: imageVGap,
                            left: leftButtonGap / 2.0,  // 平分按钮间距
                            bottom: imageVGap,
                            right: leftButtonGap  // 适当增大
                        )
                    )
                }
            }
            
            rightStack.arrangedSubviews.forEach({ $0.isHidden = true })
            if let style = config.rightStyle {
                switch style {
                case .more:
                    moreButton.isHidden = false
                    moreButton.setContentEdgeInsets(UIEdgeInsets(top: imageVGap, left: rightEdgeGap, bottom: imageVGap, right: rightEdgeGap))
                }
            }
        }
        
        //MARK: Event
        
        @objc private func popButtonEvent() {
            if let handler = current?.popHandler {
                handler()
            } else {
                UIViewController.dtb.popAnyway()
            }
        }
        
        @objc private func dismissButtonEvent() {
            if let handler = current?.dismissHandler ?? current?.popHandler {
                handler()
            } else {
                UIViewController.dtb.popAnyway()
            }
        }
        
        @objc private func moreButtonEvent() {
            current?.moreHandler?()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(backgroundView)
            addSubview(contentView)
            
            backgroundView.snp.makeConstraints { make in
                make.edges.equalTo(self).inset(UIEdgeInsets.zero)
            }
            contentView.snp.makeConstraints { make in
                make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(0)
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(barHeight)
            }
            
            loadViews(in: contentView)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK: View
        
        private func loadViews(in box: UIView) {
            titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
            titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
            
            [leftStack, titleLabel, rightStack].forEach({
                box.addSubview($0)
            })
            leftStack.snp.makeConstraints { make in
                make.top.left.bottom.equalToSuperview()
                make.right.lessThanOrEqualTo(titleLabel.snp.left).offset(-8.0)
            }
            titleLabel.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
                make.width.lessThanOrEqualToSuperview().multipliedBy(0.6)
            }
            rightStack.snp.makeConstraints { make in
                make.top.right.bottom.equalToSuperview()
                make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(8.0)
            }
        }
        
        private let popWidth: CGFloat = 12.0
        
        /// 12.67x16.67 => 19x25 => 12x16
        private lazy var popButton = {
            let button = DTB.Button()
            button.setConfig(
                DTB.ButtonStyle(
                    image: .dtb.local("chevron.left"),
                    tintColor: .dtb.create("arrow"),
                    imageSize: CGSize(width: popWidth, height: imageHeight),
                )
            )
            button.addTarget(self, action: #selector(popButtonEvent), for: .touchUpInside)
            return button
        }()
        
        private let dismissWidth: CGFloat = 18.0
        
        /// 17.33x15.33 => 26x23 => 18x16
        private lazy var dismissButton = {
            let button = DTB.Button()
            button.setConfig(
                DTB.ButtonStyle(
                    image: .dtb.local("xmark"),
                    tintColor: .dtb.create("arrow"),
                    imageSize: CGSize(width: dismissWidth, height: imageHeight),
                )
            )
            button.addTarget(self, action: #selector(dismissButtonEvent), for: .touchUpInside)
            return button
        }()
        
        private let moreWidth: CGFloat = 18.0
        
        /// 18.33x5.33
        private lazy var moreButton = {
            let button = DTB.Button()
            button.setConfig(
                DTB.ButtonStyle(
                    image: .dtb.local("ellipsis"),
                    tintColor: .dtb.create("arrow"),
                    imageSize: CGSize(width: moreWidth, height: imageHeight),
                )
            )
            button.addTarget(self, action: #selector(moreButtonEvent), for: .touchUpInside)
            return button
        }()
        
        private lazy var backgroundView = {
            let view = DTB.ContainerView()
            return view
        }()
        
        private lazy var contentView = UIView().dtb
            .backgroundColor(.clear)
            .value
        
        private lazy var titleLabel = UILabel().dtb
            .textStyle("h2")
            .textAlignment(.center)
            .numberOfLines(1)
            .value
        
        private lazy var leftStack = UIStackView(arrangedSubviews: [popButton, dismissButton]).dtb
            .axis(.horizontal)
            .alignment(.center)
            .distribution(.equalSpacing)
            .spacing(0)  // 不设间距，让 button 的 insets 去实现
            .value
        
        private lazy var rightStack = UIStackView(arrangedSubviews: [moreButton]).dtb
            .axis(.horizontal)
            .alignment(.center)
            .distribution(.equalSpacing)
            .spacing(0.0)
            .value
    }
    
}

