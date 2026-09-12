//
//  SGI18NViewController.swift
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

    /// 叶子 item VC：展示 `string_zh.json` 解析后的文案（读 `I18NManager.mapper`）。
    final class SGI18NViewController: DTB.BaseViewController {

        private var keys: [String] = []

        override func viewDidLoad() {
            super.viewDidLoad()

            loadViews(in: view)
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            reload()
        }

        private func loadViews(in box: UIView) {
            box.addSubview(headerLabel)
            box.addSubview(tableView)

            headerLabel.snp.makeConstraints { make in
                make.top.equalToSuperview()
                // 与 value 列左缘对齐（16 边距 + key 列宽 + 12 间距）
                make.leading.equalToSuperview().inset(16 + SGI18NCell.keyWidth + 12)
                make.trailing.equalToSuperview().inset(16)
                make.height.equalTo(36)
            }
            tableView.snp.makeConstraints { make in
                make.top.equalTo(headerLabel.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
        }

        private func reload() {
            keys = DTB.I18NManager.shared.mapper.keys.sorted()
            refreshHeader()
            tableView.reloadData()
        }

        /// 表头：只展示当前语言 key（内存里只有单语言，故单列，区别于 color 的 mode 多列）。
        private func refreshHeader() {
            headerLabel.text = {
                if let key = DTB.I18NManager.shared.currentKey, !key.isEmpty {
                    return key
                }
                return DTB.I18NManager.shared.systemLanguageCode() ?? "?"
            }()
        }

        private lazy var headerLabel: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            lb.textColor = DTB.SampleDepends.themeColor()
            return lb
        }()

        private lazy var tableView: UITableView = {
            let tv = UITableView.dtb.plain(self, cells: [DTB.SGI18NCell.self])
            tv.rowHeight = UITableView.automaticDimension
            tv.estimatedRowHeight = 60
            return tv
        }()
    }
}

extension DTB.SGI18NViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DTB.SGI18NCell = tableView.dtb.dequeueReusableCellEnsured(indexPath)
        let key = keys[indexPath.row]
        cell.config(key: key, value: DTB.I18NManager.shared.mapper[key] ?? "")
        return cell
    }
}
