//
//  SampleGalleryViewController.swift
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

    /// 下层展示区：一个 segment，每个 item 一个独立 item VC。
    final class SampleGalleryViewController: DTB.BaseViewController, SegmentCandy {

        // SegmentCandy：去重标记，保证 child 只 didMove 一次，维护逻辑在协议默认实现里
        var movedIndexes: Set<Int> = []

        lazy var segment: DTB.SegmentView = {
            let v = DTB.SegmentView()
            v.dataSource = self
            v.delegate = self
            return v
        }()

        /// 唯一要维护的清单：加一个页 = 加一行。
        private(set) lazy var pages: [DTB.SamplePage] = [
            .init(vc: DTB.SGButtonViewController(), title: "Button"),
            .init(vc: DTB.SGLabelViewController(), title: "Label"),
            .init(vc: DTB.SGColorViewController(), title: "Color"),
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
