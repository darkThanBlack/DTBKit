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
    
    public protocol CellData {
        
        var auto: CellAutoData? { get }
        
        var container: CellContainerData? { get }
        
        var separator: SeparatorData? { get }
    }
    
    public protocol CellAutoData {
        
        /// 自动处理背景色
        ///
        /// true: 保持 contentView 的 背景色 与 tableView 一致
        /// false: 根据 CellContainerData 控制
        var autoBackgroundColor: Bool { get }
        
        /// 自动 separator 显示 / 隐藏
        ///
        /// true: 根据 IndexOrder 控制
        /// false: 根据 SeparatorData == nil 控制
        var autoSeparator: Bool { get }
    }
    
    /// 自定义主容器
    public protocol CellContainerData {
        
        var backgroundColor: UIColor? { get }
        
        /// 外间距
        var insets: UIEdgeInsets { get }
    }
    
    /// 分隔线
    public protocol SeparatorData {
        
        var color: UIColor { get }
        
        var lineWidth: CGFloat { get }
        
        /// top 是和 container 的间距
        var insets: UIEdgeInsets { get }
    }
    
    /// 自定义容器 UI
    public protocol ContainerUI: ShapeUI {
        
        /// 外间距
        var insets: UIEdgeInsets { get }
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
        
        private var insets = UIEdgeInsets.zero
        
        open lazy var container = ShapeView()
        
        open func loadViews(in box: UIView) {}
        
        open func updateUI(_ containerUI: ContainerUI?, indexOrder: DTB.IndexOrder? = nil) {
            guard let ui = containerUI else { return }
            let autoCorners: UIRectCorner? = {
                if let corners = ui.corners {
                    return corners
                }
                if let order = indexOrder {
                    switch order {
                    case .isMiddle:
                        return []
                    case .onlyOne:
                        return [.topLeft, .topRight, .bottomRight, .bottomLeft]
                    case .isFirst:
                        return [.topLeft, .topRight]
                    case .isLast:
                        return [.bottomLeft, .bottomRight]
                    }
                }
                return nil
            }()
            var config = DTB.ShapeConfig(ui: ui)
            config.corners = autoCorners
            container.update(config)
            if self.insets != ui.insets {
                self.insets = ui.insets
                container.snp.updateConstraints { make in
                    make.edges.equalToSuperview().inset(self.insets)
                }
            }
        }
        
        public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .none
            
            contentView.addSubview(container)
            container.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(self.insets)
            }
            
            loadViews(in: container)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
