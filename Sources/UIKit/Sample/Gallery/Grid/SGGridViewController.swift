//
//  SGGridViewController.swift
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

    /// SelfSizingGridView 展示页（Sample 画廊页）。
    ///
    /// 最外层 scrollview + stack 包裹；四部分：横向 / 竖向 / 固定 size / cell（自动算高，预期错误）。
    final class SGGridViewController: DTB.BaseViewController {

        override func viewDidLoad() {
            super.viewDidLoad()

            loadViews(in: view)
            buildGrids()
        }

        // MARK: - Item

        private func makeStatItems() -> [UIView] {
            let stats: [(String, String)] = [
                ("总收入", "¥1,234"), ("游客数", "3,456"), ("订单数", "789"), ("复购率", "45%")
            ]
            return stats.map { item -> UIView in
                let cell = DTB.GridDemoItem(frame: .zero)
                cell.config(title: item.0, detail: item.1)
                return cell
            }
        }

        private func makeControlItems() -> [UIView] {
            return [
                makeLabelItem("dtb.label"),
                makeLabelItem("dtb.label 同时支持 grid 和 flow 布局"),
                makeButtonItem("dtb.button"),
                makeButtonItem("dtb.button 同时支持 grid 和 flow 布局")
            ]
        }

        private func makeDemoItems() -> [UIView] {
            return makeStatItems() + makeControlItems()
        }

        private func makeLabelItem(_ text: String) -> DTB.Label {
            let label = DTB.Label(frame: .zero)
            label.setConfig(DTB.LabelStyle(
                backgroundColor: DTB.SampleDepends.bg3Color(),
                contentEdgeInsets: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12),
                textColor: DTB.SampleDepends.textColor(),
                font: UIFont.systemFont(ofSize: 13, weight: .regular),
                numberOfLines: 0,
                shape: DTB.ShapeStyle(corners: [.allCorners], radius: .fixed(10.0))
            ))
            label.text = text
            return label
        }

        private func makeButtonItem(_ title: String) -> DTB.Button {
            let button = DTB.Button(frame: .zero)
            button.setConfig(DTB.ButtonStyle(
                backgroundColor: DTB.SampleDepends.bg3Color(),
                contentEdgeInsets: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12),
                title: title,
                textColor: DTB.SampleDepends.textColor(),
                font: UIFont.systemFont(ofSize: 13, weight: .regular),
                shape: DTB.ShapeStyle(corners: [.allCorners], radius: .fixed(10.0))
            ), for: .normal)
            return button
        }

        private func makeGrid(config: DTB.SelfSizingGridConfig) -> DTB.SelfSizingGridView {
            let grid = DTB.SelfSizingGridView()
            grid.update(config: config)
            grid.update(items: makeDemoItems())
            return grid
        }

        // MARK: - Build

        private func buildGrids() {
            contentStack.addArrangedSubview(makeIntroLabel("横向：itemHeight 固定、均分宽、撑高"))
            contentStack.addArrangedSubview(makeGrid(config: .init(itemHeight: 44, itemsPerLine: 3, lineSpacing: 8, itemSpacing: 8)))

            contentStack.addArrangedSubview(makeIntroLabel("竖向：itemWidth 固定、均分高、撑宽"))
            let vGrid = makeGrid(config: .init(itemWidth: 100, itemsPerLine: 3, lineSpacing: 8, itemSpacing: 8))
            contentStack.addArrangedSubview(vGrid)
            /// 竖向撑宽、依赖高，需显式给高
            vGrid.snp.makeConstraints { make in
                make.height.equalTo(160.0)
            }

            contentStack.addArrangedSubview(makeIntroLabel("固定 size：双固定、换行、撑高"))
            contentStack.addArrangedSubview(makeGrid(config: .init(itemWidth: 100, itemHeight: 40, lineSpacing: 8, itemSpacing: 8)))

            contentStack.addArrangedSubview(makeIntroLabel("tableview cell 自动算高（预期错误）"))
            contentStack.addArrangedSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.height.equalTo(320.0)
            }

            contentStack.addArrangedSubview(makeIntroLabel("dataSource 协议模式（dataSource != nil，item 构造下沉到数据源，缓存复用实例）"))
            let dsGrid = DTB.SelfSizingGridView()
            dsGrid.update(config: .init(itemHeight: 44, itemsPerLine: 4, lineSpacing: 8, itemSpacing: 8))
            dsGrid.dataSource = gridDataSource
            dsGrid.reloadData()
            contentStack.addArrangedSubview(dsGrid)

            view.setNeedsLayout()
            view.invalidateIntrinsicContentSize()
        }

        // MARK: - View

        private func loadViews(in box: UIView) {
            box.addSubview(scrollView)
            scrollView.addSubview(contentStack)

            scrollView.snp.makeConstraints { make in
                make.edges.equalTo(box.safeAreaLayoutGuide)
            }
            contentStack.snp.makeConstraints { make in
                make.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
                make.width.equalTo(scrollView.snp.width).offset(-32)
            }

            contentStack.addArrangedSubview(makeTopIntroLabel("网格布局：item 尺寸决定模式（均分宽 / 均分高 / 换行），自身尺寸 = 内容尺寸"))
        }

        private func makeIntroLabel(_ text: String) -> UILabel {
            let lb = UILabel()
            lb.text = text
            lb.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.text3Color()
            lb.textAlignment = .left
            lb.numberOfLines = 0
            return lb
        }

        private func makeTopIntroLabel(_ text: String) -> UILabel {
            let lb = UILabel()
            lb.text = text
            lb.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.textColor()
            lb.textAlignment = .left
            lb.numberOfLines = 0
            return lb
        }

        private lazy var scrollView: UIScrollView = {
            let sv = UIScrollView()
            sv.alwaysBounceVertical = true
            sv.showsVerticalScrollIndicator = false
            return sv
        }()

        private lazy var contentStack: UIStackView = {
            let stacks = UIStackView()
            stacks.axis = .vertical
            stacks.alignment = .fill
            stacks.distribution = .fill
            stacks.spacing = 24.0
            return stacks
        }()

        /// 失败的示例: cell 自动算高首次为 0，触发一次离屏后才正常（同 Flow）
        private lazy var tableView: UITableView = {
            let tv = UITableView.dtb.plain(self, cells: [DTB.GridDemoCell.self])
            tv.backgroundColor = .clear
            return tv
        }()

        /// 强持有数据源（`dataSource` 为 weak，需外部保活）。
        private lazy var gridDataSource: GridDemoDataSource = GridDemoDataSource()

        /// 演示 `SelfSizingGridDataSource`：item 构造下沉，「同 index 同实例」由 `itemAt` 内缓存保证。
        private final class GridDemoDataSource: SelfSizingGridDataSource {

            private let stats: [(String, String)] = [
                ("总收入", "¥1,234"), ("游客数", "3,456"), ("订单数", "789"), ("复购率", "45%")
            ]
            private var cache: [Int: UIView] = [:]

            func numberOfItems(in gridView: SelfSizingGridView) -> Int {
                return stats.count
            }

            func gridView(_ gridView: SelfSizingGridView, itemAt index: Int) -> UIView {
                if let cached = cache[index] { return cached }
                let item = DTB.GridDemoItem(frame: .zero)
                item.config(title: stats[index].0, detail: stats[index].1)
                cache[index] = item
                return item
            }
        }
    }
}

extension DTB.SGGridViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// 多个数据源，触发滚动以观察自动算高
        return 8
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DTB.GridDemoCell = tableView.dtb.dequeueReusableCellEnsured(indexPath)
        cell.config(
            items: makeControlItems(),
            gridConfig: .init(itemWidth: 100, itemHeight: 40, lineSpacing: 8, itemSpacing: 8)
        )
        return cell
    }
}
