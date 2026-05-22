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
    
    ///
    @objc(DTBBaseTableViewCell)
    open class BaseTableViewCell: UITableViewCell {
        
        public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    ///
    @objc(DTBAutoLayoutTableViewCell)
    open class AutoLayoutTableViewCell: UITableViewCell {
        
        public lazy var separator = {
            let view = UIView()
            view.isHidden = true
            return view
        }()
        
        /// Replacement for contentView
        public lazy var container = UIView()
        
        private var data: CellData? = nil
        
        open func update(_ data: CellData?, indexPath: IndexPath? = nil, tableView: UITableView? = nil) {
            
        }
        
        public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
            contentView.backgroundColor = nil
            
            loadViews(in: contentView)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadViews(in box: UIView) {
            
        }
    }
    
    ///
    @objc(DTBSeparatorTableViewCell)
    open class SeparatorTableViewCell: BaseTableViewCell {
        
        open func inject(_ tableView: UITableView, order: DTB.IndexOrder) {
            contentView.backgroundColor = tableView.backgroundColor
//            separator.isHidden = (order == .isLast) || (order == .onlyOne)
        }
        
        public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            
            loadViews(in: contentView)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadViews(in box: UIView) {
//            box.addSubview(separator)
//            separator.snp.makeConstraints { make in
//                make.left.equalTo(box.snp.left).offset(16.0)
//                make.right.equalTo(box.snp.right).offset(-16.0)
//                make.bottom.equalTo(box.snp.bottom).offset(-0.0)
//                make.height.equalTo(0.5)
//            }
        }
    }
    
}
