//
//  SGFontViewController.swift
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

    /// 叶子 item VC：展示已注册的自定义字体（读 `FontManager.customFontNames`）。
    final class SGFontViewController: DTB.BaseViewController {

        private var names: [String] = []

        override func viewDidLoad() {
            super.viewDidLoad()

            loadViews(in: view)
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            reload()
        }

        private func loadViews(in box: UIView) {
            box.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        private func reload() {
            names = DTB.FontManager.shared.customFontNames.sorted()
            tableView.reloadData()
        }

        private lazy var tableView: UITableView = {
            let tv = UITableView.dtb.plain(self, cells: [DTB.SGFontCell.self])
            tv.rowHeight = 72
            return tv
        }()
    }
}

extension DTB.SGFontViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DTB.SGFontCell = tableView.dtb.dequeueReusableCellEnsured(indexPath)
        cell.config(name: names[indexPath.row])
        return cell
    }
}
