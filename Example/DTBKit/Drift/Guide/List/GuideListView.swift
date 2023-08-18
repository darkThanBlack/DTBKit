//
//  GuideListView.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/24
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit
import SnapKit

protocol GuideListViewDelegate: GuideGroupViewDelegate, GuideRefreshViewDelegate {
    
    ///
    func closeEvent()
    ///
    func cellRightButtonEvent(_ data: GuideListCellDataSource)
    ///
    func cellDidSelectedEvent(_ data: GuideListCellDataSource)
}

/// 新手引导 - 任务列表
class GuideListView: UIView {
    
    weak var delegate: GuideListViewDelegate? {
        didSet {
            self.groupView.delegate = delegate
            self.refreshView.delegate = delegate
        }
    }
    
    func reloadData() {
        groupView.setupItems(with: viewModel.groupList)
        let showGroup = viewModel.groupList.count > 1
        groupView.isHidden = showGroup ? false : true
        groupView.snp.updateConstraints { make in
            make.height.equalTo(showGroup ? 48.0 : 0.0)
        }
        
        countsLabel.text = viewModel.getCountsText()
        tableView.reloadData()
    }
    
    private let viewModel: GuideListViewModel
    
    init(viewModel: GuideListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        loadViews(in: backgroundView.contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeButtonEvent(button: UIButton) {
        delegate?.closeEvent()
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(titleLabel)
        box.addSubview(hintLabel)
        box.addSubview(groupView)
        box.addSubview(refreshView)
        box.addSubview(countsLabel)
        box.addSubview(tableView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(box.snp.top).offset(0)
            make.left.equalTo(box.snp.left).offset(16.0)
            make.right.equalTo(box.snp.right).offset(-16.0)
        }
        hintLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2.0)
            make.left.equalTo(box.snp.left).offset(16.0)
            make.right.equalTo(box.snp.right).offset(-16.0)
        }
        groupView.snp.makeConstraints { make in
            make.top.equalTo(hintLabel.snp.bottom).offset(0)
            make.left.right.equalTo(box)
            make.height.equalTo(0.0)
        }
        refreshView.snp.makeConstraints { make in
            make.top.equalTo(groupView.snp.bottom).offset(12.0)
            make.left.equalTo(box.snp.left).offset(8.0)
            make.right.equalTo(box.snp.right).offset(-8.0)
        }
        countsLabel.snp.makeConstraints { make in
            make.top.equalTo(refreshView.snp.bottom).offset(12.0)
            make.left.equalTo(box.snp.left).offset(16.0)
            make.right.lessThanOrEqualTo(box.snp.right).offset(-16.0)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(countsLabel.snp.bottom).offset(8.0)
            make.left.right.equalTo(box)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(box.safeAreaLayoutGuide.snp.bottom).offset(-8.0)
            } else {
                make.bottom.equalTo(box.snp.bottom).offset(-8.0)
            }
        }
    }
    
    private lazy var backgroundView: GuideContainerView = {
        let view = GuideContainerView()
        view.backgroundColor = DriftAdapter.color_FAFAFA()
        view.closeEventHandler = { [weak self] in
            self?.delegate?.closeEvent()
        }
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        titleLabel.textColor = DriftAdapter.color_333333()
        titleLabel.text = "一起来完成新手启动任务吧！"
        return titleLabel
    }()
    
    private lazy var hintLabel: UILabel = {
        let hintLabel = UILabel()
        hintLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        hintLabel.textColor = DriftAdapter.color_999999()
        hintLabel.numberOfLines = 2
        hintLabel.text = "系统落地从培训到熟练使用正常是7-15天，最快3天启用"
        return hintLabel
    }()
    
    private lazy var groupView: GuideGroupView = {
        let groupView = GuideGroupView()
        return groupView
    }()
    
    private lazy var refreshView: GuideRefreshView = {
        let refreshView = GuideRefreshView()
        refreshView.backgroundColor = DriftAdapter.color_FFF0E7()
        refreshView.layer.masksToBounds = true
        refreshView.layer.cornerRadius = 4.0
        return refreshView
    }()
    
    private lazy var countsLabel: UILabel = {
        let countsLabel = UILabel()
        countsLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        countsLabel.textColor = DriftAdapter.color_999999()
        countsLabel.text = "已完成 -/-"
        return countsLabel
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = DriftAdapter.color_FAFAFA()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44.0
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(GuideListCell.self, forCellReuseIdentifier: String(describing: GuideListCell.self))
        return tableView
    }()
}

extension GuideListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.cellList.count else {
            return
        }
        delegate?.cellDidSelectedEvent(viewModel.cellList[indexPath.row])
    }
}

extension GuideListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GuideListCell.self)) as? GuideListCell else {
            return UITableViewCell()
        }
        if indexPath.row < viewModel.cellList.count {
            let model = viewModel.cellList[indexPath.row]
            cell.config(with: model)
            cell.delegate = self
        }
        return cell
    }
}

extension GuideListView: GuideListCellDelegate {
    ///
    func cellRightButtonEvent(with cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              indexPath.row < viewModel.cellList.count else {
            return
        }
        delegate?.cellRightButtonEvent(viewModel.cellList[indexPath.row])
    }
}
