//
//  ScrollDemoCell.swift
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

    /// ReusableScrollView 的示例 cell：显示 (row, column)，交替底色便于观察复用。
    ///
    /// `createdCount` 用于证明复用：若复用生效，滚动后它应停在「可见数」量级，而非 `row × column`。
    final class ScrollDemoCell: DTB.ReusableCell {

        /// 累计创建实例数（静态，跨复用共享）。
        static var createdCount = 0

        private var coordinate: (row: Int, column: Int)?

        override init(frame: CGRect) {
            super.init(frame: frame)
            Self.createdCount += 1
            loadViews(in: self)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            coordinate = nil
            titleLabel.text = nil
        }

        /// 配置内容（业务在 `cellFor` 里调用；frame 由容器设置）。
        func config(row: Int, column: Int) {
            coordinate = (row, column)
            titleLabel.text = "R\(row) C\(column)"
            backgroundColor = ((row + column) % 2 == 0)
                ? DTB.SampleDepends.bg3Color()
                : DTB.SampleDepends.bg2Color()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            guard bounds != .zero else { return }
            titleLabel.frame = bounds
        }

        private func loadViews(in box: UIView) {
            box.addSubview(titleLabel)
            box.layer.borderColor = DTB.SampleDepends.borderColor().cgColor
            box.layer.borderWidth = 0.5
        }

        private lazy var titleLabel: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.monospacedDigitSystemFont(ofSize: 11.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.text2Color()
            lb.textAlignment = .center
            lb.numberOfLines = 1
            return lb
        }()
    }
}
