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

/// 纯原生页面导航
public class NavigationView: UIView, FastNavigationViewType {
    
    //MARK: Interface
    
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
    
    public var leftHandler: (() -> Void)? = nil
    
    public var rightHandler: (() -> Void)? = nil
    
    public func fastUpdate(title: String?, theme: Themes, leftStyle: LeftStyles, rightStyle: RightStyles?) {
        titleLabel.text = title
        
        switch theme {
        case .pure:
            break
        case .clear:
            backgroundColor = .clear
        case .gradient:
            break
        }
        
        leftStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        leftStack.addArrangedSubview(leftButton)
        [leftButton].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
//        NSLayoutConstraint.activate([
//            leftButton.widthAnchor.constraint(equalToConstant: 44.0),
//            leftButton.heightAnchor.constraint(equalTo: leftStack.heightAnchor),
//        ])
        
        switch leftStyle {
        case .pop:
            leftButton.dtb.setImage(.dtb.create("nav_back"))
        case .dismiss:
            leftButton.dtb.setImage(.dtb.create("nav_close"))
        case .title(let value):
            leftButton.dtb
                .setTitle(value)
                .setImage(nil)
        }
        
        rightStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        if let style = rightStyle {
            rightStack.addArrangedSubview(rightButton)
            [rightButton].forEach({
                $0.translatesAutoresizingMaskIntoConstraints = false
            })
//            NSLayoutConstraint.activate([
//                rightButton.heightAnchor.constraint(equalTo: leftStack.heightAnchor),
//            ])
            
            switch style {
            case .title(let value):
                rightButton.dtb.setTitle(value)
            }
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
        leftHandler?()
    }
    
    @objc private func rightButtonEvent() {
        rightHandler?()
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        [leftStack, titleLabel, rightStack].forEach({
            box.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        NSLayoutConstraint.activate([
            leftStack.topAnchor.constraint(equalTo: box.topAnchor, constant: 0.0),
            leftStack.leftAnchor.constraint(equalTo: box.leftAnchor, constant: 12.0),
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
            rightStack.rightAnchor.constraint(equalTo: box.rightAnchor, constant: -12.0),
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
    
    private lazy var leftStack = UIStackView().dtb
        .axis(.horizontal)
        .alignment(.center)
        .distribution(.equalSpacing)
        .spacing(8.0)
        .value
    
    private lazy var rightStack = UIStackView().dtb
        .axis(.horizontal)
        .alignment(.center)
        .distribution(.equalSpacing)
        .spacing(8.0)
        .value
}
