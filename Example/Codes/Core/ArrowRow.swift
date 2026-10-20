//
//  ArrowRow.swift
//  Ring
//
//  Created by moonShadow on 2026/9/28
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

/// 通用行：标题 + 尾部箭头
///
/// 由 ``DTB.Crumb3``（`itdi_arrow_1`）按需裁剪而来——app 只用「标题 + 箭头」这一种形态，
/// 自带一份，不依赖 `Crumb*` / `CrumbsView` / `CrumbsType` / `CrumbsTableViewCell`。
///
/// 本视图只负责「内容」，卡片视觉由外层 ``DTB.Container`` 提供；
/// 卡片组的拼装用 ``card(title:index:count:target:action:)``。
class ArrowRow: UIView {
    
    /// 行数据：只存数据
    struct Item {
        
        /// 业务标识
        let key: String
        
        let title: String
    }
    
    func update(title: String?) {
        titleLabel.text = title
        titleLabel.dtb.hiddenWithEmptyText()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        rightImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        box.addSubview(stacks)
        stacks.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var stacks: UIStackView = {
        let stacks = UIStackView(arrangedSubviews: [
            titleLabel,
            DTB.layout.spacer(),
            rightImageView
        ])
        stacks.axis = .horizontal
        stacks.alignment = .center
        stacks.distribution = .equalSpacing
        stacks.spacing = 8.0
        return stacks
    }()
    
    private lazy var titleLabel = UILabel().dtb.textStyle("dtb.h3").value
    
    private lazy var rightImageView = UIImageView().dtb
        .tintColor(.dtb.create("dtb.arrow"))
        .image(.dtb.local("chevron.right"))
        .contentMode(.scaleAspectFit)
        .value
}

extension ArrowRow {
    
    /// 造一张可点卡片：内容 = 标题 + 箭头，首/尾自动取圆角样式（成组时中间不留缝）
    static func card(
        title: String?,
        index: Int,
        count: Int,
        target: Any?,
        action: Selector
    ) -> UIView {
        let row = ArrowRow()
        row.update(title: title)
        
        let card = DTB.Container(child: row, style: .style(groupStyleKey(index: index, count: count)))
        card.tag = index
        card.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
        return card
    }
    
    /// 成组卡片的样式 key：单个 → `dtb.card`；首/尾 → 带圆角的 top/bottom；中间 → `dtb.card_mid`
    private static func groupStyleKey(index: Int, count: Int) -> String {
        if count <= 1 {
            return "dtb.card"
        }
        if index == 0 {
            return "dtb.card_top"
        }
        if index == count - 1 {
            return "dtb.card_bottom"
        }
        return "dtb.card_mid"
    }
}
