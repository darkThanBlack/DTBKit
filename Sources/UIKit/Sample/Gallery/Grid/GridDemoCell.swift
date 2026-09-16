//
//  GridDemoCell.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/16
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {

    /// Grid 展示 cell：内嵌 SelfSizingGridView，验证「自身尺寸撑开 cell 高度」（预期失败）。
    final class GridDemoCell: DTB.BaseTableViewCell {

        func config(items: [UIView], gridConfig: DTB.SelfSizingGridConfig) {
            grid.update(config: gridConfig)
            grid.update(items: items)
        }

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            loadViews(in: contentView)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func loadViews(in box: UIView) {
            box.addSubview(grid)

            grid.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.leading.trailing.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().offset(-12)
            }
        }

        private lazy var grid = DTB.SelfSizingGridView()
    }
}
