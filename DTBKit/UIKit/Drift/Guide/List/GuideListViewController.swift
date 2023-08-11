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
import XMBundleL1

/// 新手引导 - 任务列表
class GuideListViewController: UIViewController {
    
    private let viewModel = GuideListViewModel()
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        loadViews(in: view)
        
//        viewModel.mocks {
//            self.contentView.reloadData()
//        }
        
        reloadTree()
    }
    
    private func reloadTree() {
        viewModel.treeRequest().done { _ in
            self.contentView.reloadData()
        }.catch { error in
            if error.localizedDescription.count > 0 {
                self.view.toast(error.localizedDescription)
            }
        }
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
    
    /// 路由连通性测试
    func mockEvent() {
        
        func xmTopMost() -> UIViewController? {
            if let xmRoot = UIApplication.shared.windows.first(where: { $0.tag == xmWindowTag })?.rootViewController {
                return UIViewController.topMost(of: xmRoot)
            } else {
                return UIViewController.topMost
            }
        }
        
        let basic = xmTopMost()
        
        let routes = [
            ("员工管理", "xmzj://b/v5/staff/manage"),
            ("财务中心-小麦收银", "xmzj://b/xiaomai_cashier"),
            ("教务中心-课程/套餐", "xmzj://b/v5/course/list"),
            ("教务中心-班级", "xmzj://b/v5/class/list"),
            // xmzj://b/v5/feature/student?title=选择报名/续费的学员&hasAdd=true&redirectUri=xmzj://b/v5/contract/add?studentId=${studentId}
            ("教务中心-报名/续费", "xmzj://b/v5/feature/student?title=%E9%80%89%E6%8B%A9%E6%8A%A5%E5%90%8D%2F%E7%BB%AD%E8%B4%B9%E7%9A%84%E5%AD%A6%E5%91%98&hasAdd=true&redirectUri=xmzj%3A%2F%2Fb%2Fv5%2Fcontract%2Fadd%3FstudentId%3D%24%7BstudentId%7D"),
            ("教务中心-点名", "xmzj://b/v5/roll_call/list"),
            ("教务中心-课表", "xmzj://b/schedule/table"),
            ("教务中心-上课记录", "xmzj://b/v5/class/record"),
            ("教务中心-转校", "xmzj://b/v5/campus_transfer/home"),
            
            ("家校互动-通知管理", "xmzj://b/notification/list"),
            ("家校互动-课后点评", "xmzj://b/v5/comment/list"),
            ("家校互动-学习计划", "xmzj://b/v5/homework/record"),
            
            ("家校互动-成长档案", "xmzj://b/archive/list"),
            ("家校互动-学员书画馆", "flutter:///gallery/list"),
            ("家校互动-测评中心", "flutter:///evaluate/center"),
            
            // xmzj://b/h5?title=小麦秀&path=/hybird/index.html#show&close=1
            ("营销中心-小麦秀", "xmzj://b/h5?title=%E5%B0%8F%E9%BA%A6%E7%A7%80&path=%2Fhybird%2Findex.html%23show&close=1"),
            ("销售中心-线索管理", "https://dev-web-server.xiaomai5.com/ssr/crm/thread"),
            ("销售中心-续费预警", "xmzj://b/v5/renew_warning/list"),
            
            ("营销中心-小麦粒", "xmzj://b/v5/homework/record"),
            ("教务中心-订场核销", "flutter:///venue"),
            
            ("财务中心-充值管理", "xmzj://b/v5/recharge/manage"),
            ("财务中心-工资结算", "flutter:///salary/settlement/list"),
            
            ("财务中心-电子合同", "flutter:///electronic/contract/list"),
            
            // 总部
            ("我的-员工管理", "xmzj://c/v5/ka/staff/manage"),
            ("我的-课程管理", "xmzj://c/v5/ka/course/manage"),
        ]
        
        var failed: [(String, String)] = []
        
        func fire(with index: Int) {
            guard index < routes.count else {
                self.view.alpha = 1.0
                
                let str = "主路由执行 \(index) 条，失败 \(failed.count) 条：" + failed.reduce("", { res, next in
                    return res + "\n" + next.0 + ": " + next.1
                })
                let alert = UIAlertController(title: "执行结果", message: str, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: failed.count == 0 ? "很好" : "不好", style: .default))
                self.present(alert, animated: true)
                
                return
            }
            let data = routes[index]
            MainNavigator.XMPush(data.1, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let current = xmTopMost()
                let success = basic != current
                print("路由  \(data.0), success=\(success)")
                if success == false {
                    failed.append(data)
                }
                basic?.navigationController?.popViewController(animated: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    fire(with: index + 1)
                }
            }
        }
        
        let alert = UIAlertController(title: "提示", message: "路由连通性测试", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "不懂", style: .default))
        alert.addAction(UIAlertAction(title: "我懂", style: .default, handler: { _ in
            self.view.alpha = 0.0
            fire(with: 0)
        }))
        present(alert, animated: true)
    }
    
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
        viewModel.refreshState().done { names in
            let title = names.isEmpty ? "刷新成功，暂时没有新的任务完成" : ("恭喜你，成功完成了以下任务" + names.reduce("", { res, next in
                return res + ("、") + next
            }))
            
            let alert = UIAlertController(title: "提示", message: title, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                self.reloadTree()
            }))
            self.present(alert, animated: true)
        }.catch { error in
            if error.localizedDescription.count > 0 {
                self.view.makeToast(error.localizedDescription)
            }
        }
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
            view.makeToast(message)
        case .webOnly(message: let message):
            view.makeToast(message)
        case .oldVersion:
            view.makeToast("应用版本过低，请升级至最新版本")
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
            view.makeToast("未获取到任务指南数据")
        }
        
        // 主应用页面栈跳转
        if let url = routeUrl {
            DispatchQueue.main.asyncAfter(deadline: .now() + GuideAnimation.mainRouterDelay) {
                MainNavigator.XMPush(url, animated: true)
            }
        } else {
            // do nth.
        }
    }
    
    /// 手动确认完成
    private func manuallyEnsure(with model: GuideListCellModel) {
        switch model.jumpable {
        case .noPermission(message: let message):
            view.makeToast(message)
        default:  // 只检查权限
            let alert = UIAlertController(title: "提示", message: "任务将会被手动置为已完成状态，是否继续？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { [weak self] _ in
                self?.viewModel.manuallyEnsure(with: model.taskId).done { success in
                    self?.view.makeToast("修改" + (success ? "成功" : "失败"))
                    DispatchQueue.main.async {
                        self?.reloadTree()
                    }
                }.catch({ error in
                    if error.localizedDescription.count > 0 {
                        self?.view.makeToast(error.localizedDescription)
                    }
                })
            }))
            present(alert, animated: true)
        }
    }
}
