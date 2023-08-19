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
    
    private let viewModel = GuideListViewModel()
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        loadViews(in: view)
        
        reloadTree()
    }
    
    private func reloadTree() {
//        viewModel.mocks2 {
//            self.contentView.reloadData()
            
            self.viewModel.mocks {
                self.contentView.reloadData()
            }
//        }
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
    
    /// 右上关闭按钮
    func closeEvent() {
        Drift.shared.navigator.close()
    }
    
    /// 切换组头
    func guideGroupViewDidSelect(at index: Int) {
        viewModel.select(group: index)
        contentView.reloadData()
    }
    
    /// 刷新
    func guideListRefreshEvent() {
        let alert = GuideRefreshAlertController(titles: ["任务1", "任务2"])
        alert.completedHandler = { [weak self] in
            self?.reloadTree()
        }
        self.present(alert, animated: true)
    }
    
    /// 整个 cell 点击
    func cellDidSelectedEvent(_ data: GuideListCellDataSource) {
        guard let model = viewModel.getCellModel(by: data.primaryKey) else {
            return
        }
        routerPush(with: model)
    }
    
    /// 去完成 / 确认完成
    func cellRightButtonEvent(_ data: GuideListCellDataSource) {
        guard let model = viewModel.getCellModel(by: data.primaryKey) else {
            return
        }
        
        switch model.bizType {
        case .pushable:
            routerPush(with: model)
        case .manually:
            manuallyEnsure(with: model)
        default:
            break
        }
    }
    
    ///
    private func routerPush(with model: GuideListCellModel) {
        switch model.jumpable {
        case .unknown:
            break
        case .noPermission(message: let message):
            DriftAdapter.makeToast(message)
        case .webOnly(message: let message):
            DriftAdapter.makeToast(message)
        case .locked:
            DriftAdapter.makeToast("完成前面的任务后，此任务将解锁")
        case .oldVersion:
            break
        case .success:
            actualRouterPush(linkUrl: model.linkUrl, routeUrl: model.jumpUrl)
        }
    }
    
    ///
    private func actualRouterPush(linkUrl: String?, routeUrl: String?) {
        // 浮窗页面栈跳转
        if let url = linkUrl, url.isEmpty == false {
            Drift.shared.navigator.push(with: url)
        } else {
            DriftAdapter.makeToast("未获取到任务指南数据")
        }
        
        // 主应用页面栈跳转
        if let url = routeUrl {
            DispatchQueue.main.asyncAfter(deadline: .now() + GuideAnimation.mainRouterDelay) {
                // MainNavigator.XMPush(url, animated: true)
            }
        } else {
            // do nth.
        }
    }
    
    /// 手动确认完成
    private func manuallyEnsure(with model: GuideListCellModel) {
        ///
        func actualEnsure() {
            let guideAlert = GuideRefreshAlertController(titles: [model.title ?? ""])
            guideAlert.completedHandler = {
                self.reloadTree()
            }
            present(guideAlert, animated: true)
        }
        
        // jumpable 意指主页面路由是否能够跳转，故此处只检查权限
        switch model.jumpable {
        case .noPermission(message: let message):
            DriftAdapter.makeToast(message)
        default:
            let alert = UIAlertController(title: "提示", message: "任务将会被手动置为已完成状态，是否继续？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                actualEnsure()
            }))
            present(alert, animated: true)
        }
    }
}
