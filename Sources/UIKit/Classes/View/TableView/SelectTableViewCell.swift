//
//  SelectTableViewCell.swift
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
    
    @objc(DTBSelectTableViewCell)
    public final class SelectTableViewCell: CardTableViewCell {
        
        private lazy var selectView = SelectView()
        
        public override func update(_ model: CellModel?) {
            super.update(model)
            
            selectView.updateData(model?.data)
        }
        
        public override func loadViews(in box: UIView) {
            box.addSubview(selectView)
            selectView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
    }
    
}
