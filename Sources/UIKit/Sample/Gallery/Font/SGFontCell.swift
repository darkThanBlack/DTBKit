//
//  SGFontCell.swift
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

    /// 字体 cell：字体名 + 该字体渲染的样例。
    final class SGFontCell: DTB.BaseTableViewCell {

        func config(name: String) {
            nameLabel.text = name
            sampleLabel.font = UIFont(name: name, size: 22) ?? UIFont.systemFont(ofSize: 22)
        }

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            loadViews(in: contentView)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func loadViews(in box: UIView) {
            box.addSubview(nameLabel)
            box.addSubview(sampleLabel)

            nameLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(8)
                make.leading.trailing.equalToSuperview().inset(16)
            }
            sampleLabel.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(2)
                make.leading.trailing.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().inset(8)
            }
        }

        private lazy var nameLabel: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            lb.textColor = DTB.SampleDepends.text2Color()
            return lb
        }()

        private lazy var sampleLabel: UILabel = {
            let lb = UILabel()
            lb.text = "AaBbCc 0123456789"
            lb.textColor = DTB.SampleDepends.textColor()
            return lb
        }()
    }
}
