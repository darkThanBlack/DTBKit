//
//  FileRowView.swift
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

    /// 一行文件 / 文件夹的内容视图（不含分隔线、不含卡片，那些由外层 ``FileListView`` 给）。
    ///
    /// 结构：`H[ iconBox | V[Title, Detail] | spacer | RightImage ]`
    /// —— 就是 ``Crumb1`` 的布局在左侧多了一个图标盒子，故照它来写（同样只用原生 API + SnapKit），不另起一套约束。
    ///
    /// 是普通 `UIView` 而不是 cell —— 表格只是它的一种承载，换承载时这层不用动。
    ///
    /// - Note: 只有「展示」，没有选择态；框架只管浏览（进入 / 返回 / 置灰不可点）。
    @objc(DTBFileRowView)
    public final class FileRowView: UIView {

        public override init(frame: CGRect) {
            super.init(frame: frame)

            loadViews(in: self)
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - Update

        public func update(node: any DTB.FileNode) {
            iconBox.backgroundColor = DTB.FileBrowserDepends.iconBackgroundColor()
            iconImageView.image = DTB.FileBrowserDepends.nodeImage(node)
            iconImageView.tintColor = DTB.FileBrowserDepends.nodeTintColor(node)

            titleLabel.text = node.nodeName
            titleLabel.isHidden = (node.nodeName?.isEmpty ?? true)

            detailLabel.text = detailText(for: node)
            detailLabel.isHidden = (detailLabel.text?.isEmpty ?? true)

            /// 只有文件夹才有「可进入」的尾部箭头；文件行把图置空（槽位照旧占着，
            /// 于是长名的截断线一律对齐 —— 也避开「带固定尺寸的 arranged subview 被 isHidden」这类坑）
            arrowImageView.image = (node.nodeKind == .folder) ? DTB.FileBrowserDepends.arrowImage() : nil
        }

        /// 副标题：文件给大小；文件夹不给（保持列表干净）
        private func detailText(for node: any DTB.FileNode) -> String? {
            guard node.nodeKind == .file, let size = node.nodeSize, size > 0 else { return nil }
            return DTB.DiskCacheManager.shared.formatFileSize(size)
        }

        // MARK: - View

        /// 行内左右留白（与尾部箭头、左侧图标盒共用）
        private let insetX: CGFloat = 16.0

        /// 上下留白：行高 = max(图标盒, 文字块) + 上下留白，随内容撑开（不设固定行高）
        private let insetY: CGFloat = 16.0

        private func loadViews(in box: UIView) {
            leftStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            arrowImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

            box.addSubview(stacks)
            stacks.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(
                    UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
                )
                /// 文字块的高度下限 = 「标题 + 副标题」两行；文件夹没有副标题，
                /// 靠它跟文件行一样高 —— 同一份列表里不该出现两种行高
                make.height.greaterThanOrEqualTo(36.0)
            }

            iconBox.addSubview(iconImageView)
            iconBox.snp.makeConstraints { make in
                make.width.height.equalTo(32.0)
            }
            iconImageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(17.0)
            }
            arrowImageView.snp.makeConstraints { make in
                make.width.height.equalTo(12.0)
            }

            /// 左列文字整宽（让 textAlignment 说了算）—— 与 ``Crumb1`` 同
            leftStack.arrangedSubviews.forEach({
                $0.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                }
            })
        }

        // MARK: - Subviews

        private lazy var stacks: UIStackView = {
            let stacks = UIStackView(arrangedSubviews: [
                iconBox,
                leftStack,
                DTB.layout.spacer(),
                arrowImageView
            ])
            stacks.axis = .horizontal
            stacks.alignment = .center
            stacks.distribution = .fill
            stacks.spacing = 12.0
            return stacks
        }()

        private lazy var leftStack: UIStackView = {
            let stacks = UIStackView(arrangedSubviews: [
                titleLabel, detailLabel
            ])
            stacks.axis = .vertical
            stacks.alignment = .center
            stacks.distribution = .fill
            stacks.spacing = 4.0
            return stacks
        }()

        /// 图标底色盒子
        private lazy var iconBox: UIView = {
            let view = UIView()
            view.layer.cornerRadius = 8.0
            view.layer.masksToBounds = true
            return view
        }()

        private lazy var iconImageView: UIImageView = {
            let view = UIImageView()
            view.contentMode = .scaleAspectFit
            return view
        }()

        private lazy var titleLabel: UILabel = {
            let view = UILabel()
            view.numberOfLines = 1
            /// 文件名场景：中间截断比尾部截断更好认
            view.lineBreakMode = .byTruncatingMiddle
            view.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
            view.textColor = DTB.FileBrowserDepends.textColor()
            return view
        }()

        private lazy var detailLabel: UILabel = {
            let view = UILabel()
            view.numberOfLines = 1
            view.lineBreakMode = .byTruncatingMiddle
            view.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            view.textColor = DTB.FileBrowserDepends.lightTextColor()
            return view
        }()

        private lazy var arrowImageView: UIImageView = {
            let view = UIImageView()
            view.contentMode = .scaleAspectFit
            view.tintColor = DTB.FileBrowserDepends.disabledTextColor()
            return view
        }()
    }
}
