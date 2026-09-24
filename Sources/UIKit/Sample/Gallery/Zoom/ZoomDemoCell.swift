//
//  ZoomDemoCell.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/17
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {

    /// 缩放对比用 cell：一格一段长文字（`numberOfLines = 0` + `clipsToBounds`）。
    ///
    /// 两种机制下同一份内容的表现差异：
    /// - `.transform`：整格被当作**位图**拉伸 —— 字号视觉变大、边缘模糊、**行数不变**（cell 没重排）。
    /// - `.frame`：格子和 label 一起变大 —— **字号不变、行数变多**（`layoutSubviews` 里 label 宽度变 → 重新折行）。
    final class ZoomDemoCell: DTB.ReusableCell {

        /// 累计创建实例数（静态，跨复用共享）——用于证明缩放机制没有破坏复用。
        static var createdCount = 0

        private static let longText = "这是一段用于观察两种缩放差异的长文字：transform 时整格被当作位图拉伸，字号变大、边缘模糊，行数不变；frame 时格子和文字框一起变大，文字重新折行，字号不变但展示的行数变多。放大看看差别。"

        private var index: Int?

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
            index = nil
            label.text = nil
        }

        /// 配置内容（业务在 `cellFor` 里调用；frame 由容器设置）。
        func config(index: Int) {
            self.index = index
            label.text = "#\(index) " + Self.longText
            backgroundColor = (index % 2 == 0)
                ? DTB.SampleDepends.bg3Color()
                : DTB.SampleDepends.bg2Color()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            guard bounds != .zero else { return }
            // 只改 label 的框：宽度一变，UILabel 自己重新折行（字号恒定）
            label.frame = bounds.insetBy(dx: 6, dy: 6)
        }

        private func loadViews(in box: UIView) {
            box.clipsToBounds = true
            box.layer.borderWidth = 0.5
            box.layer.borderColor = DTB.SampleDepends.borderColor().cgColor
            box.addSubview(label)
        }

        private lazy var label: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.systemFont(ofSize: 9.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.text2Color()
            lb.numberOfLines = 0
            return lb
        }()
    }
}
