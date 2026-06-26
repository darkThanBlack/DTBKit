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
    
    /// 按照规范当然应该对每个 Crumbs 创建对应的 Cell，但这个我懒得弄了，
    /// 设计一个能勉强通用的 Cell 包一层，配合 CrumbsSampleView 快速展示
    @objc(DTBCrumbsTableViewCell)
    public final class CrumbsTableViewCell: ContainerTableViewCell {
        
        public private(set) weak var crumbs: CrumbsView? = nil
        
        private var type: CrumbsType? = nil
        
        public func registerCrumbs(type: CrumbsType) {
            guard self.type != type else {
                return
            }
            self.type = type
            
            self.crumbs?.removeFromSuperview()
            self.crumbs = nil
            
            let view = CrumbsView.create(type)
            childContent.addSubview(view)
            view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.greaterThanOrEqualTo(22.0)
            }
            self.crumbs = view
        }
        
        public func update(model: DTB.CellModel?) {
            super.updateUI(model?.style)
            
            self.crumbs?.updateData(model?.data)
        }
    }
}
