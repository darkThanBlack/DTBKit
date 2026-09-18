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
    /// 最外层 scrollview + stack 包裹。统一一个固定数据源（只存数据），VC 直接担任 `SelfSizingFlowViewDataSource`，
    /// `itemAt` 里按数据「类型」初始化不同 item 并分别赋值。
    ///
    /// 每种轴形式一个 flowview（`horizontalFlowView` / `verticalFlowView`），tableview 的每个 cell 复用同一 dataSource。
    final class SGFlowViewController: DTB.BaseViewController {

        // MARK: - 统一数据（只存数据，不存 view）

        /// item 类型：决定 `itemAt` 里初始化哪种 view。
        private enum DemoItem {
            case frame(title: String, fontSize: CGFloat)       // FlowDemoItem（frame 布局）
            case constraint(title: String, fontSize: CGFloat)  // FlowDemoConstraintItem（约束布局）
            case label(title: String)                          // DTB.Label
            case button(title: String)                         // DTB.Button
        }

        private lazy var data: [DemoItem] = {
            let a: [DemoItem] = [.frame(title: "示例1", fontSize: 13.0)]
            + [.frame(title: "item 内部是纯 frame 布局，通过 sizeThatFits 提供 self sizing", fontSize: 13.0)]
            + (0..<12).compactMap({ .frame(title: "\($0)", fontSize: 13.0) })
            
            let b: [DemoItem] = [.frame(title: "示例2", fontSize: 13.0)]
            + [.constraint(title: "item 内部是 autolayout 布局，通过约束提供 self sizing", fontSize: 13.0)]
            + (0..<12).compactMap({ .constraint(title: "\($0)", fontSize: 13.0) })
            
            let c: [DemoItem] = [.label(title: "示例3")]
            + [.label(title: "直接将 DTB.Label 作为 item，用来观察内部实现是否正确")]
            
            let d: [DemoItem] = [.button(title: "示例4")]
            + [.button(title: "直接将 DTB.Button 作为 item，用来观察内部实现是否正确")]
            
            let eText = """
                FIXME：长文字折行等情况，需要 item 自己处理
                因为 systemLayoutSizeFitting :
                - 容器在 update(items:)
                """
            let e: [DemoItem] = [.button(title: "示例5")]
            + [.frame(title: eText, fontSize: 13.0)]
            + [.constraint(title: eText, fontSize: 13.0)]
            + [.label(title: eText)]
            + [.button(title: eText)]

            return a + b + c + d + e
        }()

        override func viewDidLoad() {
            super.viewDidLoad()

            loadViews(in: view)

            horizontalFlowView.reloadData()
            verticalFlowView.reloadData()
            tableView.reloadData()
        }
        
        ///
        private lazy var horizontalFlowView: DTB.SelfSizingFlowView = {
            let flow = DTB.SelfSizingFlowView()
            flow.update(config: DTB.SelfSizingFlowConfig(
                axis: .horizontal,
                alignment: .center,
                lineSpacing: 8.0,
                itemSpacing: 8.0
            ))
            flow.dataSource = self
            return flow
        }()
        
        ///
        private lazy var verticalFlowView: DTB.SelfSizingFlowView = {
            let flow = DTB.SelfSizingFlowView()
            flow.update(config: DTB.SelfSizingFlowConfig(
                axis: .vertical,
                alignment: .center,
                lineSpacing: 8.0,
                itemSpacing: 8.0
            ))
            flow.dataSource = self
            return flow
        }()

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

            contentStack.addArrangedSubview(makeTopIntroLabel("流式布局：item 自报尺寸，沿主轴排列、超界换排；自身尺寸 = 内容尺寸（VC 直接担任统一 dataSource）"))
            contentStack.addArrangedSubview(makeIntroLabel("axis = .horizontal  主轴方向是水平的，从左到右排列"))
            contentStack.addArrangedSubview(horizontalFlowView)
            contentStack.addArrangedSubview(makeIntroLabel("axis = .vertical  主轴方向是垂直的，从上到下排列"))
            contentStack.addArrangedSubview(verticalFlowView)
            contentStack.addArrangedSubview(makeIntroLabel("tableview cell 自动算高（预期错误，cell 内 flowview 复用同一 dataSource）"))
            contentStack.addArrangedSubview(tableView)

            /// 撑宽依赖高，需钉死高
            verticalFlowView.snp.makeConstraints { make in
                make.height.equalTo(200.0)
            }
            /// tableview 无固有高度，stack 内需显式给高
            tableView.snp.makeConstraints { make in
                make.height.equalTo(240.0)
            }
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

        // MARK: - 懒加载

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

        /// 失败的示例: 如果直接用约束放在 cell 上，第一次展示时高度会恒为 0
        ///
        /// 这是系统自动算高机制的时机问题，不应由 flowview 内部来解决
        private lazy var tableView: UITableView = {
            let tv = UITableView.dtb.plain(self, cells: [DTB.FlowDemoCell.self])
            tv.backgroundColor = .clear
            tv.isScrollEnabled = false
            return tv
        }()
    }
}

// MARK: - 统一 dataSource（VC 直接担任）

extension DTB.SGFlowViewController: DTB.SelfSizingFlowViewDataSource {

    func numberOfItems(in flowView: DTB.SelfSizingFlowView) -> Int {
        data.count
    }

    func flowView(_ flowView: DTB.SelfSizingFlowView, itemAt index: Int) -> UIView {
        switch data[index] {
        case .frame(let title, let fontSize):
            let item = DTB.FlowDemoItem(frame: .zero)
            item.config(title: title, fontSize: fontSize)
            return item
        case .constraint(let title, let fontSize):
            let item = DTB.FlowDemoConstraintItem()
            item.config(title: title, fontSize: fontSize)
            return item
        case .label(let title):
            let label = DTB.Label()
            label.setConfig(DTB.LabelStyle(
                backgroundColor: DTB.SampleDepends.bg3Color(),
                contentEdgeInsets: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12),
                textColor: DTB.SampleDepends.textColor(),
                font: UIFont.systemFont(ofSize: 13, weight: .regular),
                numberOfLines: 0,
                shape: DTB.ShapeStyle(corners: [.allCorners], radius: .fixed(10.0))
            ))
            label.text = title
            return label
        case .button(let title):
            let button = DTB.Button(frame: .zero)
            button.setConfig(DTB.ButtonStyle(
                backgroundColor: DTB.SampleDepends.bg3Color(),
                contentEdgeInsets: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12),
                textColor: DTB.SampleDepends.textColor(),
                font: UIFont.systemFont(ofSize: 13, weight: .regular),
                shape: DTB.ShapeStyle(corners: [.allCorners], radius: .fixed(10.0))
            ), for: .normal)
            button.setTitle(title)
            return button
        }
    }
}

// MARK: - 表格

extension DTB.SGFlowViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DTB.FlowDemoCell = tableView.dtb.dequeueReusableCellEnsured(indexPath)
        cell.config(dataSource: self)
        return cell
    }
}
