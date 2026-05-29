//
//  LTRHintView.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/26
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    public protocol LTRHintData: HintData {
        
        var icon: DTB.ImageData? { get }
    }
    
    /// OneLineHint, 整体单行展示
    ///
    /// - 左侧: icon + 标题, 左右排列
    /// - 右侧: 详情 + 箭头, 左右排列
    @objc(DTBLTRHintView)
    public final class LTRHintView: UIView {
        
        public func updateData(_ data: LTRHintData?) {
            iconImageView.dtb
                .setImageData(data?.icon)
                .hiddenWithEmptyImage()
            
            titleLabel.dtb
                .text(data?.title)
                .hiddenWithEmptyText()
            
            detailLabel.dtb
                .text(data?.detail)
                .hiddenWithEmptyText()
            
            rightArrow.isHidden = (data?.showArrow == true) ? false : true
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            loadViews(in: self)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadViews(in box: UIView) {
            box.addSubview(stacks)
            stacks.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
            }
        }
        
        private lazy var stacks: UIStackView = {
            let stacks = UIStackView(arrangedSubviews: [
                iconImageView,
                titleLabel,
                DTB.layout.spacer(),
                detailLabel,
                rightArrow
            ])
            stacks.axis = .horizontal
            stacks.alignment = .center
            stacks.distribution = .fill
            stacks.spacing = 4.0
            return stacks
        }()
        
        private lazy var iconImageView = UIImageView().dtb.contentMode(.scaleAspectFit).value
        
        private lazy var titleLabel = UILabel().dtb.textStyle("b1").value
        
        private lazy var detailLabel = UILabel().dtb.textStyle("c2").value
        
        private lazy var rightArrow = UIImageView().dtb
            .image(.dtb.create("chevron.right"))
            .tintColor(.dtb.create("#333333"))
            .value
    }
    
}
