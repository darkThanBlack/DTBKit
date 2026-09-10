//
//  SampleViewController.swift
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

    /// 示例画廊最外层：上下两个 segment VC 平级，各自独立。
    ///
    /// 导航栏只在最外层一个，segment VC 与叶子 item VC 都不设自己的 nav。
    final class SampleViewController: DTB.BaseViewController {

        override func viewDidLoad() {
            super.viewDidLoad()

            setupNavigatonBar(with: .init(title: .dtb.create("dtb.deep.labs")))
            loadViews(in: view)
        }

        private func loadViews(in box: UIView) {
            [modifierVC, galleryVC].forEach {
                addChild($0)
                box.addSubview($0.view)
                $0.didMove(toParent: self)
            }

            modifierVC.view.snp.makeConstraints { make in
                make.top.equalTo(customNavigationBar.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(44)
            }
            galleryVC.view.snp.makeConstraints { make in
                make.top.equalTo(modifierVC.view.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
        }

        private lazy var modifierVC = DTB.SampleModifierViewController()

        private lazy var galleryVC = DTB.SampleGalleryViewController()
    }
}
