//
//  TDIArrowTableViewCell.swift
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
    
    @objc(DTBTDIArrowTableViewCell)
    public final class TDIArrowTableViewCell: CardTableViewCell {
        
        private lazy var hintView = TDIView.arrow()
        
        public override func update(_ model: CellModel?) {
            super.update(model)
            
            hintView.updateArrowData(model?.data)
        }
        
        public override func loadViews(in box: UIView) {
            box.addSubview(hintView)
            hintView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.greaterThanOrEqualTo(22.0)
            }
        }
        
    }
    
}
