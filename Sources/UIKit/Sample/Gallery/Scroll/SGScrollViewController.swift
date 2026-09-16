//
//  SGScrollViewController.swift
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

    /// ReusableScrollView 展示页（Sample 画廊页）。
    ///
    /// 用一个「统一尺寸大网格」验证第一层的自驱：身份是 index、frame 由 `frameForItemAt` 算（第二层布局），
    /// 容器自己 KVO offset/contentSize + layoutSubviews 接管离屏回收 / 入屏渲染，外层（本 VC）用普通 `delegate` 观察 scroll 更新 label。
    final class SGScrollViewController: DTB.BaseViewController {

        private let cellWidth: CGFloat = 90.0
        private let cellHeight: CGFloat = 60.0
        private let columnCount = 60
        private let rowCount = 300

        override func viewDidLoad() {
            super.viewDidLoad()

            loadViews(in: view)
            scrollView.dataSource = self
            scrollView.delegate = self
            scrollView.contentSize = CGSize(
                width: CGFloat(columnCount) * cellWidth,
                height: CGFloat(rowCount) * cellHeight
            )
        }

        private func refreshInfo() {
            infoLabel.text = "created \(DTB.ScrollDemoCell.createdCount) / visible \(scrollView.visibleCellCount) / grid \(rowCount)×\(columnCount)"
        }

        // MARK: - View

        private func loadViews(in box: UIView) {
            box.addSubview(infoLabel)
            box.addSubview(scrollView)

            infoLabel.snp.makeConstraints { make in
                make.top.equalTo(box.safeAreaLayoutGuide).offset(8)
                make.left.right.equalTo(box.safeAreaLayoutGuide).inset(16)
            }
            scrollView.snp.makeConstraints { make in
                make.top.equalTo(infoLabel.snp.bottom).offset(8)
                make.left.right.bottom.equalTo(box.safeAreaLayoutGuide)
            }
        }

        private lazy var infoLabel: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.monospacedDigitSystemFont(ofSize: 13.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.text3Color()
            lb.numberOfLines = 1
            return lb
        }()

        private lazy var scrollView: DTB.ReusableScrollView = {
            let sv = DTB.ReusableScrollView()
            sv.bounces = false
            sv.backgroundColor = DTB.SampleDepends.bgColor()
            sv.showsVerticalScrollIndicator = true
            sv.showsHorizontalScrollIndicator = true
            return sv
        }()
    }
}

// MARK: - 外层只观察 scroll（更新诊断 label），不碰重用

extension DTB.SGScrollViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshInfo()
    }
}

// MARK: - 数据源：index 身份 + frame 由业务算

extension DTB.SGScrollViewController: DTB.ReusableScrollViewDataSource {

    func numberOfItems(in scrollView: DTB.ReusableScrollView) -> Int {
        return rowCount * columnCount
    }

    func reusableScrollView(_ scrollView: DTB.ReusableScrollView, frameForItemAt index: Int) -> CGRect {
        let column = index % columnCount
        let row = index / columnCount
        return CGRect(
            x: CGFloat(column) * cellWidth,
            y: CGFloat(row) * cellHeight,
            width: cellWidth,
            height: cellHeight
        )
    }

    func reusableScrollView(_ scrollView: DTB.ReusableScrollView, cellForItemAt index: Int) -> UIView? {
        let cell = scrollView.dequeueReusableCell(as: DTB.ScrollDemoCell.self) ?? DTB.ScrollDemoCell(frame: .zero)
        cell.config(row: index / columnCount, column: index % columnCount)
        return cell
    }
}
