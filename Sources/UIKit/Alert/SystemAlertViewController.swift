//
//  SystemAlertViewController.swift
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

    /// 复刻系统 `UIAlertController(.alert)` 的居中卡片。
    ///
    /// 消费 ``AlertCreater`` 数据：title + message + actions。
    /// 两个 action 横排，其余竖排。
    public final class SystemAlertViewController: AlertViewController {

        private let creater: AlertCreater

        public init(creater: AlertCreater) {
            self.creater = creater
            super.init(nibName: nil, bundle: nil)
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public override func viewDidLoad() {
            super.viewDidLoad()
            buildCard()
        }

        // MARK: - Build

        private func buildCard() {
            contentView.backgroundColor = .dtb.create("dtb.bg2")
            contentView.layer.cornerRadius = 14
            contentView.clipsToBounds = true

            contentView.snp.makeConstraints { make in
                make.width.equalTo(270)
            }

            contentView.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            buildTextSection()
            buildActionsSection()
        }

        private func buildTextSection() {
            let titleText = creater.attrTitle?.string ?? creater.title
            let messageText = creater.attrMessage?.string ?? creater.message
            let hasTitle = titleText?.isEmpty == false
            let hasMessage = messageText?.isEmpty == false
            guard hasTitle || hasMessage else { return }

            let textStack = UIStackView().dtb
                .axis(.vertical)
                .alignment(.fill)
                .spacing(8)
                .value
            textStack.isLayoutMarginsRelativeArrangement = true
            textStack.layoutMargins = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)

            if hasTitle {
                let label = UILabel()
                if let attr = creater.attrTitle {
                    label.attributedText = attr
                } else {
                    label.text = titleText
                    label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                    label.textColor = .dtb.create("dtb.text")
                }
                label.textAlignment = .center
                label.numberOfLines = 0
                textStack.addArrangedSubview(label)
            }

            if hasMessage {
                let label = UILabel()
                if let attr = creater.attrMessage {
                    label.attributedText = attr
                } else {
                    label.text = messageText
                    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                    label.textColor = .dtb.create("dtb.text2")
                }
                label.textAlignment = .center
                label.numberOfLines = 0
                textStack.addArrangedSubview(label)
            }

            stackView.addArrangedSubview(textStack)
        }

        private func buildActionsSection() {
            guard creater.actions.isEmpty == false else { return }

            let separator = UIView()
            separator.backgroundColor = .dtb.create("dtb.border")
            stackView.addArrangedSubview(separator)
            separator.snp.makeConstraints { make in
                make.height.equalTo(0.5)
            }

            if creater.actions.count == 2 {
                let row = UIStackView().dtb
                    .axis(.horizontal)
                    .alignment(.fill)
                    .spacing(0)
                    .value
                row.distribution = .fillEqually
                for (index, action) in creater.actions.enumerated() {
                    row.addArrangedSubview(makeButton(action, index: index))
                }
                stackView.addArrangedSubview(row)
            } else {
                for (index, action) in creater.actions.enumerated() {
                    stackView.addArrangedSubview(makeButton(action, index: index))
                }
            }
        }

        private func makeButton(_ action: AlertActionCreater, index: Int) -> DTB.Button {
            let button = DTB.Button()
            button.tag = index
            button.setTitle(action.attrTitle?.string ?? action.title, for: .normal)
            button.setFont(UIFont.systemFont(ofSize: 17, weight: .regular))
            button.setTextColor(.dtb.create("dtb.theme"), for: .normal)
            button.addTarget(self, action: #selector(actionTapped(_:)), for: .touchUpInside)
            button.snp.makeConstraints { make in
                make.height.equalTo(44)
            }
            return button
        }

        @objc private func actionTapped(_ sender: DTB.Button) {
            let action = creater.actions[sender.tag]
            dtb.popAnyway()
            action.handler?(action)
        }

        // MARK: - Views

        private lazy var stackView = UIStackView().dtb
            .axis(.vertical)
            .alignment(.fill)
            .spacing(0)
            .value
    }

}
