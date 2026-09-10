//
//  SGColorViewController.swift
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

    /// 叶子 item VC：渲染主题色板。
    final class SGColorViewController: DTB.BaseViewController {

        override func viewDidLoad() {
            super.viewDidLoad()

            loadViews(in: view)
        }

        private func loadViews(in box: UIView) {
            box.addSubview(stack)
            stack.snp.makeConstraints { make in make.edges.equalToSuperview().inset(16) }
        }

        private lazy var stack = UIStackView(arrangedSubviews: [
            swatch("dtb.theme"),
            swatch("dtb.danger"),
            swatch("dtb.warning"),
            swatch("dtb.link"),
        ]).dtb.axis(.horizontal).distribution(.fillEqually).spacing(12).value

        private func swatch(_ key: String) -> UIView {
            let v = UIView()
            v.backgroundColor = .dtb.create(key)
            v.layer.cornerRadius = 8
            return v
        }
    }
}
