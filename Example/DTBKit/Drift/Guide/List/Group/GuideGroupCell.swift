//
//  GuideGroupCell.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/31
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

protocol GuideGroupItemDataSource {
    /// 标题
    var title: String? { get }
    /// 已选择
    var isSelected: Bool { get }
    /// 已锁定
    var isLocked: Bool { get }
    /// 已完成
    var isCompleted: Bool { get }
}

/// 单个选项
class GuideGroupCell: UICollectionViewCell {
    
    func config(data: GuideGroupItemDataSource?) {
        titleLabel.text = data?.title
        let isSelected = data?.isSelected == true
        titleLabel.textColor = isSelected ? DriftAdapter.color_FF8534() : DriftAdapter.color_666666()
        bottomHint.isHidden = isSelected ? false : true
        if data?.isCompleted == true {
            stateImageView.image = DriftAdapter.imageNamed("guide_success")
        } else {
            let name = (data?.isLocked == true) ? "guide_lock" : "guide_unlock"
            stateImageView.image = DriftAdapter.imageNamed(name)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(stateImageView)
        addSubview(bottomHint)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return referSize(size)
    }
    
    private func referSize(_ boxSize: CGSize) -> CGSize {
        let iSize = CGSize(width: 14.0, height: 14.0)
        let tSize = titleLabel.sizeThatFits(boxSize)
        let myHeight = max(iSize.height, tSize.height) + 12.0 + 1.0
        return CGSize(
            width: iSize.width + 4.0 + tSize.width,
            height: max(boxSize.height, myHeight)
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stateImageView.bounds = CGRect(x: 0, y: 0, width: 14.0, height: 14.0)
        stateImageView.center = CGPoint(x: 7.0, y: bounds.midY)
        
        let tSize = titleLabel.sizeThatFits(bounds.size)
        titleLabel.bounds = CGRect(x: 0, y: 0, width: tSize.width, height: tSize.height)
        titleLabel.center = CGPoint(
            x: stateImageView.frame.maxX + 4.0 + (tSize.width / 2.0),
            y: bounds.midY
        )
        
        bottomHint.bounds = CGRect(x: 0, y: 0, width: 32.0, height: 1.0)
        bottomHint.center = CGPoint(x: bounds.midX, y: bounds.maxY - 0.5)
    }
    
    private lazy var stateImageView: UIImageView = {
        let stateImageView = UIImageView()
        stateImageView.contentMode = .scaleAspectFit
        return stateImageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        titleLabel.textColor = DriftAdapter.color_666666()
        titleLabel.text = " "
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var bottomHint: UIView = {
        let bottomHint = UIView()
        bottomHint.backgroundColor = DriftAdapter.color_FF8534()
        return bottomHint
    }()
}
