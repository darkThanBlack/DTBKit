//
//  HomeViewController.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/28.
//  Copyright © 2023 darkThanBlack. All rights reserved.
//

import DTBKit

/// DTBKit Demo 主界面，展示各种功能示例
class HomeViewController: BaseViewController {

    // MARK: - Private Properties

    private let sections = DemoSectionModel.SectionType.allCases.map({
        DemoSectionModel(type: $0)
    })

    private lazy var entry = DemoEntry(sections: sections)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        reloadData()
    }

    // MARK: - Private Methods
    
    private func setupViews() {
        loadViews(in: view)
    }

    private func reloadData() {
        tableView.reloadData()
    }

    private func loadViews(in box: UIView) {
        box.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        // 使用安全区域约束
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: box.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: box.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: box.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: box.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: box.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: box.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: box.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: box.bottomAnchor)
            ])
        }
    }

    // MARK: - UI Components

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        // 基础配置
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none

        // 代理设置
        tableView.delegate = entry
        tableView.dataSource = self

        // 自动高度计算配置
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 40.0
        tableView.sectionHeaderHeight = UITableView.automaticDimension

        // iOS 版本适配
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        // 注册可复用组件
        tableView.register(HomeCell.self,
                           forCellReuseIdentifier: String(describing: HomeCell.self))
        tableView.register(HomeSectionHeaderView.self,
                          forHeaderFooterViewReuseIdentifier: String(describing: HomeSectionHeaderView.self))

        return tableView
    }()
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: HomeCell.self),
            for: indexPath
        ) as? HomeCell else {
            return UITableViewCell()
        }

        let cellModel = sections[indexPath.section].cells[indexPath.row]
        cell.configCell(<#T##data: any HomeCellDataSource##any HomeCellDataSource#>)

        return cell
    }
}

// MARK: - DemoEntry TableViewDelegate Extensions

extension DemoEntry {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: HomeSectionHeaderView.self)
        ) as? HomeSectionHeaderView else {
            return nil
        }
        
        headerView.configure(with: sections[section])
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
