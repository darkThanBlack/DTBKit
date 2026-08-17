//
//  DefaultSegmentItem.swift
//  Ring
//
//  Created by moonShadow on 2026/6/18
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    public final class DefaultSegmentItem: DTB.SegmentItem {
        
        public override func reloadAppearance() {
            titleLabel.textColor = .dtb.create(isSelected ? "text" : "text2")
            titleLabel.font = .dtb.create(isSelected ? 17.0 : 15.0)
            indicator.isHidden = !isSelected
        }
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            
            loadViews(in: self)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadViews(in box: UIView) {
            box.addSubview(titleLabel)
            box.addSubview(indicator)

            titleLabel.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
            }
            indicator.layer.cornerRadius = 1.5
            indicator.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(4.0)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
                make.width.equalTo(16.0)
                make.height.equalTo(3.0)
            }
        }
        
        public lazy var titleLabel = UILabel().dtb.numberOfLines(1).value
        
        private lazy var indicator: UIView = {
            let v = UIView()
            v.backgroundColor = .dtb.create("theme")
            v.isHidden = true
            return v
        }()
    }
    
}
