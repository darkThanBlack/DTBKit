//
//  DiskUsageProgressView.swift
//  XMSport
//
//  Created by moonShadow on 2025/6/27
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

protocol DiskUsageProgressViewDataSource {
    /// APP 已用空间占总容量的百分比，取值为 [0.0, 1.0]
    var appUsedPercent: CGFloat { get }
    /// 其他已用空间占总容量的百分比，取值为 [0.0, 1.0]
    var otherUsedPercent: CGFloat { get }
}

/// 存储空间 - 用量 - 进度条
class DiskUsageProgressView: UIView {
    
    func update(_ data: DiskUsageProgressViewDataSource) {
        guard data.appUsedPercent + data.otherUsedPercent <= 1.0 else {
            return
        }
        
        NSLayoutConstraint.deactivate([
            appUsedWidthConstraint,
            otherUsedWidthConstraint
        ].compactMap({ $0 }))
        
        appUsedWidthConstraint = appUsedView.widthAnchor.constraint(
            equalTo: progressStack.widthAnchor,
            multiplier: data.appUsedPercent
        )
        otherUsedWidthConstraint = otherUsedView.widthAnchor.constraint(
            equalTo: progressStack.widthAnchor,
            multiplier: data.otherUsedPercent
        )
        
        NSLayoutConstraint.activate([
            appUsedWidthConstraint,
            otherUsedWidthConstraint
        ].compactMap({ $0 }))
        
        layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View
    
    private var appUsedWidthConstraint: NSLayoutConstraint?
    private var otherUsedWidthConstraint: NSLayoutConstraint?
    
    private func loadViews(in box: UIView) {
        box.addSubview(progressStack)
        box.addSubview(legendStack)
        
        [
            progressStack,
            legendStack
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            progressStack.topAnchor.constraint(equalTo: box.topAnchor),
            progressStack.leftAnchor.constraint(equalTo: box.leftAnchor),
            progressStack.rightAnchor.constraint(equalTo: box.rightAnchor),
            progressStack.heightAnchor.constraint(equalToConstant: 22.0),
            
            legendStack.topAnchor.constraint(equalTo: progressStack.bottomAnchor, constant: 8.0),
            legendStack.leftAnchor.constraint(equalTo: box.leftAnchor),
            legendStack.rightAnchor.constraint(equalTo: box.rightAnchor),
            legendStack.bottomAnchor.constraint(equalTo: box.bottomAnchor)
        ])
        
        appUsedWidthConstraint = appUsedView.widthAnchor.constraint(
            equalTo: progressStack.widthAnchor,
            multiplier: 0
        )
        otherUsedWidthConstraint = otherUsedView.widthAnchor.constraint(
            equalTo: progressStack.widthAnchor,
            multiplier: 0
        )
        NSLayoutConstraint.activate([
            appUsedWidthConstraint,
            otherUsedWidthConstraint
        ].compactMap({ $0 }))
        
        freeView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        freeView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private lazy var progressStack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                appUsedView,
                otherUsedView,
                freeView
            ]
        )
        stack.backgroundColor = .lightGray
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 0
        
        stack.layer.masksToBounds = true
        stack.layer.cornerRadius = 3.0
        
        return stack
    }()
    
    private lazy var appUsedView: UIView = {
        let view = UIView()
        view.backgroundColor = DiskUsageDepends.themeColor()
        return view
    }()
    
    private lazy var otherUsedView: UIView = {
        let view = UIView()
        view.backgroundColor = DiskUsageDepends.progressUsedColor()
        return view
    }()
    
    private lazy var freeView: UIView = {
        let view = UIView()
        view.backgroundColor = DiskUsageDepends.progressFreeColor()
        return view
    }()
    
    private lazy var legendStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            createLegendItem(color: DiskUsageDepends.themeColor(), text: DiskUsageDepends.appName()),
            createLegendItem(color: DiskUsageDepends.progressUsedColor(), text: "手机已用"),
            createLegendItem(color: DiskUsageDepends.progressFreeColor(), text: "剩余空间")
        ])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 15
        
        return stack
    }()
    
    private func createLegendItem(color: UIColor, text: String) -> UIStackView {
        // 颜色方块
        let colorView = UIView()
        colorView.backgroundColor = color
        colorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 12),
            colorView.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        // 文本标签
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        
        let stack = UIStackView(arrangedSubviews: [colorView, label])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        
        return stack
    }
}

