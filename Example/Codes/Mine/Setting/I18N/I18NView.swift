//
//  I18NView.swift
//  Ring
//
//  Created by moonShadow on 2026/5/29
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

///
protocol I18NViewDelegate: AnyObject {
    
    func listItemEvent(_ data: DTB.CellData)
}

/// 我的
class I18NView: UIView {
    
    weak var delegate: I18NViewDelegate?
    
    private var sections: [DTB.SectionModel] = []
    
    func updateSection(_ data: [DTB.SectionModel]) {
        self.sections = data
        tableView.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.dtb.plain(self, cells: [DTB.TDISelectTableViewCell.self])
        tableView.isScrollEnabled = false
        return tableView
    }()
}

extension I18NView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = sections.dtb[indexPath.section]?.cells.dtb[indexPath.row]?.data else {
            return
        }
        delegate?.listItemEvent(data)
    }
}

extension I18NView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.dtb[section]?.cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DTB.TDISelectTableViewCell = tableView.dtb.dequeueReusableCell(indexPath), let model = sections.dtb[indexPath.section]?.cells.dtb[indexPath.row] else {
            DTB.console.error()
            return UITableViewCell()
        }
        cell.update(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
}
