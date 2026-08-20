//
//  StatCell.swift
//  DTBKit
//
//  Created by moonShadow on 2026/8/20
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {

    /// 统计网格 Cell，展示 title + detail
    public final class StatCell: UICollectionViewCell {

        public func config(title: String?, detail: String?) {
            titleLabel.text = title
            detailLabel.text = detail
        }

        public override init(frame: CGRect) {
            super.init(frame: frame)

            loadViews(in: contentView)
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public override var intrinsicContentSize: CGSize {
            return layoutSubviewWithSize(super.intrinsicContentSize)
        }

        public override func sizeThatFits(_ size: CGSize) -> CGSize {
            return layoutSubviewWithSize(size)
        }

        public override func layoutSubviews() {
            super.layoutSubviews()

            guard bounds != .zero else { return }

            layoutSubviewWithSize(bounds.size)
        }

        @discardableResult
        private func layoutSubviewWithSize(_ size: CGSize) -> CGSize {
            let tSize = titleLabel.sizeThatFits(size)
            titleLabel.frame = CGRect(x: 0, y: 0, width: tSize.width, height: tSize.height)

            let dSize = detailLabel.sizeThatFits(size)
            detailLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY + 2.0, width: dSize.width, height: dSize.height)

            return CGSize(width: size.width, height: detailLabel.frame.maxY)
        }

        private func loadViews(in box: UIView) {
            box.addSubview(titleLabel)
            box.addSubview(detailLabel)
        }

        private lazy var titleLabel = UILabel().dtb
            .textStyle("b6")
            .numberOfLines(1)
            .value

        private lazy var detailLabel: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.monospacedDigitSystemFont(ofSize: 17.0, weight: .bold)
            lb.textColor = .dtb.create("text")
            lb.numberOfLines = 1
            lb.adjustsFontSizeToFitWidth = true
            lb.minimumScaleFactor = 0.5
            return lb
        }()
    }
}
