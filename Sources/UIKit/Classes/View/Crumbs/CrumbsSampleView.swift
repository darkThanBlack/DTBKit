//
//  CrumbsSampleView.swift
//  Ring
//
//  Created by moonShadow on 2026/5/29
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    ///
    public protocol CrumbsSampleViewDelegate: AnyObject {
        
        func listItemEvent(_ indexPath: IndexPath)
    }
    
    ///
    @objc(DTBCrumbsSampleView)
    open class CrumbsSampleView: UIView {
        
        public weak var delegate: CrumbsSampleViewDelegate?
        
        private var sections: [DTB.SectionModel] = []
        
        public func updateSection(_ data: [DTB.SectionModel]) {
            self.sections = data
            tableView.reloadData()
        }
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            
            loadViews(in: self)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK: View
        
        private func loadViews(in box: UIView) {
            box.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.top.left.right.bottom.equalToSuperview()
            }
        }
        
        /// 缓解 cell 内部 remove/add 的性能影响
        private var registeredType = Set<DTB.CrumbsType>()
        
        private lazy var tableView: UITableView = {
            let tableView = UITableView.dtb.plain(self, cells: [DTB.CrumbsTableViewCell.self])
            return tableView
        }()
    }
}

extension DTB.CrumbsSampleView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.listItemEvent(indexPath)
    }
}

extension DTB.CrumbsSampleView: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.dtb[section]?.cells.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = sections.dtb[indexPath.section]?.cells.dtb[indexPath.row],
              let type = model.extra as? DTB.CrumbsType else {
            DTB.console.error("DTB.CrumbsSampleView: CrumbsType not found, put it in extra")
            return UITableViewCell()
        }
        
        let cell = {
            if registeredType.contains(type),
               let deq = tableView.dequeueReusableCell(withIdentifier: type.rawValue) as? DTB.CrumbsTableViewCell {
                return deq
            }
            tableView.register(DTB.CrumbsTableViewCell.self, forCellReuseIdentifier: type.rawValue)
            registeredType.insert(type)
            return tableView.dtb.dequeueReusableCellEnsured(indexPath)
        }()
        cell.registerCrumbs(type: type)
        cell.update(model: model)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12.0
    }
}
