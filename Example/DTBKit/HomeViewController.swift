//
//  HomeViewController.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/28.
//  Copyright © 2023 darkThanBlack. All rights reserved.
//

import UIKit

protocol DemoDescribable {
    
    var title: String? { get }
    
    var detail: String? { get }
}

struct DemoSectionModel {
    
    enum SectionType: String, CaseIterable {
        
        case `default`
    }
    
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
        return nil
    }
}

extension DemoSectionModel.SectionType {
    
    var cells: [DemoCellModel.CellType] {
        switch self {
        case .default:
            return [
                .edgeLabel
            ]
        }
    }
}

struct DemoCellModel {
    
    enum CellType: String, CaseIterable {
        
        case edgeLabel
    }
    
    let type: CellType
}

extension DemoCellModel: DemoDescribable {
    
    var title: String? {
        return type.rawValue
    }
    
    var detail: String? {
        switch type {
        case .edgeLabel:  return "带内边距的 UILabel"
        }
    }
}

//MARK: -

///Home
class HomeViewController: UIViewController {
    
    private let sections = DemoSectionModel.SectionType.allCases.map({
        DemoSectionModel(type: $0)
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.backgroundColor = DTB.Color.XM.White.I()
        
        loadViews(in: view)
        
        self.tableView.reloadData()
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: box.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: box.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: box.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: box.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44.0
        if #available(iOS 11.0, *) {
            print("contentInsetAdjustmentBehavior...")
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.register(DemoCell.self, forCellReuseIdentifier: String(describing: DemoCell.self))
        return tableView
    }()
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].cells[indexPath.row].type {
        case .edgeLabel:
            break
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30.0)
        label.text = sections[section].title
        label.backgroundColor = DTB.Color.XM.White.I()
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DemoCell.self)) as? DemoCell else {
            return UITableViewCell()
        }
        cell.configCell(model: sections[indexPath.section].cells[indexPath.row])
        return cell
    }
}

///
class DemoCell: UITableViewCell {
    
    func configCell(model: DemoDescribable) {
        titleLabel.text = model.title
        detailLabel.text = model.detail
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        loadViews(in: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadViews(in box: UIView) {
        [titleLabel, detailLabel, singleLine].forEach({
            box.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: box.topAnchor, constant: 8.0),
            titleLabel.leftAnchor.constraint(equalTo: box.leftAnchor, constant: 16.0),
            titleLabel.rightAnchor.constraint(equalTo: box.rightAnchor, constant: -16.0),
        ])
        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            detailLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            detailLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
        ])
        NSLayoutConstraint.activate([
            singleLine.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 8.0),
            singleLine.leftAnchor.constraint(equalTo: box.leftAnchor),
            singleLine.rightAnchor.constraint(equalTo: box.rightAnchor),
            singleLine.bottomAnchor.constraint(equalTo: box.bottomAnchor),
            singleLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    
    private lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = UIFont.systemFont(ofSize: 11.0, weight: .regular)
        detailLabel.textColor = DTB.Color.XM.LightGray.A()
        detailLabel.numberOfLines = 0
        return detailLabel
    }()
    
    private lazy var singleLine: UIView = {
        let singleLine = UIView()
        singleLine.backgroundColor = DTB.Color.XM.White.D()
        return singleLine
    }()
}
