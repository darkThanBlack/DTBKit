//
//  SGGradientCell.swift
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

    /// 渐变 cell：左 key + 右 `GradientView` 预览。
    final class SGGradientCell: DTB.BaseTableViewCell {

        func config(key: String, style: DTB.GradientStyle) {
            keyLabel.text = key
            preview.updateUI(style)
        }

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            loadViews(in: contentView)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func loadViews(in box: UIView) {
            box.addSubview(keyLabel)
            box.addSubview(preview)

            keyLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
            }
            preview.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
                make.width.equalTo(88)
                make.height.equalTo(44)
            }
        }

        private lazy var keyLabel: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            lb.textColor = DTB.SampleDepends.textColor()
            return lb
        }()

        private lazy var preview = DTB.GradientView()
    }
}
