//
//  GuideListViewModel.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/31
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

import Moya
import RxSwift
import PromiseKit
import Butterfly_Common
import Butterfly_Business

///
class GuideListViewModel {
    
    private var groups: [GuideListGroupModel] = []
    
    var groupList: [GuideGroupItemDataSource] {
        return groups
    }
    
    var cellList: [GuideListCellDataSource] {
        return groups.first(where: { $0.isSelected })?.cells ?? []
    }
    
    func select(group: Int? = nil) {
        groups.first(where: { $0.isSelected })?.isSelected = false
        var index = group ?? 0
        index = (index < groups.count) ? index : 0
        groups[index].isSelected = true
    }
    
    func getCountsText() -> String? {
        let finishCount = cellList.filter({ $0.bizType == .finish }).count
        return "已完成 " + "\(finishCount)" + "/" + "\(cellList.count)"
    }
    
    func getCellModel(by key: String?) -> GuideListCellModel? {
        return groups.first(where: {
            $0.isSelected
        })?.cells.first(where: {
            $0.primaryKey == key
        })
    }
    
    // MARK: - Data
    
    private let bag = DisposeBag()
    
    private lazy var provider = XMProvider<MultiTarget>(
//        plugins: [RequestAnimatorPlugin(parentView: self.parentView, style: .hud)]
    )
    
    private func getOperatorId() -> Int64? {
        var tenantId: Int64? = UserSession.userInst?.adminId
        if let adminId = UserSession.userCenterAdmin?.orgAdminId {
            tenantId = adminId
        }
        return tenantId
    }
    
    private func getTenantId() -> Int64? {
        var tenantId: Int64? = UserSession.userInst?.instId
        if let orgId = UserSession.userCenterAdmin?.orgId {
            tenantId = orgId
        }
        return tenantId
    }
    
    private func getTenantType() -> Butterfly_Common.GuideTaskTenantTypeEnum? {
        var tenantType: Butterfly_Common.GuideTaskTenantTypeEnum = .INST
        if let _ = UserSession.userCenterAdmin?.orgId {
            tenantType = .ORG
        }
        return tenantType
    }
    
    /// 请求 - 任务树
    func treeRequest() -> Promise<Void> {
        return Promise { seal in
            let param = Butterfly_Business.GetGuideTaskLineTreeRequest(operatorId: getOperatorId(), tenantId: getTenantId(), tenantType: getTenantType())
            let request = Butterfly_Business.GuideTaskInterface.getTaskLineTree(request: param)
            provider.rx.makeRequest(MultiTarget(request)).mapObject(type: Butterfly_Business.GuideTaskLineTreeBizVO.self).subscribe { result in
                self.groups = result.nodes?.compactMap({ vo in
                    return GuideListGroupModel.parse(node: vo)
                }) ?? []
                self.groups.first?.isSelected = true
                seal.fulfill()
            } onError: { error in
                seal.reject(error)
            }.disposed(by: bag)
        }
    }
    
    /// 请求 - 手动刷新
    public func refreshState() -> Promise<[String]> {
        return Drift.shared.request.getTaskProgress().then { progress in
            return Promise<[Butterfly_Business.GuideTaskVO]> { seal in
                let group = self.groups.first(where: { $0.isSelected }) ?? self.groups.first
                let params = RefreshGuideTaskRequest(
                    lineSnapshotId: progress.lineSnapshotId,
                    parentId: group?.groupId,
                    receiverId: self.getOperatorId(),
                    taskLineId: progress.taskLineId
                )
                let request = Butterfly_Business.GuideTaskInterface.refreshGuideTask(request: params)
                self.provider.rx.makeRequest(MultiTarget(request)).mapArray(type: Butterfly_Business.GuideTaskVO.self).subscribe { result in
                    seal.fulfill(result)
                } onError: { error in
                    seal.reject(error)
                }.disposed(by: self.bag)
            }
        }.map { tasks in
            return tasks.compactMap({ $0.taskName })
        }
    }
    
    /// 请求 - 手动确认
    func manuallyEnsure(with taskId: Int64?) -> Promise<Bool> {
        return Drift.shared.request.getTaskProgress().then { progress in
            return Promise<Bool> { seal in
                let params = SubmitGuideTaskRequest(
                    lineSnapshotId: progress.lineSnapshotId,
                    memo: nil,
                    operatorId: self.getOperatorId(),
                    receiveRecordId: progress.receiveRecordId,
                    taskId: taskId,
                    taskLineId: progress.taskLineId,
                    taskOutCome: nil,
                    tenantId: self.getTenantId(),
                    tenantType: self.getTenantType()
                )
                let request = Butterfly_Business.GuideTaskInterface.submitTask(request: params)
                self.provider.rx.makeRequest(MultiTarget(request)).subscribe { result in
                    if let success = result as? Bool, success == true {
                        seal.fulfill(true)
                    }
                    seal.fulfill(false)
                } onError: { error in
                    seal.reject(error)
                }.disposed(by: self.bag)
            }
        }.map({ $0 })
    }
    
    func mocks(completed: (()->())?) {
        self.groups = [
            GuideListGroupModel(
                title: "Step 1.",
                isSelected: false,
                isLocked: false,
                isCompleted: true
            ),
            GuideListGroupModel(
                title: "第二步",
                isSelected: false,
                isLocked: false,
                isCompleted: false
            ),
            GuideListGroupModel(
                title: "第三步标题很长很长很长",
                isSelected: false,
                isLocked: false,
                isCompleted: false
            ),
            GuideListGroupModel(
                title: "第四步",
                isSelected: false,
                isLocked: true,
                isCompleted: false
            ),
        ]
        self.groups.first?.isSelected = true
        DispatchQueue.main.async {
            print("MOON__Log lazy...")
            completed?()
        }
    }
}

extension GuideListGroupModel {
    
    /// 解析 - 根节点
    static func parse(node vo: Butterfly_Business.GuideTaskTreeNodeBizVO?) -> GuideListGroupModel? {
        let model = GuideListGroupModel(
            groupId: vo?.id,
            title: vo?.groupName,
            isLocked: vo?.taskState == .NOT_ACTIVE,
            isCompleted: vo?.taskState == .FINISH
        )
        model.cells = vo?.child?.compactMap({ vo in
            return GuideListCellModel.parse(node: vo)
        }) ?? []
        return model
    }
}

extension GuideListCellModel {
    
    /// 解析 - 子节点，无需递归
    static func parse(node vo: Butterfly_Business.GuideTaskTreeNodeBizVO?) -> GuideListCellModel? {
        let task = vo?.guideTask
        let appTerm = task?.appTerm ?? task?.terms?.first(where: { $0.term == .APP })
        let webTerm = task?.webTerm ?? task?.terms?.first(where: { $0.term == .PC })
        /// 展示用
        let term = appTerm ?? webTerm
        
        ///
        func roleName(by value: TaskExecutorRoleEnum?) -> String {
            guard let v = value else { return "" }
            switch v {
              case .EDUCATIONAL_ADMINISTRATION:  return "教务"
              case .FINANCE:                     return "财务"
              case .LEARNING_MANAGEMENT:         return "学管师"
              case .LECTURER:                    return "任课老师"
              case .MARKET:                      return "市场"
              case .PRINCIPAL:                   return "校长"
              case .RECEPTION:                   return "前台"
              case .SALE:                        return "销售"
            }
        }
        var roles = task?.executors?.reduce("", { res, next in
            let dot = res.isEmpty ? "" : "、"
            return res + dot + roleName(by: next)
        }) ?? ""
        if roles.isEmpty == true {
            roles = "暂无"
        }
        
        var inferTime = task?.relativeTime ?? "暂无"
        if inferTime.contains("耗时") == false {
            inferTime = "耗时：" + inferTime
        }
        
        var bizType: GuideListCell.BizTypes
        switch vo?.taskState ?? .NOT_ACTIVE {
        case .FINISH:
            bizType = .finish
        case .NOT_ACTIVE:
            bizType = .locked
        case .VERIFY:
            bizType = .approve
        case .READY, .SEE:
            if appTerm == nil {
                bizType = .webOnly
            } else {
                switch vo?.confirmWay ?? .AUTO {
                case .AUTO, .MARKET:
                    bizType = .pushable
                case .USER:
                    bizType = .manually
                }
            }
        }
        
        let model = GuideListCellModel(
            taskId: vo?.taskId,
            title: task?.taskName,
            detail: term?.taskDesc,
            roles: roles,
            inferTime: inferTime,
            bizType: bizType
        )
        
        model.linkUrl = appTerm?.guideTaskPoints?.first?.linkUrl
        
        let jumper = appTerm?.jumpInfo?.mappedUrls?.first(where: { ($0.term == .IOS) || ($0.term == .IOS_LIVE_CLIENT) })
        model.jumpUrl = jumper?.url
        
        var jumpFail: GuideListCellModel.JumpStates? = nil
        // 检查 - 仅 web
        func checkWebOnly() -> GuideListCellModel.JumpStates? {
            guard appTerm == nil else {
                return nil
            }
            let str = (bizType == .webOnly) ? "完成" : "查看"
            return .webOnly(message: "请前往 web 端\(str)该任务")
        }
        if jumpFail == nil {
            jumpFail = checkWebOnly()
        }
        
        // 检查 - 版本号
        func checkVersion() -> GuideListCellModel.JumpStates? {
            let versionCheck = AppConfigure.shared.versions.ver.versionComparison(min: jumper?.version, max: nil)
            if versionCheck == false {
                return .oldVersion
            }
            return nil
        }
        if jumpFail == nil {
            jumpFail = checkVersion()
        }
        
        // 检查 - 权限点
        func checkPermission() -> GuideListCellModel.JumpStates? {
//            let failedPers = task?.permissions?.filter({ p in
//                guard let code = p.code else {
//                    return false
//                }
//                if UserSession.checkNewSaasPermissions(permissionCodes: [code], type: .adminGroup) {
//                    return false
//                }
//                if UserSession.checkNewSaasPermissions(permissionCodes: [code], type: .centerAdminGroup) {
//                    return false
//                }
//                return true
//            })
//
//            let message = failedPers?.reduce("", { res, next in
//                let dot = res.isEmpty ? "" : "、"
//                return res + dot + (next.name ?? "")
//            })
            
            let message = task?.missingPermissions?.reduce("", { res, next in
                let dot = res.isEmpty ? "" : "、"
                return res + dot + (next.name ?? "")
            })
            
            if let str = message, str.isEmpty == false {
                return .noPermission(message: "暂无【\(str)】权限，请联系管理员（主账号）")
            }
            return nil
        }
        if jumpFail == nil {
            jumpFail = checkPermission()
        }
        model.jumpable = jumpFail ?? .success
        
        return model
    }
}
