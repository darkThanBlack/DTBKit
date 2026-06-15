//
//  DiskCacheHintView.swift
//  XMSport
//
//  Created by moonShadow on 2025/6/30
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

protocol DiskCacheHintViewDelegate: AnyObject {
    
    /// 右侧按钮事件
    func diskCacheHintViewButtonEvent(_ key: String)
}

protocol DiskCacheHintViewDataSource {
    /// 唯一标识
    var primaryKey: String { get }
    /// 标题
    var titleText: String? { get }
    /// 用量
    var usageText: String? { get }
    /// 详情说明
    var detailText: String? { get }
    /// 右侧按钮标题, nil 表示隐藏
    var buttonTitle: String? { get }
}

/// 存储空间 - 业务分区
class DiskCacheHintView: UIView {
    
    private var primaryKey: String? = nil
    
    weak var delegate: DiskCacheHintViewDelegate?
    
    func update(_ data: DiskCacheHintViewDataSource?) {
        self.primaryKey = data?.primaryKey
        
        titleLabel.text = data?.titleText
        usageLabel.text = data?.usageText
        detailLabel.text = data?.detailText
        if let title = data?.buttonTitle, title.isEmpty == false {
            clearButton.isHidden = false
            clearButton.setTitle(title, for: .normal)
        } else {
            clearButton.isHidden = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func refreshButtonEvent(button: UIButton) {
        if let key = primaryKey {
            delegate?.diskCacheHintViewButtonEvent(key)
        }
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(titleStack)
        box.addSubview(clearButton)
        box.addSubview(detailLabel)
        
        [
            titleStack,
            clearButton,
            detailLabel
        ].forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })
        
        NSLayoutConstraint.activate([
            titleStack.topAnchor.constraint(equalTo: box.topAnchor, constant: 16.0),
            titleStack.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: 16.0),
            titleStack.trailingAnchor.constraint(lessThanOrEqualTo: clearButton.leadingAnchor, constant: -16.0),
            
            clearButton.topAnchor.constraint(equalTo: box.topAnchor, constant: 16.0),
            clearButton.trailingAnchor.constraint(equalTo: box.trailingAnchor, constant: -16.0),
            
            detailLabel.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 16.0),
            detailLabel.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: 16.0),
            detailLabel.trailingAnchor.constraint(equalTo: box.trailingAnchor, constant: -16.0),
            detailLabel.bottomAnchor.constraint(equalTo: box.bottomAnchor, constant: -16.0)
        ])
    }
    
    private lazy var titleStack: UIStackView = {
        let stacks = UIStackView(arrangedSubviews: [
            titleLabel,
            usageLabel
        ])
        stacks.axis = .vertical
        stacks.alignment = .leading
        stacks.distribution = .equalSpacing
        stacks.spacing = 8.0
        return stacks
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = DiskUsageDepends.themeColor()
        button.setTitle("清理", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        button.setTitleColor(DiskUsageDepends.buttonTitleColor(), for: .normal)
        button.setTitleColor(DiskUsageDepends.buttonTitleColor().withAlphaComponent(0.6), for: .highlighted)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5.0
        button.contentEdgeInsets = UIEdgeInsets(top: 6.0, left: 12.0, bottom: 6.0, right: 12.0)
        button.addTarget(self, action: #selector(refreshButtonEvent(button:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = DiskUsageDepends.textColor()
        return label
    }()
    
    private lazy var usageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19.0, weight: .bold)
        label.textColor = DiskUsageDepends.textColor()
        label.text = "正在计算..."
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.textColor = DiskUsageDepends.lightTextColor()
        label.numberOfLines = 0
        return label
    }()
}
