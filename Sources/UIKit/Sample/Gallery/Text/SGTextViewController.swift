//
//  SGTextViewController.swift
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

    /// 叶子 item VC：展示 `text_style.json` 各 key 的视觉。
    ///
    /// TODO: 仿照 ``DTB.SGColorViewController``，读取 `DTB.DefaultStylesProvider` 解析后的
    /// text mapper，用 tableview + cell 展示 dtb.h1..h6 / dtb.b1..b6 / dtb.placeholder / dtb.link。
    final class SGTextViewController: DTB.BaseViewController {

        override func viewDidLoad() {
            super.viewDidLoad()

            loadViews(in: view)
        }

        private func loadViews(in box: UIView) {
            box.addSubview(placeholderLabel)
            placeholderLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }

        private lazy var placeholderLabel: UILabel = {
            let lb = UILabel()
            lb.text = "text_style（待实现）"
            lb.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            lb.textColor = DTB.SampleDepends.text2Color()
            return lb
        }()
    }
}
