//
//  SGI18NCell.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/10
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {

    /// 国际化 cell：左 key + 右 value，对标 `SGColorCell` 的左右布局。
    final class SGI18NCell: DTB.BaseTableViewCell {

        /// key 列固定宽，value 列填剩余，与表头对齐。
        static let keyWidth: CGFloat = 140

        func config(key: String, value: String) {
            keyLabel.text = key
            valueLabel.text = value
        }

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            loadViews(in: contentView)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func loadViews(in box: UIView) {
            box.addSubview(contentStack)
            contentStack.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
            }
            keyLabel.snp.makeConstraints { make in
                make.width.equalTo(Self.keyWidth)
            }
        }

        private lazy var contentStack = UIStackView(arrangedSubviews: [keyLabel, valueLabel])
            .dtb.axis(.horizontal).alignment(.top).spacing(12).value

        private lazy var keyLabel: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            lb.textColor = DTB.SampleDepends.text2Color()
            lb.numberOfLines = 0
            return lb
        }()

        private lazy var valueLabel: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            lb.textColor = DTB.SampleDepends.textColor()
            lb.numberOfLines = 0
            return lb
        }()
    }
}
