//
//  HintTableViewCell.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/25
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    @objc(DTBHintTableViewCell)
    public final class HintTableViewCell: CardTableViewCell {
        
        private lazy var hintView = HintView()
        
        public func updateData(_ data: HintData) {
            hintView.updateData(data)
        }
        
        public override func loadViews(in box: UIView) {
            box.addSubview(hintView)
            hintView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
    }
    
}
