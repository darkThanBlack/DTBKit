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
    
    public protocol CellUI {
        
        var container: ContainerUI? { get }
        
        var separator: SeparatorUI? { get }
    }
    
    /// 分隔线
    public protocol SeparatorUI {
        
        var color: UIColor { get }
        
        var lineWidth: CGFloat { get }
        
        /// 根据 IndexOrder 自动显示 // 隐藏
        var autoHidden: Bool { get }
        
        /// top 是和 container 的间距
        var margin: UIEdgeInsets { get }
    }
    
    /// 自定义容器 UI
    public protocol ContainerUI {
        
        /// 外间距
        var margin: UIEdgeInsets { get }
        
        /// 内间距 (子类实现)
        var padding: UIEdgeInsets { get }
        
        /// 根据 IndexOrder 自动圆角
        var autoCorners: Bool { get }
        
        ///
        var shape: ShapeUI? { get }
    }
    
//    ///
//    @objc(DTBBaseTableViewCell)
//    open class BaseTableViewCell: UITableViewCell {
//        
//        public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//            super.init(style: style, reuseIdentifier: reuseIdentifier)
//            selectionStyle = .none
//        }
//        
//        public required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//    }
    
    @objc(DTBCardTableViewCell)
    open class CardTableViewCell: UITableViewCell {
        
        private lazy var margin = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        
        private lazy var padding = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)

        private lazy var shapeModel = DTB.ShapeStyle()
        
        /// 卡片式背景
        private lazy var card = ShapeView()
        
        /// 承载真正的业务内容
        private lazy var container = UIView()
        
        /// 由子类重写, box 是 add 在 card 上的一个 container
        open func loadViews(in box: UIView) {}
        
        open func updateUI(_ data: CellUI?, tableView: UITableView? = nil, indexPath: IndexPath? = nil) {
            
            let autoCorners: UIRectCorner? = {
                guard let indexPath = indexPath,
                      let indexOrder = tableView?.dtb.indexOrder(indexPath) else {
                    return [.allCorners]
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
            // 默认自动圆角
            shapeModel.corners = autoCorners
            
            guard let ui = data?.container else { return }
            
            if self.margin != ui.margin {
                self.margin = ui.margin
                card.snp.updateConstraints { make in
                    make.edges.equalToSuperview().inset(self.margin)
                }
            }
            
            shapeModel.update(ui.shape)
            shapeModel.corners = ui.autoCorners ? autoCorners : ui.shape?.corners
            card.update(shapeModel)
        }
        
        public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .none
            
            contentView.addSubview(card)
            card.addSubview(container)
            card.update(shapeModel)
            
            card.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(self.margin)
            }
            container.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(self.padding)
            }
            
            loadViews(in: container)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
