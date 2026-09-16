//
//  GridDemoItem.swift
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

    /// 统计网格 item 视图，展示 title + detail。
    ///
    /// SelfSizingGridView 的示例 item：外层由容器设 frame，内部用 frame 布局子内容。
    public final class GridDemoItem: UIView {

        private static let hPadding: CGFloat = 14.0
        private static let vPadding: CGFloat = 7.0

        public func config(title: String?, detail: String?) {
            titleLabel.text = title
            detailLabel.text = detail
        }

        public override init(frame: CGRect) {
            super.init(frame: frame)

            loadViews(in: self)
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadViews(in box: UIView) {
            box.addSubview(titleLabel)
            box.addSubview(detailLabel)
            
            box.backgroundColor = DTB.SampleDepends.bg3Color()
            box.layer.masksToBounds = true
            box.layer.cornerRadius = 12.0
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
            let contentWidth = max(0.0, size.width - Self.hPadding * 2.0)

            let tSize = titleLabel.sizeThatFits(size)
            titleLabel.frame = CGRect(
                x: Self.hPadding,
                y: Self.vPadding,
                width: min(tSize.width, contentWidth),
                height: tSize.height
            )

            let dSize = detailLabel.sizeThatFits(size)
            detailLabel.frame = CGRect(
                x: Self.hPadding,
                y: titleLabel.frame.maxY + 2.0,
                width: min(dSize.width, contentWidth),
                height: dSize.height
            )

            return CGSize(width: size.width, height: detailLabel.frame.maxY + Self.vPadding)
        }
        
        private lazy var titleLabel: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.text2Color()
            lb.numberOfLines = 1
            return lb
        }()

        private lazy var detailLabel: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.monospacedDigitSystemFont(ofSize: 17.0, weight: .bold)
            lb.textColor = DTB.SampleDepends.textColor()
            lb.numberOfLines = 1
            lb.adjustsFontSizeToFitWidth = true
            lb.minimumScaleFactor = 0.5
            return lb
        }()
    }
}
