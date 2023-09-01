//
//  XMDotSegmentCell.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/30
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// 默认实现
struct XMDotSegmentCellModel: XMDotSegmentCellDataSource {
    
    var primaryKey: String?
    
    var title: String?
    
    var options: [XMDotSegmentItemDataSource]
    
    var showSingleLine: Bool
}

/// 默认实现
struct XMDotSegmentItemModel: XMDotSegmentItemDataSource {
    
    var primaryKey: String?
    
    var title: String?
    
    var isSelected: Bool
}

/// 互斥单选 - 单个选项
protocol XMDotSegmentItemDataSource {
    /// 选项唯一标识
    var primaryKey: String? { get }
    /// 选项名
    var title: String? { get }
    ///
    var isSelected: Bool { get set }
}

/// Cell - 互斥单选
protocol XMDotSegmentCellDataSource {
    /// 单行唯一标识
    var primaryKey: String? { get }
    /// 左侧标题
    var title: String? { get }
    /// 右侧选项
    var options: [XMDotSegmentItemDataSource] { get }
    /// 分隔线
    var showSingleLine: Bool { get }
}

/// Cell - 互斥单选
protocol XMDotSegmentCellDelegate: AnyObject {
    /// 点击某个选项
    func dotSegmentCellDidTap(_ cell: UITableViewCell?, cellKey: String?, itemKey: String?)
}

/// Cell - 互斥单选
class XMDotSegmentCell: UITableViewCell {
    
    weak var delegate: XMDotSegmentCellDelegate?
    
    private var buttons: [XMDotSegmentItem] = []
    
    func config(with data: XMDotSegmentCellDataSource) {
        titleLabel.text = data.title
        singleLine.isHidden = data.showSingleLine ? false : true
        
        guard data.options.count > 1 else {
            return
        }
        
        Array<Any>.align(
            sources: &buttons,
            targets: data.options,
            creater: { [weak self] model in
                let button = XMDotSegmentItem()
                self?.optionStackView.addArrangedSubview(button)
                return button
            },
            remover: { button in
                button.removeFromSuperview()
            },
            syncer: { button, model in
                button.primaryKey = model.primaryKey
                button.title = model.title
                button.state = model.isSelected ? .selected : .unSelect
                button.eventHandler = { [weak self] _ in
                    self?.delegate?.dotSegmentCellDidTap(self, cellKey: data.primaryKey, itemKey: model.primaryKey)
                }
            }, completedHandler: { [weak self] in
                self?.setNeedsLayout()
            }
        )
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        loadSubViews(in: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View
    
    private func loadSubViews(in box: UIView) {
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        optionStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        box.addSubview(titleLabel)
        box.addSubview(optionStackView)
        box.addSubview(singleLine)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.left.equalToSuperview().offset(16.0)
            make.bottom.equalToSuperview().offset(-16.0)
            
            make.height.greaterThanOrEqualTo(22.0)
        }
        optionStackView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            
            make.top.bottom.equalToSuperview()
        }
        singleLine.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = XMVisual.Color.Gray.A
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var optionStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 8.0
        return stack
    }()
    
    private lazy var singleLine: UIView = {
        let singleLine = UIView()
        singleLine.backgroundColor = XMVisual.Color.White.D
        return singleLine
    }()
}
