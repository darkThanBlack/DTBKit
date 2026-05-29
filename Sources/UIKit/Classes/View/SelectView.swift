//
//  SelectView.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/29
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// 简单展示
    public protocol SelectData {
        
        /// 左侧标题
        var title: String? { get }
        
        /// 左侧详情
        var detail: String? { get }
        
        /// 右侧箭头
        var isSelected: Bool? { get }
    }
    
    /// 简单选择
    ///
    /// - 左侧: 标题 + 详情，上下排列
    /// - 右侧: 是否选择
    @objc(DTBSelectView)
    public final class SelectView: UIView {
        
        public func updateData(_ data: SelectData?) {
            titleLabel.dtb
                .text(data?.title)
                .hiddenWithEmptyText()
            
            detailLabel.dtb
                .text(data?.detail)
                .hiddenWithEmptyText()
            
            rightArrow.isHidden = (data?.isSelected == true) ? false : true
        }
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            
            loadViews(in: self)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadViews(in box: UIView) {
            leftStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            rightArrow.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            
            box.addSubview(stacks)
            stacks.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
            }
        }
        
        private lazy var stacks: UIStackView = {
            let stacks = UIStackView(arrangedSubviews: [
                leftStack,
                DTB.layout.spacer(),
                rightArrow
            ])
            stacks.axis = .horizontal
            stacks.alignment = .center
            stacks.distribution = .equalSpacing
            stacks.spacing = 8.0
            return stacks
        }()
        
        private lazy var leftStack = UIStackView(arrangedSubviews: [
            titleLabel, detailLabel
        ]).dtb
            .axis(.vertical)
            .alignment(.center)
            .distribution(.equalSpacing)
            .spacing(4.0)
            .value
        
        private lazy var titleLabel = UILabel().dtb.textStyle("b1").value
        
        private lazy var detailLabel = UILabel().dtb.textStyle("c2").value
        
        private lazy var rightArrow = UIImageView().dtb
            .image(.dtb.create("checkmark.circle.fill"))
            .tintColor(.dtb.create("theme"))
            .value
    }
}
