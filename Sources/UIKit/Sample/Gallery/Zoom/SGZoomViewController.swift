//
//  SGZoomViewController.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/16
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {

    /// 缩放 × 复用 对比页：**同一个可复用网格**，两套缩放机制各来一份，并各自展示 `reconcileVisible` 的执行开销。
    ///
    /// - **transform**：整块位图拉伸 —— cell 自身 frame 不动、不重排，文字模糊、行数不变。
    /// - **frame**：逐格摆到 `base × scale` —— cell 变大、label 重新折行，文字变多、字号不变。
    ///
    /// 两边的 `frameForItemAt` 都只在**缓存失效**时被全量调用一次；滑动与缩放期间只做「缓存 frame ∩ 视口」的纯数学求交，
    /// 且两套机制共用同一套可见集判断（视口 ÷ scale 换算回基准坐标系），所以两个 `reconcile` 开销**可直接对比**。
    final class SGZoomViewController: DTB.BaseViewController {

        private static let columnCount = 40
        private static let rowCount = 200
        private static let cellSize = CGSize(width: 120.0, height: 80.0)

        private lazy var transformArea = makeZoomArea(mechanism: .transform)
        private lazy var frameArea = makeZoomArea(mechanism: .frame)

        override func viewDidLoad() {
            super.viewDidLoad()

            loadViews(in: view)
            buildSections()
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            refreshInfo()
        }

        @objc private func onResetPerf() {
            transformArea.resetPerf()
            frameArea.resetPerf()
            refreshInfo()
        }

        // MARK: - 两个网格

        private func makeZoomArea(mechanism: DTB.ZoomMechanism) -> DTB.ReusableScrollView {
            let sv = DTB.ReusableScrollView()
            sv.update(config: DTB.ZoomConfig(mechanism: mechanism))
            sv.dataSource = self
            sv.delegate = self
            sv.backgroundColor = DTB.SampleDepends.bgColor()
            sv.layer.borderWidth = 0.5
            sv.layer.borderColor = DTB.SampleDepends.borderColor().cgColor
            return sv
        }

        private func buildSections() {
            contentStack.addArrangedSubview(makeTopLabel("同一份可复用网格（\(Self.rowCount)×\(Self.columnCount) = \(Self.rowCount * Self.columnCount) 格）各挂一套机制。捏合缩放、拖动滚动，看下方两行开销。"))

            contentStack.addArrangedSubview(makeTitle("1. transform 机制：整块位图拉伸（cell 不重排、文字模糊、行数不变）"))
            contentStack.addArrangedSubview(transformArea)
            transformArea.snp.makeConstraints { make in make.height.equalTo(240) }
            contentStack.addArrangedSubview(transformInfoLabel)

            contentStack.addArrangedSubview(makeTitle("2. frame 机制：逐格重排到 base × scale（cell 变大、文字重新折行、行数变多）"))
            contentStack.addArrangedSubview(frameArea)
            frameArea.snp.makeConstraints { make in make.height.equalTo(240) }
            contentStack.addArrangedSubview(frameInfoLabel)

            contentStack.addArrangedSubview(resetButton)
            contentStack.addArrangedSubview(footLabel)
        }

        // MARK: - 信息展示

        private func refreshInfo() {
            transformInfoLabel.text = infoText(of: transformArea, name: "transform")
            frameInfoLabel.text = infoText(of: frameArea, name: "frame")
            footLabel.text = "cells created = \(DTB.ZoomDemoCell.createdCount)（两个网格共用静态计数）"
        }

        private func infoText(of scrollView: DTB.ReusableScrollView, name: String) -> String {
            let ms: (TimeInterval) -> String = { String(format: "%.2f", $0 * 1000) }
            return """
            \(name)  scale \(String(format: "%.2f", scrollView.scale))  cached \(scrollView.cachedFrameCount)  visible \(scrollView.visibleCellCount)
            reconcile  last \(ms(scrollView.lastReconcileCost))ms  avg \(ms(scrollView.averageReconcileCost))ms  ×\(scrollView.reconcileCount)
            """
        }

        private func makeInfoLabel() -> UILabel {
            let lb = UILabel()
            lb.font = UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.text3Color()
            lb.numberOfLines = 0
            return lb
        }

        private func makeTitle(_ text: String) -> UILabel {
            let lb = UILabel()
            lb.text = text
            lb.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.text3Color()
            lb.numberOfLines = 0
            return lb
        }

        private func makeTopLabel(_ text: String) -> UILabel {
            let lb = UILabel()
            lb.text = text
            lb.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.textColor()
            lb.numberOfLines = 0
            return lb
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
        }

        private lazy var transformInfoLabel = makeInfoLabel()
        private lazy var frameInfoLabel = makeInfoLabel()

        private lazy var footLabel: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.text4Color()
            lb.numberOfLines = 0
            return lb
        }()

        private lazy var resetButton: UIButton = {
            let bt = UIButton(type: .system)
            bt.setTitle("重置统计（两套方案各测一轮前点一次，便于对比）", for: .normal)
            bt.setTitleColor(DTB.SampleDepends.text3Color(), for: .normal)
            bt.titleLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            bt.contentHorizontalAlignment = .left
            bt.addTarget(self, action: #selector(onResetPerf), for: .touchUpInside)
            return bt
        }()

        private lazy var scrollView: UIScrollView = {
            let sv = UIScrollView()
            sv.alwaysBounceVertical = true
            sv.showsVerticalScrollIndicator = false
            return sv
        }()

        private lazy var contentStack: UIStackView = {
            let s = UIStackView()
            s.axis = .vertical
            s.alignment = .fill
            s.distribution = .fill
            s.spacing = 12.0
            return s
        }()
    }
}

// MARK: - 外层只观察 scroll（刷新诊断 label），不碰重用

extension DTB.SGZoomViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshInfo()
    }
}

// MARK: - 数据源：index 身份 + 基准 frame 由业务算（两个网格共用同一份）

extension DTB.SGZoomViewController: DTB.ReusableScrollViewDataSource {

    func numberOfItems(in scrollView: DTB.ReusableScrollView) -> Int {
        return Self.rowCount * Self.columnCount
    }

    func reusableScrollView(_ scrollView: DTB.ReusableScrollView, frameForItemAt index: Int) -> CGRect {
        let column = index % Self.columnCount
        let row = index / Self.columnCount
        return CGRect(
            x: CGFloat(column) * Self.cellSize.width,
            y: CGFloat(row) * Self.cellSize.height,
            width: Self.cellSize.width,
            height: Self.cellSize.height
        )
    }

    func reusableScrollView(_ scrollView: DTB.ReusableScrollView, cellForItemAt index: Int) -> UIView? {
        let cell = scrollView.dequeueReusableCell(as: DTB.ZoomDemoCell.self) ?? DTB.ZoomDemoCell(frame: .zero)
        cell.config(index: index)
        return cell
    }
}
