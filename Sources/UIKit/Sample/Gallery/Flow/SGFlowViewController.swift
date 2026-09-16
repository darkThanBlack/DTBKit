//
//  SGFlowViewController.swift
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

    /// SelfSizingFlowView 展示页（Sample 画廊页）。
    ///
    /// 最外层 scrollview + stack 包裹：内容超长可滚，未来头部加说明 label 无需动约束。
    /// 三部分：
    /// - 横向 scrollview：`axis = .vertical`（竖排、超高换列、撑宽）；
    /// - 纵向 scrollview：`axis = .horizontal`（横排、超宽换行、撑高）；
    /// - tableview：cell 自动算高，预期错误。
    final class SGFlowViewController: DTB.BaseViewController {

        private let textGroups: [[(String, CGFloat)]] = [
            (
                [("0", 13), ("1", 13), ("2", 13), ("3", 13), ("4", 13), ("5", 13), ("6", 13), ("7", 13), ("8", 13), ("9", 13), ("10", 13)]
            ),
            (
                [("文字大小从小变大", 11), ("文字大小从小变大", 13), ("文字大小从小变大", 15), ("文字大小从小变大", 17), ("文字大小从小变大", 19), ("文字大小从小变大", 23)]
            ),
            (
                [("文字长度从长变短", 15), ("文字长度从长变", 15), ("文字长度从长", 15), ("文字长度从", 15), ("文字长度", 15), ("文字长", 15), ("文字", 15), ("文", 15)]
            )
        ]

        /// item 工厂：每个 consumer（flow / cell）各自 build 一份，避免复用同一 UIView 实例被 addSubview 移走。
        private typealias ItemBuilder = () -> UIView

        /// 展示用 item 工厂组：前 3 组为文本 tag，第 4 组为 dtb.label / dtb.button 控件。
        private lazy var groups: [[ItemBuilder]] = {
            var result = textGroups.map { group in
                group.map { item -> ItemBuilder in
                    {
                        let cell = DTB.FlowDemoItem(frame: .zero)
                        cell.config(title: item.0, fontSize: item.1)
                        return cell
                    }
                }
            }
            result.append(makeControlItems())
            return result
        }()

        override func viewDidLoad() {
            super.viewDidLoad()

            loadViews(in: view)

            reloadData()
        }

        // MARK: - Item

        private func makeControlItems() -> [ItemBuilder] {
            return [
                { Self.makeLabelItem("dtb.label") },
                { Self.makeLabelItem("dtb.label 同时支持 grid 和 flow 布局") },
                { Self.makeButtonItem("dtb.button") },
                { Self.makeButtonItem("dtb.button 同时支持 grid 和 flow 布局") }
            ]
        }

        private static func makeLabelItem(_ text: String) -> DTB.Label {
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

        private static func makeButtonItem(_ title: String) -> DTB.Button {
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

            contentStack.addArrangedSubview(makeTopIntroLabel("流式布局：item 自报尺寸，沿主轴排列、超界换排；自身尺寸 = 内容尺寸"))
            contentStack.addArrangedSubview(makeIntroLabel("axis = .vertical（竖排、超高换列、撑宽）"))
            contentStack.addArrangedSubview(hScrollView)
            contentStack.addArrangedSubview(makeIntroLabel("axis = .horizontal（横排、超宽换行、撑高）"))
            contentStack.addArrangedSubview(vScrollView)
            contentStack.addArrangedSubview(makeIntroLabel("tableview cell 自动算高（预期错误）"))
            contentStack.addArrangedSubview(tableView)

            contentStack.addArrangedSubview(makeIntroLabel("dataSource 协议模式（dataSource != nil，item 构造下沉到数据源，缓存复用实例）"))
            contentStack.addArrangedSubview(dsFlowView)

            /// scrollview / tableview 无固有高度，stack 内需显式给高；数值可自行调整
            hScrollView.snp.makeConstraints { make in
                make.height.equalTo(120.0)
            }
            vScrollView.snp.makeConstraints { make in
                make.height.equalTo(320.0)
            }
            tableView.snp.makeConstraints { make in
                make.height.equalTo(320.0)
            }
            /// 撑高依赖宽，需钉死宽
            dsFlowView.snp.makeConstraints { make in
                make.width.equalToSuperview()
            }

            hScrollView.addSubview(hStack)
            hStack.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalToSuperview()
            }

            vScrollView.addSubview(vStack)
            vStack.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalToSuperview()
            }
        }

        private func reloadData() {
            /// 横向 scrollview：axis = .vertical
            hStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
            groups.enumerated().forEach { idx, builders in
                let flow = DTB.SelfSizingFlowView()
                flow.update(
                    config: SelfSizingFlowConfig(
                        axis: .vertical,
                        alignment: {
                            if idx == 0 { return .leading }
                            if idx == 1 { return .trailing }
                            return .center
                        }(),
                        lineSpacing: 8.0,
                        itemSpacing: 8.0
                    )
                )
                flow.update(items: builders.map { $0() })
                hStack.addArrangedSubview(flow)
                /// 重要: 必须给定高度
                flow.snp.makeConstraints { make in
                    make.height.equalToSuperview()
                }
            }

            /// 纵向 scrollview：axis = .horizontal（默认）
            vStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
            groups.enumerated().forEach { idx, builders in
                let flow = DTB.SelfSizingFlowView()
                flow.update(config: SelfSizingFlowConfig(
                    axis: .horizontal,
                    alignment: {
                        if idx == 0 { return .leading }
                        if idx == 1 { return .trailing }
                        return .center
                    }(),
                    lineSpacing: 8.0,
                    itemSpacing: 8.0
                ))
                flow.update(items: builders.map { $0() })
                vStack.addArrangedSubview(flow)
                /// 重要: 必须给定宽度
                flow.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                }
            }

            tableView.reloadData()
            dsFlowView.reloadData()
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

        private lazy var hScrollView: UIScrollView = {
            let sv = UIScrollView()
            sv.alwaysBounceHorizontal = true
            sv.showsHorizontalScrollIndicator = false
            return sv
        }()

        private lazy var hStack: UIStackView = {
            let stacks = UIStackView()
            stacks.axis = .horizontal
            stacks.alignment = .center
            stacks.distribution = .fill
            stacks.spacing = 0.0
            return stacks
        }()

        private lazy var vScrollView: UIScrollView = {
            let sv = UIScrollView()
            sv.alwaysBounceVertical = true
            sv.showsVerticalScrollIndicator = false
            return sv
        }()

        private lazy var vStack: UIStackView = {
            let stacks = UIStackView()
            stacks.axis = .vertical
            stacks.alignment = .center
            stacks.distribution = .fill
            stacks.spacing = 0.0
            return stacks
        }()

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

        /// 失败的示例: 如果直接用约束放在 cell 上，第一次展示时高度会恒为 0
        ///
        /// 这是系统自动算高机制的时机问题，不应由 flowview 内部来解决
        private lazy var tableView: UITableView = {
            let tv = UITableView.dtb.plain(self, cells: [DTB.FlowDemoCell.self])
            tv.backgroundColor = .clear
            tv.isScrollEnabled = false
            return tv
        }()

        /// dataSource 协议模式：`dataSource != nil`，item 构造下沉到数据源。
        private lazy var dsFlowView: DTB.SelfSizingFlowView = {
            let flow = DTB.SelfSizingFlowView()
            flow.update(config: DTB.SelfSizingFlowConfig(
                axis: .horizontal,
                alignment: .center,
                lineSpacing: 8.0,
                itemSpacing: 8.0
            ))
            flow.dataSource = flowDataSource
            return flow
        }()

        /// 强持有数据源（`dataSource` 为 weak，需外部保活）。
        private lazy var flowDataSource: FlowDemoDataSource = {
            FlowDemoDataSource(builders: groups[0])
        }()

        /// 演示 `SelfSizingFlowDataSource`：item 构造下沉，「同 index 同实例」由 `itemAt` 内缓存保证。
        private final class FlowDemoDataSource: SelfSizingFlowDataSource {

            private let builders: [() -> UIView]
            private var cache: [Int: UIView] = [:]

            init(builders: [() -> UIView]) {
                self.builders = builders
            }

            func numberOfItems(in flowView: SelfSizingFlowView) -> Int {
                return builders.count
            }

            func flowView(_ flowView: SelfSizingFlowView, itemAt index: Int) -> UIView {
                if let cached = cache[index] { return cached }
                let view = builders[index]()
                cache[index] = view
                return view
            }
        }
    }
}

extension DTB.SGFlowViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DTB.FlowDemoCell = tableView.dtb.dequeueReusableCellEnsured(indexPath)
        let config = DTB.SelfSizingFlowConfig(
            axis: .horizontal,
            alignment: {
                if indexPath.row == 0 { return .leading }
                if indexPath.row == 1 { return .trailing }
                return .center
            }(),
            lineSpacing: 8.0,
            itemSpacing: 8.0
        )
        cell.config(items: groups[indexPath.row].map { $0() }, flowConfig: config)
        return cell
    }
}
