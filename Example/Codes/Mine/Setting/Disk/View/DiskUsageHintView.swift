//
//  DiskUsageHintView.swift
//  XMSport
//
//  Created by moonShadow on 2025/6/27
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

protocol DiskUsageHintViewDataSource {
    /// 加载中
    var isLoading: Bool { get }
    /// 顶部提示
    var hintText: String? { get }
    /// 用量
    var usageText: String? { get }
    /// 百分比
    var percentText: String? { get }
    /// 更新时间
    var updateText: String? { get }
}

/// 存储空间 - 用量 - 文字提示
class DiskUsageHintView: UIView {
    
    weak var delegate: DiskCacheEventsDelegate?
    
    func update(_ data: DiskUsageHintViewDataSource) {
        if data.isLoading {
            loadingView.isHidden = false
            loadingView.startAnimating()
            refreshButton.isHidden = true
            percentLabel.isHidden = true
            updateLabel.isHidden = true
        } else {
            loadingView.isHidden = true
            loadingView.stopAnimating()
            refreshButton.isHidden = false
            percentLabel.isHidden = false
            updateLabel.isHidden = false
        }
        
        usageLabel.text = data.usageText
        percentLabel.text = data.percentText
        updateLabel.text = data.updateText
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func refreshButtonEvent(button: UIButton) {
        delegate?.diskCacheRefreshButtonEvent()
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(textStacks)
        box.addSubview(refreshButton)
        box.addSubview(loadingView)
        
        [
            textStacks,
            refreshButton,
            loadingView
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            textStacks.topAnchor.constraint(equalTo: box.topAnchor),
            textStacks.leadingAnchor.constraint(equalTo: box.leadingAnchor),
            textStacks.bottomAnchor.constraint(equalTo: box.bottomAnchor),
            textStacks.trailingAnchor.constraint(lessThanOrEqualTo: refreshButton.leadingAnchor, constant: -16.0),
            
            refreshButton.topAnchor.constraint(equalTo: box.topAnchor),
            refreshButton.trailingAnchor.constraint(equalTo: box.trailingAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: refreshButton.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: refreshButton.centerYAnchor)
        ])
    }
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            view.style = .medium
        } else {
            view.style = .gray
        }
        return view
    }()
    
    private lazy var textStacks: UIStackView = {
        let stacks = UIStackView(arrangedSubviews: [
            hintLabel,
            usageLabel,
            percentLabel,
            updateLabel
        ])
        stacks.axis = .vertical
        stacks.alignment = .leading
        stacks.distribution = .equalSpacing
        stacks.spacing = 12.0
        return stacks
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = DiskUsageDepends.themeColor()
        button.setTitle("重新计算", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        button.setTitleColor(DiskUsageDepends.buttonTitleColor(), for: .normal)
        button.setTitleColor(DiskUsageDepends.buttonTitleColor().withAlphaComponent(0.6), for: .highlighted)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5.0
        button.contentEdgeInsets = UIEdgeInsets(top: 6.0, left: 12.0, bottom: 6.0, right: 12.0)
        button.addTarget(self, action: #selector(refreshButtonEvent(button:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = DiskUsageDepends.textColor()
        label.text = "本应用已用空间"
        return label
    }()
    
    private lazy var usageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        label.textColor = DiskUsageDepends.textColor()
        label.text = "正在计算..."
        return label
    }()
    
    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.textColor = DiskUsageDepends.lightTextColor()
        label.text = "占据手机 0% 存储空间"
        return label
    }()
    
    private lazy var updateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.textColor = DiskUsageDepends.lightTextColor()
        label.text = "尚未计算"
        return label
    }()
}
