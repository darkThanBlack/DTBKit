//
//  SelfSizingFlowViewController.swift
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
    
    /// SelfSizingFlowView 展示页。
    ///
    /// 三部分：
    /// - 横向 scrollview：`axis = .vertical`（竖排、超高换列、撑宽）；
    /// - 纵向 scrollview：`axis = .horizontal`（横排、超宽换行、撑高）；
    /// - tableview：cell 自动算高，预期错误。
    public final class SelfSizingFlowViewController: DTB.BaseViewController {
        
        private var groups: [[(String, CGFloat)]] = [
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
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            setupNavigatonBar(with: .init(title: .dtb.create("dtb.deep.flow")))
            loadViews(in: view)
            
            reloadData()
        }
        
        // MARK: - View
        
        private func loadViews(in box: UIView) {
            box.addSubview(hScrollView)
            box.addSubview(vScrollView)
            box.addSubview(tableView)
            
            hScrollView.snp.makeConstraints { make in
                make.top.equalTo(customNavigationBar.snp.bottom)
                make.left.right.equalTo(box.safeAreaLayoutGuide)
                make.height.equalTo(120.0)
            }
            vScrollView.snp.makeConstraints { make in
                make.top.equalTo(hScrollView.snp.bottom).offset(0)
                make.left.right.equalTo(box.safeAreaLayoutGuide)
            }
            tableView.snp.makeConstraints { make in
                make.top.equalTo(vScrollView.snp.bottom).offset(0)
                make.height.equalTo(vScrollView)
                make.left.right.bottom.equalTo(box.safeAreaLayoutGuide)
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
            groups.enumerated().forEach { idx, titles in
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
                flow.update(items: titles.map { item -> DTB.FlowCell1 in
                    let cell = DTB.FlowCell1(frame: .zero)
                    cell.config(title: item.0, fontSize: item.1)
                    return cell
                })
                hStack.addArrangedSubview(flow)
                /// 重要: 必须给定高度
                flow.snp.makeConstraints { make in
                    make.height.equalToSuperview()
                }
            }
            
            /// 纵向 scrollview：axis = .horizontal（默认）
            vStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
            groups.enumerated().forEach { idx, titles in
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
                flow.update(items: titles.map { item -> DTB.FlowCell1 in
                    let cell = DTB.FlowCell1(frame: .zero)
                    cell.config(title: item.0, fontSize: item.1)
                    return cell
                })
                vStack.addArrangedSubview(flow)
                /// 重要: 必须给定宽度
                flow.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                }
            }
            
            tableView.reloadData()
        }
        
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

extension DTB.SelfSizingFlowViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        cell.config(titles: groups[indexPath.row], flowConfig: config)
        return cell
    }
}
