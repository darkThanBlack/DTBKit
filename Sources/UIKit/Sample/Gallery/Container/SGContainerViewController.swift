//
//  SGContainerViewController.swift
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

    /// 叶子 item VC：展示 `container_style.json`（读 `DefaultStylesProvider.mapper`），每个 key 一个 `ContainerView` 预览。
    final class SGContainerViewController: DTB.BaseViewController {

        private var keys: [String] = []

        private var styles: [String: DTB.ContainerStyle] = [:]

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
            styles = (DTB.DefaultStylesProvider.shared.mapper["container_style"] as? [String: DTB.ContainerStyle]) ?? [:]
            keys = styles.keys.sorted()
            tableView.reloadData()
        }

        private lazy var tableView: UITableView = {
            let tv = UITableView.dtb.plain(self, cells: [DTB.SGContainerCell.self])
            tv.backgroundColor = DTB.SampleDepends.bgColor()
            tv.rowHeight = 68
            return tv
        }()
    }
}

extension DTB.SGContainerViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DTB.SGContainerCell = tableView.dtb.dequeueReusableCellEnsured(indexPath)
        let key = keys[indexPath.row]
        cell.config(key: key, style: styles[key] ?? DTB.ContainerStyle())
        return cell
    }
}
