//
//  HintsCell.swift
//
//  Created by moonShadow on 2024/2/3
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {
    
    /// 简单展示
    public protocol HintData {
        
        /// 左侧标题
        var title: String? { get }
        
        /// 左侧详情
        var detail: String? { get }
        
        /// 右侧箭头
        var showArrow: Bool? { get }
    }
    
    /// 简单展示
    ///
    /// - 左侧: 标题 + 详情，上下排列
    /// - 右侧: 箭头
    @objc(DTBHintView)
    public final class HintView: UIView {
        
        public func updateData(_ data: HintData?) {
            titleLabel.dtb
                .text(data?.title)
                .hiddenWithEmptyText()
            
            detailLabel.dtb
                .text(data?.detail)
                .hiddenWithEmptyText()
            
            rightArrow.isHidden = (data?.showArrow == true) ? false : true
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
            
//            box.addSubview(leftStack)
//            box.addSubview(rightArrow)
//            
//            leftStack.arrangedSubviews.forEach { item in
//                item.snp.makeConstraints { make in
//                    make.width.equalTo(leftStack.snp.width)
//                }
//            }
//            leftStack.snp.makeConstraints { make in
//                make.top.equalToSuperview().offset(16.0)
//                make.left.equalToSuperview().offset(12.0)
//                make.right.lessThanOrEqualTo(rightArrow.snp.left).offset(-12.0)
//                make.bottom.equalToSuperview().offset(-16.0)
//                make.height.greaterThanOrEqualTo(22.0)
//            }
//            rightArrow.snp.makeConstraints { make in
//                make.centerY.equalToSuperview()
//                make.right.equalToSuperview().offset(-12.0)
//                make.width.height.equalTo(16.0)
//            }
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
            .tintColor(.dtb.create("#333333"))
            .image(.dtb.create("chevron.right"))
            .value
    }
    
}
