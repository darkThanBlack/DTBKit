//
//  FileListView.swift
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

    /// ``FileListView`` 的事件出口
    public protocol FileListViewDelegate: AnyObject {

        /// 第 index 行被点了（哑组件只认下标，不认业务模型）
        func fileListView(_ list: DTB.FileListView, didSelectAt index: Int)
    }

    /// 文件列表的**哑组件**：给什么画什么，只回报「第几行被点了」。
    ///
    /// 不认识路径栈、不认识业务模型、不判断「在加载还是真的空」—— 内容由上层组织好后 ``update(_:)`` 一把传入。
    /// 行高自适应（`dtb.plain` 已铺好预估行高），故行视图只要把内容撑起来即可。
    ///
    /// - Note: 表格只是承载。对外契约只有 node（`[any FileNode]`），`IndexPath` / cell 一概不外露；
    ///   换承载（``ReusableScrollView`` / SelfSizing 单列）只需重写这一个文件。
    @objc(DTBFileListView)
    public final class FileListView: UIView {

        public weak var delegate: (any DTB.FileListViewDelegate)?

        /// 当前展示的内容（顺序即展示顺序）
        public private(set) var nodes: [any DTB.FileNode] = []

        public override init(frame: CGRect) {
            super.init(frame: frame)

            loadViews(in: self)
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - Interface

        public func update(_ nodes: [any DTB.FileNode]) {
            self.nodes = nodes

            tableView.reloadData()
        }

        // MARK: - View

        private func loadViews(in box: UIView) {
            backgroundColor = DTB.FileBrowserDepends.backgroundColor()

            box.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            /// 干掉末行分隔线（省掉「是不是最后一行」在全链路上传参）
            tableView.tableFooterView = UIView()
        }

        // MARK: - Subviews

        private lazy var tableView: UITableView = {
            let view = UITableView.dtb.plain(self, cells: [DTB.FileBrowserNodeCell.self])
            view.backgroundColor = .clear
            /// 行高交给行视图自己撑（分隔线 / 预估行高由 `dtb.plain` 铺好，这里不再重复配置）
            view.rowHeight = UITableView.automaticDimension
            return view
        }()
    }
}

extension DTB.FileListView: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodes.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DTB.FileBrowserNodeCell = tableView.dtb.dequeueReusableCellEnsured(indexPath)
        if nodes.indices.contains(indexPath.row) {
            cell.config(node: nodes[indexPath.row])
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        guard nodes.indices.contains(indexPath.row) else { return }
        delegate?.fileListView(self, didSelectAt: indexPath.row)
    }
}
