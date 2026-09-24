//
//  SGBaseSelfSizingViewController.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/17
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {

    /// BaseSelfSizingView 展示页。
    ///
    /// 按钮每次触发都动态 add / remove 一个 self-sizing view（直接挂在 vc.view 上），
    /// 1 秒后打印该 view 的 renderLog —— layoutSubviews / intrinsicContentSize / sizeThatFits 的调用过程靠日志观察。
    final class SGBaseSelfSizingViewController: DTB.BaseViewController {

        /// 当前挂在 view 上的实例；nil = 已移除
        private var demoView: DTB.Label?

        override func viewDidLoad() {
            super.viewDidLoad()

            view.addSubview(button)
            button.snp.makeConstraints { make in
                make.centerX.equalTo(view)
                make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            }

            updateButtonTitle()
        }

        /// add / remove 一个 self-sizing view
        @objc private func onTap() {
            let target: DTB.Label
            let action: String

            if let current = demoView {
                /// 清空后再移除，日志里只剩「移除」这一段
                current.renderLog = []
                current.removeFromSuperview()
                demoView = nil

                target = current
                action = "remove"
            } else {
                let label = DTB.Label()
                label.updateUI(DTB.LabelStyle(
                    backgroundColor: DTB.SampleDepends.bg2Color(),
                    contentEdgeInsets: UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12),
                    textColor: DTB.SampleDepends.textColor(),
                    font: UIFont.systemFont(ofSize: 15.0, weight: .regular),
                    numberOfLines: 0,
                    shape: DTB.ShapeStyle(corners: [.allCorners], radius: .fixed(10.0))
                ))
                label.text = "动态 add 的 self-sizing view：1 秒后打印 renderLog"
                label.renderLog = []
                demoView = label

                view.addSubview(label)
                label.snp.makeConstraints { make in
                    make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
                    make.leading.trailing.equalTo(view).inset(16)
                }

                target = label
                action = "add"
            }

            updateButtonTitle()

            /// 等布局收敛完再打印
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                DTB.console.log("[\(action)] renderLog =\n" + (target.renderLog ?? []).joined(separator: "\n"))
            }
        }

        private func updateButtonTitle() {
            button.setTitle(demoView == nil ? "add 一个 self-sizing view" : "remove 掉它")
        }

        private lazy var button: DTB.Button = {
            let b = DTB.Button(frame: .zero)
            b.setConfig(DTB.ButtonStyle(
                backgroundColor: DTB.SampleDepends.buttonColor(),
                contentEdgeInsets: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16),
                textColor: DTB.SampleDepends.text4Color(),
                font: UIFont.systemFont(ofSize: 15.0, weight: .regular),
                shape: DTB.ShapeStyle(corners: [.allCorners], radius: .fixed(22.0))
            ), for: .normal)
            b.addTarget(self, action: #selector(onTap), for: .touchUpInside)
            return b
        }()
    }
}
