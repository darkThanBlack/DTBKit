//
//  NavigationView.swift
//  XMKit
//
//  Created by moonShadow on 2024/1/3
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// 真正的业务实现
    public protocol SimpleNavigationBarHandler: CustomNavigationBarHandler where BarType == DTB.SimpleNavigationBar {}
}

extension DTB.SimpleNavigationBarHandler {
    
    ///
    public func setupCustomNavigatonBar(with config: DTB.SimpleNavigationBar.Config) {
        customNavigationBar.update(with: config)
        
        view.addSubview(customNavigationBar)
        
        [customNavigationBar].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            customNavigationBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0),
            customNavigationBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0),
        ])
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
    public enum LeftStyles {
        /// "<"
        case pop
        /// "x"
        case dismiss
        /// 纯文本
        case title(_ value: String)
    }
    
    /// 右侧按钮
    public enum RightStyles {
        /// 纯文本
        case title(_ value: String)
    }
    
    /// 导航栏页面默认实现
    ///
    /// 注意: 如果参数为 nil, 实际执行默认值
    public class Config {
        
        var theme: Themes?
        
        var title: String?
        
        /// 左侧单个按钮类型
        var leftStyle: LeftStyles?
        
        /// 右侧单个按钮类型
        var rightStyle: RightStyles?
        
        /// 左侧单个按钮事件 注意赋值时机
        var leftHandler: (() -> Void)?
        
        /// 右侧单个按钮事件 注意赋值时机
        var rightHandler: (() -> Void)?
        
        public init(theme: Themes? = nil, title: String? = nil, leftStyle: LeftStyles? = nil, rightStyle: RightStyles? = nil, leftHandler: (() -> Void)? = nil, rightHandler: (() -> Void)? = nil) {
            self.theme = theme
            self.title = title
            self.leftStyle = leftStyle
            self.rightStyle = rightStyle
            self.leftHandler = leftHandler
            self.rightHandler = rightHandler
        }
        
        func mergeNotNull(_ config: Config) {
            if let theme = config.theme { self.theme = theme }
            if let title = config.title { self.title = title }
            if let leftStyle = config.leftStyle { self.leftStyle = leftStyle }
            if let rightStyle = config.rightStyle { self.rightStyle = rightStyle }
            if let leftHandler = config.leftHandler { self.leftHandler = leftHandler }
            if let rightHandler = config.rightHandler { self.rightHandler = rightHandler }
        }
    }
}

extension DTB {
    
    /// 纯原生页面导航
    @objc(DTBSimpleNavigationBar)
    public class SimpleNavigationBar: UIView, CustomNavigationBarProvider {
        
        /// init with default value
        private var current: Config = Config(
            theme: .pure,
            title: nil,
            leftStyle: .pop,
            rightStyle: nil,
            leftHandler: {
                UIViewController.dtb.popAnyway()
            },
            rightHandler: nil
        )
        
        public func update(with config: Config) {
            current.mergeNotNull(config)
            updateCurrent(current)
        }
        
        private func updateCurrent(_ config: Config) {
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
            
            if let leftStyle = config.leftStyle {
                switch leftStyle {
                case .pop:
                    let image = {
                        if #available(iOS 13.0, *) {
                            return UIImage(systemName: "chevron.left")
                        } else {
                            return .dtb.create("nav_back")
                        }
                    }()
                    leftButton.dtb
                        .setTitle(nil, for: .normal)
                        .setImage(image, for: .normal)
                        .tintColor(.dtb.create("button_tint"))
                case .dismiss:
                    let image = {
                        if #available(iOS 13.0, *) {
                            return UIImage(systemName: "xmark")
                        } else {
                            return .dtb.create("nav_close")
                        }
                    }()
                    leftButton.dtb
                        .setTitle(nil, for: .normal)
                        .setImage(image, for: .normal)
                        .tintColor(.dtb.create("button_tint"))
                case .title(let value):
                    leftButton.dtb
                        .setTitle(value, for: .normal)
                        .setTitleColor(.dtb.create("text_title"), for: .normal)
                        .setImage(nil, for: .normal)
                }
            } else {
                leftButton.isHidden = true
            }
            
            if let rightStyle = config.rightStyle {
                rightButton.isHidden = false
                switch rightStyle {
                case .title(let value):
                    rightButton.dtb
                        .setTitle(value, for: .normal)
                        .setTitleColor(.dtb.create("text_title"), for: .normal)
                        .setImage(nil, for: .normal)
                }
            } else {
                rightButton.isHidden = true
            }
        }
        
        //MARK: Life Cycle
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(contentView)
            
            [contentView].forEach({
                $0.translatesAutoresizingMaskIntoConstraints = false
            })
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0.0),
                contentView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0),
                contentView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0),
                contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
                contentView.heightAnchor.constraint(equalToConstant: 44.0),
            ])
            
            loadViews(in: contentView)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK: Event
        
        @objc private func leftButtonEvent() {
            current.leftHandler?()
        }
        
        @objc private func rightButtonEvent() {
            current.rightHandler?()
        }
        
        //MARK: View
        
        private func loadViews(in box: UIView) {
            [leftStack, titleLabel, rightStack].forEach({
                box.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            })
            NSLayoutConstraint.activate([
                leftStack.topAnchor.constraint(equalTo: box.topAnchor, constant: 0.0),
                leftStack.leftAnchor.constraint(equalTo: box.leftAnchor, constant: 16.0),
                leftStack.rightAnchor.constraint(lessThanOrEqualTo: titleLabel.leftAnchor, constant: -8.0),
                leftStack.bottomAnchor.constraint(equalTo: box.bottomAnchor, constant: 0.0),
            ])
            
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: box.centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: box.centerYAnchor),
                titleLabel.widthAnchor.constraint(lessThanOrEqualTo: box.widthAnchor, multiplier: 0.6)
            ])
            
            NSLayoutConstraint.activate([
                rightStack.topAnchor.constraint(equalTo: box.topAnchor, constant: 0.0),
                rightStack.leftAnchor.constraint(greaterThanOrEqualTo: titleLabel.rightAnchor, constant: 8.0),
                rightStack.rightAnchor.constraint(equalTo: box.rightAnchor, constant: -16.0),
                rightStack.bottomAnchor.constraint(equalTo: box.bottomAnchor, constant: 0.0),
            ])
        }
        
        private lazy var leftButton: UIButton = {
            let button = UIButton(type: .custom)
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(leftButtonEvent), for: .touchUpInside)
            return button
        }()
        
        private lazy var rightButton: UIButton = {
            let button = UIButton(type: .custom)
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(rightButtonEvent), for: .touchUpInside)
            return button
        }()
        
        private lazy var contentView = UIView().dtb
            .backgroundColor(.clear)
            .value
        
        private lazy var titleLabel = UILabel().dtb
            .font(.systemFont(ofSize: 17.0, weight: .medium))
            .textColor(.dtb.create("text_title"))
            .textAlignment(.center)
            .numberOfLines(1)
            .value
        
        private lazy var leftStack = UIStackView(arrangedSubviews: [leftButton]).dtb
            .axis(.horizontal)
            .alignment(.center)
            .distribution(.equalSpacing)
            .spacing(8.0)
            .value
        
        private lazy var rightStack = UIStackView(arrangedSubviews: [rightButton]).dtb
            .axis(.horizontal)
            .alignment(.center)
            .distribution(.equalSpacing)
            .spacing(8.0)
            .value
    }
    
}

