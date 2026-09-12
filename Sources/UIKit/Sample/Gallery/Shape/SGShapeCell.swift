//
//  SGShapeCell.swift
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

    /// 形状 cell：左 key + 右 `ShapeView` 预览。
    final class SGShapeCell: DTB.BaseTableViewCell {

        static let previewSize: CGFloat = 44

        func config(key: String, style: DTB.ShapeStyle) {
            keyLabel.text = key
            // 无 fill 无 stroke 的形状（dtb.circle / dtb.sheet）本身不可见，预览时给个填充色好观察圆角
            var s = style
            if s.fillColor == nil, s.strokeColor == nil {
                s.fillColor = DTB.SampleDepends.themeColor()
            }
            preview.updateUI(s)
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
                make.width.height.equalTo(Self.previewSize)
            }
        }

        private lazy var keyLabel: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            lb.textColor = DTB.SampleDepends.textColor()
            return lb
        }()

        private lazy var preview = DTB.ShapeView()
    }
}
