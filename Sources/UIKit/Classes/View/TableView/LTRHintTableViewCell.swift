//
//  LTRHintTableViewCell.swift
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
    
    @objc(DTBLTRHintTableViewCell)
    public final class LTRHintTableViewCell: CardTableViewCell {
        
        private lazy var hintView = LTRHintView()
        
        public override func update(_ model: CellModel?) {
            super.update(model)
            
            hintView.updateData(model?.data)
        }
        
        public override func loadViews(in box: UIView) {
            box.addSubview(hintView)
            hintView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
    }
}
