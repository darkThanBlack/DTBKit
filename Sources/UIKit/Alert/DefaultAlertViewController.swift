//
//  DefaultAlertViewController.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/8
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {

    /// 默认 alert 实现：居中卡片，仿 `UIAlertController(.alert)`，与 `DefaultAlertProvider` 一一对应。
    ///
    /// 数据入口是 `Any?`：`if as` 分发 ``Alert``（字符串）/ ``AttributeAlert``（富文本）。
    /// 固定布局：title / message 用 ``Label`` 常驻 + `isHidden` 切换（非 add/remove），
    /// 为 `update(creater:)` 可复用准备；buttons 依赖数量，仍动态重建。
    public final class DefaultAlertViewController: BaseAlertViewController {

        /// 归一化后的 action（`Alert` / `AttributeAlert` 的 action 都归一到此处渲染）。
        private struct ActionDisplay {
            let title: String?
            let attrTitle: NSAttributedString?
            let handler: (() -> Void)?
        }

        /// 当前数据（`Alert` / `AttributeAlert` / 其它），可 `update`。
        private var creater: Any? = nil

        /// 归一化后的当前 actions。
        private var actions: [ActionDisplay] = []

        public init(creater: Any?) {
            self.creater = creater
            super.init(nibName: nil, bundle: nil)
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public override func viewDidLoad() {
            super.viewDidLoad()
            loadViews(in: contentView)
            update(creater: creater)
        }

        /// 换数据：`if as` 分发，title / message 走 `isHidden`，buttons 重建。
        public func update(creater: Any?) {
            self.creater = creater
            if let alert = creater as? DTB.Alert {
                applyTitle(alert.title, attrTitle: nil)
                applyMessage(alert.message, attrMessage: nil)
                applyActions(alert.actions.map { action in
                    ActionDisplay(
                        title: action.title,
                        attrTitle: nil,
                        handler: action.handler.map { handler in { handler(action) } }
                    )
                })
            } else if let alert = creater as? DTB.AttributeAlert {
                applyTitle(nil, attrTitle: alert.title)
                applyMessage(nil, attrMessage: alert.message)
                applyActions(alert.actions.map { action in
                    ActionDisplay(
                        title: nil,
                        attrTitle: action.title,
                        handler: action.handler.map { handler in { handler(action) } }
                    )
                })
            } else {
                applyTitle(nil, attrTitle: nil)
                applyMessage(nil, attrMessage: nil)
                applyActions([])
            }
        }

        // MARK: - Apply

        private func applyTitle(_ text: String?, attrTitle: NSAttributedString?) {
            if let attr = attrTitle {
                titleLabel.attributedText = attr
                titleLabel.isHidden = false
            } else {
                titleLabel.text = text
                titleLabel.isHidden = text?.isEmpty != false
            }
        }

        private func applyMessage(_ text: String?, attrMessage: NSAttributedString?) {
            if let attr = attrMessage {
                messageLabel.attributedText = attr
                messageLabel.isHidden = false
            } else {
                messageLabel.text = text
                messageLabel.isHidden = text?.isEmpty != false
            }
        }

        private func applyActions(_ newActions: [ActionDisplay]) {
            actions = newActions
            actionStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

            separator.isHidden = newActions.isEmpty
            guard newActions.isEmpty == false else { return }

            if newActions.count == 2 {
                let row = UIStackView()
                row.axis = .horizontal
                row.alignment = .fill
                row.distribution = .fillEqually
                row.spacing = 0
                for (index, action) in newActions.enumerated() {
                    row.addArrangedSubview(makeButton(action, index: index))
                }
                actionStack.addArrangedSubview(row)
            } else {
                for (index, action) in newActions.enumerated() {
                    actionStack.addArrangedSubview(makeButton(action, index: index))
                }
            }
        }

        private func makeButton(_ action: ActionDisplay, index: Int) -> DTB.Button {
            let button = DTB.Button()
            button.tag = index
            if let attr = action.attrTitle {
                button.setAttributedText(attr, for: .normal)
            } else {
                button.setTitle(action.title, for: .normal)
                button.setFont(UIFont.systemFont(ofSize: 17, weight: .regular))
                button.setTextColor(.dtb.create("dtb.theme"), for: .normal)
            }
            button.addTarget(self, action: #selector(actionTapped(_:)), for: .touchUpInside)
            button.snp.makeConstraints { make in
                make.height.equalTo(44)
            }
            return button
        }

        @objc private func actionTapped(_ sender: DTB.Button) {
            guard actions.indices.contains(sender.tag) else { return }
            dtb.popAnyway()
            actions[sender.tag].handler?()
        }

        // MARK: - Views

        private func loadViews(in box: UIView) {
            box.addSubview(card)
            card.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalTo(270)
            }
        }

        /// 卡片容器：背景 + 圆角，内嵌纵向 stack。
        private lazy var card: DTB.Container<UIStackView> = {
            let container = DTB.Container(
                child: stack,
                style: DTB.ContainerStyle(
                    backgroundColor: .dtb.create("dtb.bg2"),
                    shape: DTB.ShapeStyle(corners: [.allCorners], radius: .fixed(14.0))
                )
            )
            return container
        }()

        private lazy var stack: UIStackView = {
            let s = UIStackView(arrangedSubviews: [titleLabel, messageLabel, separator, actionStack])
            s.axis = .vertical
            s.alignment = .fill
            s.distribution = .fill
            s.spacing = 0
            return s
        }()

        private lazy var titleLabel: DTB.Label = {
            let label = DTB.Label()
            label.setConfig(DTB.LabelStyle(
                contentEdgeInsets: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16),
                textColor: .dtb.create("dtb.text"),
                font: UIFont.systemFont(ofSize: 17, weight: .semibold),
                numberOfLines: 0,
                textAlignment: .center
            ))
            label.isHidden = true
            return label
        }()

        private lazy var messageLabel: DTB.Label = {
            let label = DTB.Label()
            label.setConfig(DTB.LabelStyle(
                contentEdgeInsets: UIEdgeInsets(top: 8, left: 16, bottom: 20, right: 16),
                textColor: .dtb.create("dtb.text2"),
                font: UIFont.systemFont(ofSize: 13, weight: .regular),
                numberOfLines: 0,
                textAlignment: .center
            ))
            label.isHidden = true
            return label
        }()

        private lazy var separator: UIView = {
            let v = UIView()
            v.backgroundColor = .dtb.create("dtb.border")
            v.snp.makeConstraints { make in
                make.height.equalTo(0.5)
            }
            v.isHidden = true
            return v
        }()

        private lazy var actionStack: UIStackView = {
            let s = UIStackView()
            s.axis = .vertical
            s.alignment = .fill
            s.distribution = .fill
            s.spacing = 0
            return s
        }()
    }

}
