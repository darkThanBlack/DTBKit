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

    /// 叶子 item VC：渲染主题色板（直接读 `ColorManager.mapper` 的解析结果）。
    final class SGColorViewController: DTB.BaseViewController {

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
            box.addSubview(headerStack)
            box.addSubview(tableView)

            headerStack.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.trailing.equalToSuperview().inset(16)
                make.height.equalTo(36)
                make.width.equalTo(SGColorCell.columnWidth * 3)
            }
            tableView.snp.makeConstraints { make in
                make.top.equalTo(headerStack.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
        }

        // MARK: - Data

        private func reload() {
            keys = DTB.ColorManager.shared.mapper.keys.sorted()
            tableView.reloadData()
            refreshHeader()
        }

        /// 高亮当前 mode 对应的列。
        private func refreshHeader() {
            let index: Int? = {
                switch DTB.ColorManager.shared.currentMode ?? .followSystem {
                case .light:    return 0
                case .dark:     return 1
                case .autoDark: return 2
                case .followSystem:
                    return DTB.ColorManager.systemColorStyle() == "dark" ? 1 : 0
                case .custom:   return nil
                }
            }()
            for (i, label) in headerLabels.enumerated() {
                let active = (i == index)
                label.textColor = active ? .dtb.create("dtb.theme") : .dtb.create("dtb.text2")
                label.font = UIFont.systemFont(ofSize: 12, weight: active ? .bold : .medium)
            }
        }

        // MARK: - Views

        private lazy var headerLabels: [UILabel] = ["light", "dark", "auto_dark"].map {
            let lb = UILabel()
            lb.text = $0
            lb.textAlignment = .center
            lb.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            lb.textColor = .dtb.create("dtb.text2")
            return lb
        }

        private lazy var headerStack = UIStackView(arrangedSubviews: headerLabels)
            .dtb.axis(.horizontal).distribution(.fillEqually).value

        private lazy var tableView: UITableView = {
            let tv = UITableView.dtb.plain(self, cells: [DTB.SGColorCell.self])
            tv.rowHeight = 56
            return tv
        }()
    }
}

extension DTB.SGColorViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DTB.SGColorCell = tableView.dtb.dequeueReusableCellEnsured(indexPath)
        let key = keys[indexPath.row]
        let dict = DTB.ColorManager.shared.mapper[key] ?? [:]
        let light = dict["light"] ?? .clear
        let dark = dict["dark"]
        let autoDark = light.dtb.luminanceInvertedColor()
        cell.config(key: key, light: light, dark: dark, autoDark: autoDark)
        return cell
    }
}
