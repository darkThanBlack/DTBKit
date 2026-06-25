//
//  Crumb1.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/25
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// title + detail + image, 左侧上下排列, 右侧居中
    ///
    /// - 左侧: title + detail，上下排列
    /// - 右侧: image
    @objc(DTBCrumb1View)
    final class Crumb1: CrumbsView {
        
        public override func updateData(_ data: DTB.SampleData?) {
            titleLabel.dtb
                .text(data?.title)
                .hiddenWithEmptyText()
            
            detailLabel.dtb
                .text(data?.detail)
                .hiddenWithEmptyText()
            
            rightImageView.dtb
                .isHidden((data?.showArrow == true) ? false : true)
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
            rightImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            
            box.addSubview(stacks)
            stacks.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
            }
        }
        
        private lazy var stacks: UIStackView = {
            let stacks = UIStackView(arrangedSubviews: [
                leftStack,
                DTB.layout.spacer(),
                rightImageView
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
        
        private lazy var titleLabel = UILabel().dtb.textStyle("h3").value
        
        private lazy var detailLabel = UILabel().dtb.textStyle("c2").value
        
        private lazy var rightImageView = UIImageView().dtb
            .tintColor(.dtb.create("arrow"))
            .image(.dtb.local("chevron.right"))
            .contentMode(.scaleAspectFit)
            .value
    }
    
}
