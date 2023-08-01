//
//  GuideListViewController.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/22
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

/// 新手引导 - 任务列表
class GuideListViewController: UIViewController {
    
    private let viewModel = GuideViewModel()
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        viewModel.mocks {
            self.contentView.reloadData()
        }
        
        loadViews(in: view)
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(contentView)
        box.addSubview(robotImageView)
        [contentView, robotImageView].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: box.leftAnchor, constant: 0.0),
            contentView.rightAnchor.constraint(equalTo: box.rightAnchor, constant: 0.0),
            contentView.bottomAnchor.constraint(equalTo: box.bottomAnchor, constant: 0.0),
            contentView.heightAnchor.constraint(equalTo: box.heightAnchor, multiplier: 0.87)
        ])
        NSLayoutConstraint.activate([
            robotImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -16.0),
            robotImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            robotImageView.widthAnchor.constraint(equalToConstant: 60.0),
            robotImageView.heightAnchor.constraint(equalToConstant: 45.0)
        ])
    }
    
    private lazy var contentView: GuideListView = {
        let contentView = GuideListView(viewModel: self.viewModel)
        contentView.delegate = self
        return contentView
    }()
    
    private lazy var robotImageView: UIImageView = {
        let robotImageView = UIImageView()
        robotImageView.image = DriftAdapter.imageNamed("guide_robot")
        robotImageView.contentMode = .scaleAspectFit
        return robotImageView
    }()
}

extension GuideListViewController: GuideListViewDelegate {
    
    func closeEvent() {
        navigationController?.dismiss(animated: true)
    }
    
    func pushEvent() {
        let docsVC = GuideDocsViewController()
        navigationController?.pushViewController(docsVC, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            SimpleVisualViewController.show(in: {
                let label = EdgeLabel()
                label.text = "Edge Label"
                label.textColor = .systemRed
                label.backgroundColor = .systemYellow
                label.edgeInsets = UIEdgeInsets(top: 4.0, left: 16.0, bottom: 8.0, right: 32.0)
                return label
            }, behavior: .center)
        }
    }
    
    ///
    func cellButtonEvent(_ data: GuideListCellDataSource) {
        // todo: 去完成/确认完成
        pushEvent()
    }
    
    ///
    func guideListRefreshEvent() {
        let alert = UIAlertController(title: "提示", message: "刷新结果", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    ///
    func guideGroupViewDidSelect(at index: Int) {
        viewModel.select(group: index)
        
        contentView.reloadData()
    }
}
