//
//  SGButtonViewController.swift
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

    /// 叶子 item VC：渲染 Button 组件。
    final class SGButtonViewController: DTB.BaseViewController {

        override func viewDidLoad() {
            super.viewDidLoad()

            // loadViews(in: view)
        }

        private func loadViews(in box: UIView) {
            box.addSubview(stack)
            stack.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(16)
            }
        }

        private lazy var stack = UIStackView(arrangedSubviews: [
            makeButton("normal"),
            makeButton("highlighted"),
            makeButton("selected"),
            makeButton("disabled"),
        ]).dtb.axis(.vertical).spacing(12).value

        private func makeButton(_ text: String) -> DTB.Button {
            let b = DTB.Button()
            b.setTitle(text, for: .normal)
            b.setBackgroundColor(.dtb.create("dtb.theme"), for: .normal)
            b.setTextColor(.dtb.create("dtb.text4"), for: .normal)
            b.setContentEdgeInsets(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16), for: .normal)
            return b
        }
    }
}
