//
//  SGPathBarViewController.swift
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

    /// PathBar 展示页（Sample 画廊页）。
    ///
    /// 路径条是「路径有多长、滚到哪儿」的组件，静态截图看不出问题，所以这里把路径当数据来拨：
    /// 每次点击后盯着看三件事 —— ① 加一层会不会自动滚到末尾；② **任何一次重画都对齐到当前层（最右）**，
    /// 因为「上游重排」本身就意味着数据刷新过；③ 超长名按视觉宽度中点截断（不是按字符数砍）。
    ///
    /// - Note: 路径条自己**不存路径**（就是 ``SegmentHeaderView`` 的简化版）：本页实现
    ///   ``PathBarViewDataSource``，它每次重画都来问「有几项 / 第 i 项是什么」。
    ///
    /// 页面底部还放了一条「装得下」的短路径：两端渐隐落在首尾留白上，看起来就等于没有渐隐 ——
    /// 这就是本实现**不需要判断有没有溢出、也不需要按滚动位置算遮罩**的原因。
    final class SGPathBarViewController: DTB.BaseViewController, DTB.PathBarViewDataSource {

        override func viewDidLoad() {
            super.viewDidLoad()

            loadViews(in: view)
            reload()
        }

        // MARK: - Data

        /// 当前路径（根在最前）
        private var nodes: [DTB.FileBrowserMockNode] = [
            .folder("root://", "全部文件"),
            .folder("a", "2026 学年"),
            .folder("b", "第一学期"),
            .folder("c", "第一章：集合与函数"),
            .folder("d", "课后练习（含答案解析与错题整理）"),
            .folder("e", "第一小节")
        ]

        private var generated: Int = 1

        // MARK: - Action

        /// 加一层（应自动滚到末尾）
        @objc private func pushAction() {
            generated += 1
            let isLong: Bool = (generated % 3 == 0)
            let name: String = isLong
                ? "第 \(generated) 层：这是一个特别长的名字用来验证中点截断"
                : "第 \(generated) 层"
            nodes.append(.folder("mock://\(generated)", name))
            reload()
        }

        /// 回退一层（照样对齐到新的当前层）
        @objc private func popAction() {
            guard nodes.count > 1 else { return }
            nodes.removeLast()
            reload()
        }

        /// 回退到第 2 层（点面包屑祖先的等价操作）
        @objc private func trimAction() {
            nodes = Array(nodes.prefix(2))
            reload()
        }

        /// 换成一条长路径
        @objc private func longAction() {
            nodes = [
                .folder("root://", "全部文件"),
                .folder("a", "2026 学年"),
                .folder("b", "第一学期"),
                .folder("c", "第一章：集合与函数"),
                .folder("d", "课后练习（含答案解析与错题整理）"),
                .folder("e", "第一小节")
            ]
            reload()
        }

        /// 回到只有根（内容不溢出：两端渐隐该看不见）
        @objc private func resetAction() {
            nodes = [.folder("root://", "全部文件")]
            reload()
        }

        private func reload() {
            /// 路径条自己会来问（有几项 / 第 i 项是什么）—— 我们只管把数据备好再喊它重画
            pathBar.reloadData()
            infoLabel.text = "深度 \(nodes.count)　当前层：\(nodes.last?.nodeName ?? "")"
        }

        // MARK: - DTB.PathBarViewDataSource

        func pathBarItemNumbers(_ bar: DTB.PathBarView) -> Int {
            return nodes.count
        }

        func pathBar(_ bar: DTB.PathBarView, itemFor index: Int) -> any DTB.PathNode {
            return nodes[index]
        }

        // MARK: - View

        private func loadViews(in box: UIView) {
            box.addSubview(scrollView)
            scrollView.addSubview(contentStack)

            scrollView.snp.makeConstraints { make in
                make.edges.equalTo(box.safeAreaLayoutGuide)
            }
            contentStack.snp.makeConstraints { make in
                make.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 0.0, left: 0.0, bottom: 16.0, right: 0.0))
                make.width.equalTo(scrollView.snp.width)
            }

            contentStack.addArrangedSubview(makeHeader("PathBar：路径条。每次重画都会对齐到当前层（最右），装得下则原位不动", isTop: true))

            contentStack.addArrangedSubview(pathBar)
            contentStack.addArrangedSubview(infoLabel)

            contentStack.addArrangedSubview(makeHeader("操作"))
            contentStack.addArrangedSubview(makeButtonRows())

            contentStack.addArrangedSubview(makeHeader("两端渐隐怎么工作"))
            contentStack.addArrangedSubview(makeHeader("固定遮罩 + 首尾 16pt 留白：滚到任一端时首/末项恰好落在渐隐之外（不会被压暗），滚到中间则淡的是内容。装不下 → 淡内容；装得下 → 淡的是留白，等于没有。"))

            contentStack.addArrangedSubview(makeHeader("对照：一条装得下的短路径"))
            contentStack.addArrangedSubview(shortPathBar)
            contentStack.addArrangedSubview(makeHeader("（上方这条没有可滚内容，所以两端看不见渐隐）", isTop: false))
        }

        private func makeButtonRows() -> UIView {
            let actions: [(String, Selector)] = [
                ("加一层", #selector(pushAction)),
                ("回退一层", #selector(popAction)),
                ("回退到第 2 层", #selector(trimAction)),
                ("换长路径", #selector(longAction)),
                ("只留根", #selector(resetAction))
            ]

            let box = UIStackView()
            box.axis = .vertical
            box.spacing = 8.0

            var row: UIStackView?
            for (index, action) in actions.enumerated() {
                if index % 2 == 0 {
                    row = UIStackView()
                    row?.axis = .horizontal
                    row?.distribution = .fillEqually
                    row?.spacing = 8.0
                    box.addArrangedSubview(row!)
                }
                row?.addArrangedSubview(makeButton(action.0, action: action.1))
            }
            return box
        }

        private func makeButton(_ title: String, action: Selector) -> UIButton {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
            button.setTitleColor(DTB.SampleDepends.textColor(), for: .normal)
            button.layer.cornerRadius = 8.0
            button.layer.borderWidth = 1.0
            button.layer.borderColor = DTB.SampleDepends.borderColor().cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 6.0, left: 8.0, bottom: 6.0, right: 8.0)
            button.addTarget(self, action: action, for: .touchUpInside)
            return button
        }

        /// 分组标题：整宽 + 内部 16pt 留白
        private func makeHeader(_ text: String, isTop: Bool = false) -> UIView {
            let box = UIView()

            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: isTop ? 15.0 : 13.0, weight: .regular)
            label.textColor = isTop ? DTB.SampleDepends.textColor() : DTB.SampleDepends.text3Color()
            label.numberOfLines = 0

            box.addSubview(label)
            label.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(
                    UIEdgeInsets(top: isTop ? 16.0 : 24.0, left: 16.0, bottom: 8.0, right: 16.0)
                )
            }
            return box
        }

        // MARK: - 懒加载

        private lazy var scrollView: UIScrollView = {
            let view = UIScrollView()
            view.alwaysBounceVertical = true
            view.showsVerticalScrollIndicator = false
            return view
        }()

        private lazy var contentStack: UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            view.alignment = .fill
            view.spacing = 0.0
            return view
        }()

        private lazy var pathBar: DTB.PathBarView = {
            let view = DTB.PathBarView()
            view.dataSource = self
            return view
        }()

        /// 对照用的短路径：路径条是「问」的形状，所以写死一条路径也得有个数据源对象
        private lazy var shortSource = ShortPathSource([
            .folder("root://", "全部文件"),
            .folder("f://homework", "作业")
        ])

        private lazy var shortPathBar: DTB.PathBarView = {
            let view = DTB.PathBarView()
            view.dataSource = shortSource
            view.reloadData()
            return view
        }()

        private lazy var infoLabel: UILabel = {
            let view = UILabel()
            view.font = UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .regular)
            view.textColor = DTB.SampleDepends.text3Color()
            view.numberOfLines = 0
            return view
        }()
    }

    /// 一条写死的路径（画廊「装得下的短路径」那条对照用）
    private final class ShortPathSource: DTB.PathBarViewDataSource {

        private let nodes: [DTB.FileBrowserMockNode]

        init(_ nodes: [DTB.FileBrowserMockNode]) {
            self.nodes = nodes
        }

        func pathBarItemNumbers(_ bar: DTB.PathBarView) -> Int {
            return nodes.count
        }

        func pathBar(_ bar: DTB.PathBarView, itemFor index: Int) -> any DTB.PathNode {
            return nodes[index]
        }
    }
}
