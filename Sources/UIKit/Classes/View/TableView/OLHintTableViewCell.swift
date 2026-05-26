//
//  OLHintTableViewCell.swift
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
    
    @objc(DTBOLHintTableViewCell)
    public final class OLHintTableViewCell: CardTableViewCell {
        
        private lazy var hintView = OLHintView()
        
        public func updateData(_ data: OLHintData) {
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
