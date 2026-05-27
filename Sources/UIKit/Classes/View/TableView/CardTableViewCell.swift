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
    
    /// 分隔线
    public protocol SeparatorUI {
        
        var color: UIColor { get }
        
        var lineWidth: CGFloat { get }
        
        /// 根据 IndexOrder 自动显示 / 隐藏
        var autoHidden: Bool { get }
        
        /// top 是和 container 的间距
        var margin: UIEdgeInsets { get }
    }
    
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
        private lazy var style = DTB.ContainerStyle(
            margin: UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0),
            padding: UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0),
            shape: DTB.ShapeStyle(
                radius: 12.0,
                fillColor: .white,
            )
        )
        
        /// 卡片式背景
        private lazy var card = ShapeView()
        
        /// 承载真正的业务内容
        private lazy var container = UIView()
        
        /// 由子类重写, box 是 add 在 card 上的一个 container
        open func loadViews(in box: UIView) {}
        
        open func updateUI(_ data: DTB.CellStyle? = nil, tableView: UITableView? = nil, indexPath: IndexPath? = nil) {
            if let margin = data?.container?.margin, style.margin != margin {
                self.style.margin = margin
                card.snp.updateConstraints { make in
                    make.edges.equalToSuperview().inset(self.style.margin)
                }
            }
            if let padding = data?.container?.padding, style.padding != padding {
                self.style.padding = padding
                container.snp.makeConstraints { make in
                    make.edges.equalToSuperview().inset(self.style.padding)
                }
            }
            
            if let shape = data?.container?.shape {
                style.shape = shape
            }
            
            let checkedCorners: UIRectCorner? = {
                // 有指定传参, 以指定值为准
                if let corners = data?.container?.shape?.corners {
                    return corners
                }
                // 否则, 默认根据 indexOrder 自动计算
                guard let indexPath = indexPath,
                      let indexOrder = tableView?.dtb.indexOrder(indexPath) else {
                    return nil
                }
                switch indexOrder {
                case .isMiddle:
                    return []
                case .onlyOne:
                    return [.topLeft, .topRight, .bottomRight, .bottomLeft]
                case .isFirst:
                    return [.topLeft, .topRight]
                case .isLast:
                    return [.bottomLeft, .bottomRight]
                }
            }()
            style.shape?.corners = checkedCorners
            
            card.updateUI(style.shape)
        }
        
        public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            contentView.addSubview(card)
            card.addSubview(container)
            
            card.updateUI(self.style.shape)
            
            card.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(self.style.margin)
            }
            container.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(self.style.padding)
            }
            
            loadViews(in: container)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
