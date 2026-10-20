//
//  SGFileBrowserViewController.swift
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

    /// FileBrowser 展示页（Sample 画廊页）。
    ///
    /// 这一页同时是**装配示例**：``FileBrowserView`` 只是「路径条 + 列表 + 状态文案」的纯 UI 组合，
    /// 它一份数据都不持有 —— 「现在在哪几层、这一层有什么、哪些进不去」全在本页。
    /// 本页的业务就两块：一个 ``FilePathStack``（路径）+ 一个 ``FileBrowserDataSource`` 实现（内容）。
    ///
    /// 值得盯着看的几处：
    /// - 进「作业」→「第一单元」→「课后练习」：面包屑逐层增长并自动滚到末尾；
    /// - 每次改路径都会先显示「加载中…」（数据源是异步的），随后换成内容；
    /// - 点面包屑任意祖先**立刻**回退且**不重新请求数据源**（内容命中缓存 → 同步回调，所以连 loading 都看不见）；
    /// - 「空目录」「第三单元（空）」显示「暂无文件」；
    /// - 「进不去的目录」点了没反应：`canSelectNodeAt` 返回 false，框架连事件都不上报（底部那行会说明是它拦的）；
    /// - 「图片素材」60 条：长列表滚动，行高由行内容自适应；
    /// - 点任意文件：底部那行显示 `didSelectNodeAt` 收到的**行号**（业务自己映射回节点）。
    final class SGFileBrowserViewController: DTB.BaseViewController, DTB.FileBrowserPathDataSource, DTB.FileBrowserDelegate {

        /// 内容源：换一套实现（本地沙盒 / 云端）即换这一个，本页其余代码不动
        private let provider = DTB.FileBrowserMockProvider()

        /// 路径栈：现在在哪一层（框架不再持有 paths，所以这就是唯一那份账）
        private lazy var stack = DTB.FilePathStack(rootID: provider.root.nodeID)

        /// id → 节点：路径上每一层的名字得我们自己手上就有（框架只会问「第 i 项是什么」）
        private var nodeCache: [String: DTB.FileBrowserMockNode] = [:]

        override func viewDidLoad() {
            super.viewDidLoad()

            loadViews(in: view)

            /// 路径 = 本页自己的栈；内容 = provider（两者各是一个槽，各答自己那份）
            browser.pathDataSource = self
            browser.nodeDataSource = provider
            browser.delegate = self

            /// 内容落地（含缓存命中）后刷新「请求次数」——异步回调不经过本页，所以用这个钩子
            provider.onLoad = { [weak self] in
                self?.refreshInfo()
            }

            let root = provider.root
            nodeCache[root.nodeID] = root
            reload()
        }

        // MARK: - DTB.FileBrowserPathDataSource

        func fileBrowserPathNumbers(_ browser: DTB.FileBrowserView) -> Int {
            return stack.ids.count
        }

        /// 路径项就用我们自己的 model —— 框架只读 `nodeName`；身份在后面 `nodesOf` 里靠 `as?` 收窄拿回来
        func fileBrowser(_ browser: DTB.FileBrowserView, pathItemFor index: Int) -> any DTB.PathNode {
            return nodeCache[stack.ids[index]] ?? provider.root
        }

        // MARK: - DTB.FileBrowserDelegate

        /// 点了面包屑祖先（框架只报第几项）：回退到该层再重画
        func fileBrowser(_ browser: DTB.FileBrowserView, didSelectPathAt index: Int) {
            stack.trim(toDepth: index + 1)
            reload()
        }

        /// 「这行能不能进」：协议里没有 `isLocked`，业务规则就在这一句里（框架只给行号）
        func fileBrowser(_ browser: DTB.FileBrowserView, canSelectNodeAt index: Int) -> Bool {
            guard let node = node(at: index) else { return false }

            guard provider.lockedIDs.contains(node.nodeID) == false else {
                selectLabel.text = "canSelectNodeAt → false（拦住「\(node.nodeName ?? "")」）"
                return false
            }
            return true
        }

        /// 点了一行：文件夹往下走一层，文件上报
        func fileBrowser(_ browser: DTB.FileBrowserView, didSelectNodeAt index: Int) {
            guard let node = node(at: index) else { return }

            switch node.nodeKind {
            case .folder:
                nodeCache[node.nodeID] = node
                stack.push(node.nodeID)
                reload()

            case .file:
                /// 预览 / 下载 / 埋点的落点
                selectLabel.text = "didSelectNodeAt → \(node.nodeName ?? "")"
            }
        }

        // MARK: - 路径（这一层才是框架之外的业务）

        /// **业务唯一的写入口**：改自己的路径栈，然后让浏览器重画 + 重取内容
        private func reload() {
            /// 过期保护是业务的事（框架不认请求序号）：先认下「当前层」，迟到的回调由数据源自己丢
            provider.currentID = stack.topID

            browser.reloadData()
            refreshInfo()
        }

        /// 「第几行」→ 自己的节点：框架只报下标，这份映射是业务的事（数据源里那份账）
        private func node(at index: Int) -> DTB.FileBrowserMockNode? {
            let level = provider.level(stack.topID)
            guard level.indices.contains(index) else { return nil }
            return level[index] as? DTB.FileBrowserMockNode
        }

        /// 重新加载当前层：丢掉数据源缓存再要一次（演示「业务改了自己的数据之后重新取」）
        @objc private func reloadAction() {
            provider.invalidateCache()
            reload()
        }

        // MARK: - View

        private func loadViews(in box: UIView) {
            box.addSubview(controlRow)
            box.addSubview(browser)
            box.addSubview(selectLabel)

            controlRow.snp.makeConstraints { make in
                make.top.left.right.equalTo(box.safeAreaLayoutGuide)
                make.height.equalTo(64.0)
            }
            selectLabel.snp.makeConstraints { make in
                make.left.right.equalTo(box.safeAreaLayoutGuide).inset(16.0)
                make.bottom.equalTo(box.safeAreaLayoutGuide).offset(-16.0)
            }
            browser.snp.makeConstraints { make in
                make.top.equalTo(controlRow.snp.bottom)
                make.left.right.equalToSuperview()
                make.bottom.equalTo(selectLabel.snp.top).offset(-8.0)
            }

            controlRow.addSubview(controlLabel)
            controlRow.addSubview(reloadButton)
            controlRow.addSubview(requestLabel)

            controlLabel.snp.makeConstraints { make in
                make.top.left.equalToSuperview().offset(16.0)
            }
            reloadButton.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16.0)
                make.top.equalTo(controlLabel.snp.bottom).offset(6.0)
            }
            requestLabel.snp.makeConstraints { make in
                make.left.equalTo(reloadButton.snp.right).offset(12.0)
                make.right.lessThanOrEqualToSuperview().offset(-16.0)
                make.centerY.equalTo(reloadButton)
            }
        }

        private func refreshInfo() {
            let text = stack.ids.map({ id in
                "\(shortName(id))×\(provider.requestCount[id] ?? 0)"
            }).joined(separator: "  ")
            requestLabel.text = "数据源请求次数：\(text)"
        }

        private func shortName(_ id: String) -> String {
            let name = id.components(separatedBy: "/").last ?? id
            return name.isEmpty ? "root" : name
        }

        // MARK: - 懒加载

        private lazy var browser = DTB.FileBrowserView()

        private lazy var controlRow: UIView = {
            let view = UIView()
            view.backgroundColor = DTB.SampleDepends.bg2Color()
            return view
        }()

        private lazy var controlLabel: UILabel = {
            let view = UILabel()
            view.font = UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .regular)
            view.textColor = DTB.SampleDepends.text3Color()
            view.text = "点文件夹进入（首次会 loading）/ 点面包屑回退（走缓存，不再请求）"
            return view
        }()

        private lazy var requestLabel: UILabel = {
            let view = UILabel()
            view.font = UIFont.monospacedDigitSystemFont(ofSize: 11.0, weight: .regular)
            view.textColor = DTB.SampleDepends.text3Color()
            view.textAlignment = .right
            return view
        }()

        private lazy var reloadButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("重新加载", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
            button.setTitleColor(DTB.SampleDepends.textColor(), for: .normal)
            button.layer.cornerRadius = 6.0
            button.layer.borderWidth = 1.0
            button.layer.borderColor = DTB.SampleDepends.borderColor().cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
            button.addTarget(self, action: #selector(reloadAction), for: .touchUpInside)
            return button
        }()

        private lazy var selectLabel: UILabel = {
            let view = UILabel()
            view.font = UIFont.systemFont(ofSize: 12.0)
            view.textColor = DTB.SampleDepends.text2Color()
            view.text = "didSelectNodeAt → （点个文件试试）"
            return view
        }()
    }
}
