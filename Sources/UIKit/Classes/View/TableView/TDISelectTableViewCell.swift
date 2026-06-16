//
//  TDISelectTableViewCell.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/29
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    @objc(DTBTDISelectTableViewCell)
    public final class TDISelectTableViewCell: CardTableViewCell {
        
        private lazy var selectView = TDIView.select()
        
        public func update(_ model: CellModel?) {
            super.updateCardUI(model?.style?.container)
            
            selectView.updateSelectData(model?.data)
        }
        
        public override func loadViews(in box: UIView) {
            box.addSubview(selectView)
            selectView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.greaterThanOrEqualTo(22.0)
            }
        }
        
    }
    
}
