//
//  FlowDemoItem.swift
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

    /// 流式标签 item 视图，展示单个标题。
    ///
    /// SelfSizingFlowView 的示例 item：自报固有宽（文字撑开 + padding），容器据此换行。
    public final class FlowDemoItem: UIView {

        private static let hPadding: CGFloat = 14.0
        private static let vPadding: CGFloat = 7.0

        public func config(title: String?, fontSize: CGFloat = 13.0) {
            titleLabel.text = title
            titleLabel.font = .systemFont(ofSize: fontSize)
        }

        public override init(frame: CGRect) {
            super.init(frame: frame)

            backgroundColor = DTB.SampleDepends.bg3Color()
            layer.masksToBounds = true
            layer.cornerRadius = 10.0

            loadViews(in: self)
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        /// 自报尺寸：文字固有宽 + padding（宽高都由文字撑开）。
        public override func sizeThatFits(_ size: CGSize) -> CGSize {
            let s = titleLabel.sizeThatFits(size)
            return CGSize(width: s.width + Self.hPadding * 2.0, height: s.height + Self.vPadding * 2.0)
        }

        public override func layoutSubviews() {
            super.layoutSubviews()

            guard bounds != .zero else { return }

            let s = titleLabel.sizeThatFits(bounds.size)
            titleLabel.frame = CGRect(
                x: Self.hPadding,
                y: (bounds.height - s.height) / 2.0,
                width: s.width,
                height: s.height
            )
        }

        private func loadViews(in box: UIView) {
            box.addSubview(titleLabel)
        }

        private lazy var titleLabel: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.text2Color()
            lb.numberOfLines = 1
            return lb
        }()
    }
}
