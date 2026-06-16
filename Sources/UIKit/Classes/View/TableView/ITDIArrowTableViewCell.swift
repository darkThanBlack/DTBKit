//
//  ITDIArrowTableViewCell.swift
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
    
    @objc(DTBITDIArrowTableViewCell)
    public final class ITDIArrowTableViewCell: CardTableViewCell {
        
        private lazy var hintView = ITDIView.arrow()
        
        public func update(_ model: CellModel?) {
            super.updateCardUI(model?.style?.container)
            
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
