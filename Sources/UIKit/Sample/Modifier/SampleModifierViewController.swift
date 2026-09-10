//
//  SampleModifierViewController.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/10
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {

    /// 上层操作区：概念占位，暂只放一个占位页。
    ///
    /// 未来承载「实时修改」的控件；与下层展示区互不联动。
    final class SampleModifierViewController: DTB.BaseViewController, SegmentCandy {

        var movedIndexes: Set<Int> = []

        lazy var segment: DTB.SegmentView = {
            let v = DTB.SegmentView()
            v.dataSource = self
            v.delegate = self
            return v
        }()

        private(set) lazy var pages: [DTB.SamplePage] = [
            .init(vc: DTB.SMPlaceholderViewController(), title: "操作区"),
        ]

        var childPages: [UIViewController] { pages.map { $0.vc } }

        override func viewDidLoad() {
            super.viewDidLoad()

            view.addSubview(segment)
            segment.snp.makeConstraints { make in make.edges.equalToSuperview() }

            reloadSegmentData()
        }

        func segment(_ view: DTB.SegmentView, itemFor index: Int) -> DTB.SegmentItem {
            let item = DTB.DefaultSegmentItem()
            item.text = pages[index].title
            return item
        }
    }
}
