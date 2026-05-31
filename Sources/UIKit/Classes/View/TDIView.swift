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
    
    /// title + detail + image, 左侧上下排列, 右侧居中
    ///
    /// - 左侧: title + detail，上下排列
    /// - 右侧: image
    @objc(DTBTDIView)
    public final class TDIView: UIView {
        
        public lazy var titleLabel = UILabel().dtb.textStyle("h3").value
        
        public lazy var detailLabel = UILabel().dtb.textStyle("c2").value
        
        public lazy var rightImageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            loadViews(in: self)
        }
        
        required init?(coder: NSCoder) {
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
    }
    
}
