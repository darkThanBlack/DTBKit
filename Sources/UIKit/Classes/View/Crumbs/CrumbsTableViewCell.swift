//
//  CrumbsTableViewCell.swift
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
    
    ///
    @objc(DTBCrumbsTableViewCell)
    public final class CrumbsTableViewCell: ContainerTableViewCell {
        
        private weak var crumbs: CrumbsView? = nil
        
        public func update(crumbs: CrumbsView, model: DTB.CellModel?) {
            super.updateUI(model?.style ?? .singleCard())
            
            if self.crumbs?.superview == nil {
                childContent.addSubview(crumbs)
                crumbs.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                    make.height.greaterThanOrEqualTo(22.0)
                }
                
                self.crumbs = crumbs
            }
            self.crumbs?.updateData(model?.data)
        }
    }
}
