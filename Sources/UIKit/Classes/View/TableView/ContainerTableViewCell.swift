//
//  BaseTableViewCell.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/10
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    ///
    @objc(DTBBaseTableViewCell)
    open class BaseTableViewCell: UITableViewCell {
        
        public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            // disable selection
            selectionStyle = .none
            
            // 确保系统不会插入 _UISystemBackgroundView
            backgroundColor = .clear
            
            // 确保不会出现黑色背景
            contentView.backgroundColor = .clear
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    @objc(DTBContainerTableViewCell)
    open class ContainerTableViewCell: BaseTableViewCell {
        
        ///
        private lazy var style = DTB.ContainerStyle()
        
        /// 卡片式背景
        public lazy var container = ContainerView()
        
        /// 承载真正的业务内容
        public lazy var childContent = UIView()
        
        /// 由子类重写, box 是 add 在 container 上的一个 childContent
        open func loadViews(in box: UIView) {}
        
        open func updateUI(_ style: DTB.ContainerStyle?) {
            container.updateUI(style)
            if let margin = style?.margin, self.style.margin != margin {
                self.style.margin = margin
                container.snp.remakeConstraints { make in
                    make.edges.equalToSuperview().inset(margin)
                }
            }
            if let padding = style?.padding, self.style.padding != padding {
                self.style.padding = padding
                childContent.snp.remakeConstraints { make in
                    make.edges.equalToSuperview().inset(padding)
                }
            }
        }
        
        public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            contentView.addSubview(container)
            container.addSubview(childContent)
            
            container.updateUI(self.style)
            
            container.snp.remakeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
            }
            childContent.snp.remakeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
            }
            
            loadViews(in: childContent)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
