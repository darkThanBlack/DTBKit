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
    
    @objc(DTBCardTableViewCell)
    open class CardTableViewCell: BaseTableViewCell {
        
        ///
        private lazy var style = DTB.ContainerStyle.card()
        
        /// 卡片式背景
        private lazy var card = ShapeView()
        
        /// 承载真正的业务内容
        private lazy var container = UIView()
        
        /// 由子类重写, box 是 add 在 card 上的一个 container
        open func loadViews(in box: UIView) {}
        
        open func update(_ model: CellModel?) {
            if let margin = model?.style?.container?.margin, self.style.margin != margin {
                self.style.margin = margin
                card.snp.remakeConstraints { make in
                    make.edges.equalToSuperview().inset(margin)
                }
            }
            if let padding = model?.style?.container?.padding, self.style.padding != padding {
                self.style.padding = padding
                container.snp.remakeConstraints { make in
                    make.edges.equalToSuperview().inset(padding)
                }
            }
            if let shape = model?.style?.container?.shape, self.style.shape != shape {
                self.style.shape = shape
                card.updateUI(self.style.shape)
            }
        }
        
        public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            contentView.addSubview(card)
            card.addSubview(container)
            
            card.updateUI(self.style.shape)
            
            card.snp.remakeConstraints { make in
                make.edges.equalToSuperview().inset(self.style.margin ?? .zero)
            }
            container.snp.remakeConstraints { make in
                make.edges.equalToSuperview().inset(self.style.padding ?? .zero)
            }
            
            loadViews(in: container)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
