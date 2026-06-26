//
//  Crumb2.swift
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
    
    /// image + title + detail + image, 整体左右分布排列
    ///
    /// - 左侧: img + title, 左右排列
    /// - 右侧: detail + img, 左右排列
    @objc(DTBCrumb3View)
    public final class Crumb3: CrumbsView {
        
        public override func updateData(_ data: DTB.SampleData?) {
            leftImageView.dtb
                .setImageData(data?.leftImage)
                .hiddenWithEmptyImage()
            
            titleLabel.dtb
                .attributedText(data?.titleAttr)
                .text(data?.title)
                .hiddenWithEmptyText()
            
            detailLabel.dtb
                .attributedText(data?.detailAttr)
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
            box.addSubview(stacks)
            stacks.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
            }
        }
        
        private lazy var stacks: UIStackView = {
            let stacks = UIStackView(arrangedSubviews: [
                leftImageView,
                titleLabel,
                DTB.layout.spacer(),
                detailLabel,
                rightImageView
            ])
            stacks.axis = .horizontal
            stacks.alignment = .center
            stacks.distribution = .fill
            stacks.spacing = 4.0
            return stacks
        }()
        
        private lazy var leftImageView = UIImageView().dtb.contentMode(.scaleAspectFit).value
        
        private lazy var titleLabel = UILabel().dtb.textStyle("h3").value
        
        private lazy var detailLabel = UILabel().dtb.textStyle("b6").value
        
        private lazy var rightImageView = UIImageView().dtb
            .contentMode(.scaleAspectFit)
            .tintColor(.dtb.create("arrow"))
            .image(.dtb.local("chevron.right"))
            .value
        
    }
    
}
