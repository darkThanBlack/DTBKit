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

    /// 叶子 item VC：展示 `DTB.Label`。
    ///
    /// 分上下两部分：
    /// - 布局展示：参数完全一致、约束不同下 label 的视觉表现；
    /// - `label_style.json` 解析结果（读 `DefaultStylesProvider.mapper`，每个 key 一个 `Label` 预览）。
    final class SGLabelViewController: DTB.BaseViewController {

        /// 示例文字：所有 label 一致、长短适中，便于演示折行与压缩省略。
        private let demoText = "这是一段用于演示折行与压缩省略的示例文字"

        private var keys: [String] = []

        private var styles: [String: DTB.LabelStyle] = [:]

        override func viewDidLoad() {
            super.viewDidLoad()

            loadViews(in: view)
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            reload()
        }

        // MARK: - Item

        /// 统一参数的 demo label（背景 + 内边距 + 折行）。
        private func makeDemoLabel() -> DTB.Label {
            let label = DTB.Label()
            label.setConfig(DTB.LabelStyle(
                backgroundColor: DTB.SampleDepends.bg3Color(),
                contentEdgeInsets: UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10),
                textColor: DTB.SampleDepends.textColor(),
                font: UIFont.systemFont(ofSize: 13, weight: .regular),
                numberOfLines: 0,
                textAlignment: .left
            ))
            label.text = demoText
            return label
        }

        /// 一个展示 box：标题 + demo label（`layout` 里定 label 的不同约束）。
        ///
        /// - `fixedHeight`: 非 nil 时 box 固定高；nil 时 box 高度由 label 内容撑开（case 2）。
        private func makeCaseBox(
            title: String,
            fixedHeight: CGFloat?,
            _ layout: (DTB.Label, UILabel) -> Void
        ) -> UIView {
            let box = UIView()
            box.backgroundColor = DTB.SampleDepends.bg2Color()
            box.layer.cornerRadius = 8
            box.clipsToBounds = true

            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            titleLabel.textColor = DTB.SampleDepends.text3Color()

            let demoLabel = makeDemoLabel()

            box.addSubview(titleLabel)
            box.addSubview(demoLabel)

            titleLabel.snp.makeConstraints { make in
                make.leading.top.equalToSuperview().inset(10)
            }

            layout(demoLabel, titleLabel)

            if let height = fixedHeight {
                box.snp.makeConstraints { make in
                    make.height.equalTo(height)
                }
            }
            return box
        }

        // MARK: - View

        private func loadViews(in box: UIView) {
            box.addSubview(scrollView)
            scrollView.addSubview(contentStack)

            scrollView.snp.makeConstraints { make in
                make.edges.equalTo(box.safeAreaLayoutGuide)
            }
            contentStack.snp.makeConstraints { make in
                make.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
                make.width.equalTo(scrollView.snp.width).offset(-32)
            }

            contentStack.addArrangedSubview(makeTopIntroLabel("Label：尺寸由内容 + contentEdgeInsets 推算；约束不同，表现不同"))
            contentStack.addArrangedSubview(makeIntroLabel("布局展示：参数完全一致，仅约束不同"))

            contentStack.addArrangedSubview(makeCaseBox(title: "1. 只约束位置（无尺寸约束，靠 intrinsic 撑开）", fixedHeight: 100) { label, title in
                label.snp.makeConstraints { make in
                    make.leading.equalToSuperview().inset(10)
                    make.top.equalTo(title.snp.bottom).offset(8)
                }
            })

            contentStack.addArrangedSubview(makeCaseBox(title: "2. 靠内容大小撑开其他控件（父容器高度由内容决定）", fixedHeight: nil) { label, title in
                label.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(10)
                    make.top.equalTo(title.snp.bottom).offset(8)
                    make.bottom.equalToSuperview().inset(10)
                }
            })

            contentStack.addArrangedSubview(makeCaseBox(title: "3. 约束过小（宽度不足，内容被压缩折行）", fixedHeight: 150) { label, title in
                label.snp.makeConstraints { make in
                    make.leading.equalToSuperview().inset(10)
                    make.top.equalTo(title.snp.bottom).offset(8)
                    make.width.equalTo(150)
                }
            })

            contentStack.addArrangedSubview(makeCaseBox(title: "4. 约束过大（本身被拉长，内容按对齐方式排列）", fixedHeight: 150) { label, title in
                label.snp.makeConstraints { make in
                    make.leading.equalToSuperview().inset(10)
                    make.top.equalTo(title.snp.bottom).offset(8)
                    make.width.equalTo(280)
                    make.height.equalTo(64)
                }
            })

            contentStack.addArrangedSubview(makeIntroLabel("label_style.json 解析结果（内存解析，key 排序）"))
            contentStack.addArrangedSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.height.equalTo(240)
            }
        }

        private func reload() {
            styles = (DTB.DefaultStylesProvider.shared.mapper["label_style"] as? [String: DTB.LabelStyle]) ?? [:]
            keys = styles.keys.sorted()
            tableView.reloadData()
        }

        // MARK: - View (lazy)

        private lazy var scrollView: UIScrollView = {
            let sv = UIScrollView()
            sv.alwaysBounceVertical = true
            sv.showsVerticalScrollIndicator = false
            return sv
        }()

        private lazy var contentStack: UIStackView = {
            let s = UIStackView()
            s.axis = .vertical
            s.alignment = .fill
            s.distribution = .fill
            s.spacing = 16
            return s
        }()

        private lazy var tableView: UITableView = {
            let tv = UITableView.dtb.plain(self, cells: [DTB.SGLabelCell.self])
            tv.backgroundColor = .clear
            tv.isScrollEnabled = false
            tv.rowHeight = 68
            return tv
        }()

        private func makeIntroLabel(_ text: String) -> UILabel {
            let lb = UILabel()
            lb.text = text
            lb.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.text3Color()
            lb.textAlignment = .left
            lb.numberOfLines = 0
            return lb
        }

        private func makeTopIntroLabel(_ text: String) -> UILabel {
            let lb = UILabel()
            lb.text = text
            lb.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.textColor()
            lb.textAlignment = .left
            lb.numberOfLines = 0
            return lb
        }
    }
}

extension DTB.SGLabelViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DTB.SGLabelCell = tableView.dtb.dequeueReusableCellEnsured(indexPath)
        let key = keys[indexPath.row]
        cell.config(key: key, style: styles[key] ?? DTB.LabelStyle())
        return cell
    }
}
