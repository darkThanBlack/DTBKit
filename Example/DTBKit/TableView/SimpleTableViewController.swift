//
//  SimpleTableViewController.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/29
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

protocol DTBCellTestable {
    
}

///
class SimpleTableViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews(in: view)
        
        mocks()
    }
    
    private var datas: [XMDotSegmentCellModel] = []
    
    private func mocks() {
        datas = [
            XMDotSegmentCellModel(
                title: "左侧标题",
                options: [
                    XMDotSegmentItemModel(
                        primaryKey: "1",
                        title: "选项1",
                        isSelected: true
                    ),
                    XMDotSegmentItemModel(
                        primaryKey: "2",
                        title: "选项2很长很长很长很长很长很长很长很长很长",
                        isSelected: false
                    )
                ],
                showSingleLine: true
            ),
            XMDotSegmentCellModel(
                title: "左侧标题",
                options: [
                    XMDotSegmentItemModel(
                        primaryKey: "3",
                        title: "选项1",
                        isSelected: false
                    ),
                    XMDotSegmentItemModel(
                        primaryKey: "4",
                        title: "选项2很长很长很长很长很长很长很长很长很长",
                        isSelected: true
                    ),
                    XMDotSegmentItemModel(
                        primaryKey: "5",
                        title: "选项2",
                        isSelected: true
                    ),
                    XMDotSegmentItemModel(
                        primaryKey: "6",
                        title: "选项2",
                        isSelected: true
                    )
                ],
                showSingleLine: false
            )
        ]
        
        tableView.reloadData()
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.left.right.bottom.equalTo(box.safeAreaLayoutGuide)
            } else {
                make.top.left.right.bottom.equalTo(box)
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44.0
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
         tableView.register(XMDotSegmentCell.self, forCellReuseIdentifier: String(describing: XMDotSegmentCell.self))
        return tableView
    }()
}

extension SimpleTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension SimpleTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < datas.count else {
            return UITableViewCell()
        }
        
        if let model = datas[indexPath.row] as? XMDotSegmentCellDataSource,
           let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: XMDotSegmentCell.self)) as? XMDotSegmentCell {
            
            cell.config(with: model)
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
}

extension SimpleTableViewController: XMDotSegmentCellDelegate {
    
    func dotSegmentCellDidTap(_ cell: UITableViewCell?, cellKey: String?, itemKey: String?) {
        guard let c = cell, let indexPath = tableView.indexPath(for: c) else {
            return
        }
        
        if let sIndex = datas.firstIndex(where: { $0.options.contains(where: { $0.primaryKey == itemKey }) }) {
            for (index, _) in datas[sIndex].options.enumerated() {
                datas[sIndex].options[index].isSelected = datas[sIndex].options[index].primaryKey == itemKey
            }
        }
        
        tableView.reloadData()
    }
}
