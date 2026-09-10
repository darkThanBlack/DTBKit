//
//  SGLabelViewController.swift
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

    /// 叶子 item VC：渲染 Label 组件（纯色 / 描边）。
    final class SGLabelViewController: DTB.BaseViewController {

        override func viewDidLoad() {
            super.viewDidLoad()

            loadViews(in: view)
        }

        private func loadViews(in box: UIView) {
            box.addSubview(stack)
            
            stack.snp.makeConstraints { make in make.edges.equalToSuperview().inset(16) }
        }

        private lazy var stack = UIStackView(arrangedSubviews: [
            makeLabel("plain", DTB.LabelStyle(
                backgroundColor: .dtb.create("dtb.theme"),
                contentEdgeInsets: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12),
                textColor: .dtb.create("dtb.text4"),
            )),
            makeLabel("shape", DTB.LabelStyle(
                contentEdgeInsets: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12),
                textColor: .dtb.create("dtb.theme"),
                shape: DTB.ShapeStyle(
                    corners: [.allCorners],
                    radius: .fixed(8),
                    strokeColor: .dtb.create("dtb.theme"),
                    lineWidth: 1
                )
            )),
        ]).dtb.axis(.horizontal).spacing(12).value

        private func makeLabel(_ text: String, _ style: DTB.LabelStyle) -> DTB.Label {
            let l = DTB.Label()
            l.text = text
            l.setConfig(style)
            return l
        }
    }
}
