//
//  FileBrowserCells.swift
//  DTBKit
//
//  Created by moonShadow on 2026/10/8
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {

    /// 一行一格的薄壳 cell：只把 ``FileRowView`` 钉满 `contentView`。
    ///
    /// 行视图是普通 `UIView`，cell 只是它在表格里的承载 —— 换承载时这里可整个替换。
    @objc(DTBFileBrowserNodeCell)
    public final class FileBrowserNodeCell: DTB.BaseTableViewCell {

        public func config(node: any DTB.FileNode) {
            rowView.update(node: node)
        }

        public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)

            contentView.addSubview(rowView)
            rowView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private lazy var rowView = DTB.FileRowView()
    }
}
