//
//  MineView.swift
//  Ring
//
//  Created by moonShadow on 2026/5/26
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

///
protocol MineViewDelegates: MineHeaderViewDelegate {
    
    func listItemEvent(_ data: DTB.CellData)
}

/// 我的
class MineView: UIView {
    
    private var sections: [DTB.SectionModel] = []
    
    weak var delegate: MineViewDelegates? {
        didSet {
            headerView.delegate = delegate
        }
    }
    
    func updateHeader(_ data: MineHeaderViewModel) {
        headerView.updateData(data)
    }
    
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
    
    @objc private func logoutButtonEvent() {
        
    }

    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(headerView)
        box.addSubview(tableView)
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(box.snp.top).offset(12.0)
            make.left.right.equalToSuperview()
            make.height.equalTo(162.0)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private lazy var headerView: MineHeaderView = {
        let view = MineHeaderView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.dtb.plain(self, cells: [DTB.ITDIArrowTableViewCell.self])
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var logoutButton = {
        let button = DTB.Button()
        button.setConfig(.dtb.create("large05"))
        button.addTarget(self, action: #selector(logoutButtonEvent), for: .touchUpInside)
        return button
    }()
}

extension MineView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = sections.dtb[indexPath.section]?.cells.dtb[indexPath.row]?.data else {
            return
        }
        delegate?.listItemEvent(data)
    }
}

extension MineView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.dtb[section]?.cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let model = sections.dtb[indexPath.section]?.cells.dtb[indexPath.row] {
            let cell: DTB.ITDIArrowTableViewCell = tableView.dtb.dequeueReusableCellEnsured(indexPath)
            cell.update(model)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
}
