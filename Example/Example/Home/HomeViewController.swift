//
//  HomeViewController.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/28.
//  Copyright © 2023 darkThanBlack. All rights reserved.
//

import DTBKit

// MARK: - Data Models

protocol DemoDescribable {
    var title: String? { get }
    var detail: String? { get }
}

struct DemoSectionModel {
    let type: SectionType
    let cells: [DemoCellModel]

    init(type: SectionType) {
        self.type = type
        self.cells = type.cells.map({ DemoCellModel(type: $0) })
    }
}

extension DemoSectionModel: DemoDescribable {
    var title: String? {
        return type.rawValue
    }

    var detail: String? {
        return type.desc
    }
}

struct DemoCellModel {
    let type: BaseCellType
}

extension DemoCellModel: DemoDescribable {
    var title: String? {
        return type.rawValue
    }

    var detail: String? {
        return type.desc
    }
}

// MARK: - HomeViewController

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
        tableView.register(DemoTableViewCell.self,
                          forCellReuseIdentifier: DemoTableViewCell.identifier)
        tableView.register(DemoSectionHeaderView.self,
                          forHeaderFooterViewReuseIdentifier: DemoSectionHeaderView.identifier)

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
            withIdentifier: DemoTableViewCell.identifier,
            for: indexPath
        ) as? DemoTableViewCell else {
            return UITableViewCell()
        }

        let cellModel = sections[indexPath.section].cells[indexPath.row]
        cell.configure(with: cellModel)

        return cell
    }
}

// MARK: - DemoEntry TableViewDelegate Extensions

extension DemoEntry {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: DemoSectionHeaderView.identifier
        ) as? DemoSectionHeaderView else {
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
