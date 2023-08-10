//
//  GuideRequests.swift
//  XMBundleLN
//
//  Created by moonShadow on 2023/8/9
//  Copyright © 2023 jiejing. All rights reserved.
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

/// 新手引导 - 请求整合
public class GuideRequests {
    
    // private let bag = DisposeBag()
    
    private lazy var provider = XMProvider<MultiTarget>()
    
    private let orgConfigType = Butterfly_Common.BizConfigTypeEnums.ORG_GUIDE_TASK_CONFIG
    
    private func getTenantId() -> Int64? {
        var tenantId: Int64? = UserSession.userInst?.instId
        if let orgId = UserSession.userCenterAdmin?.orgId {
            tenantId = orgId
        }
        return tenantId
    }
    
    private func getTenantType() -> Butterfly_Common.GuideTaskTenantTypeEnum {
        var tenantType: Butterfly_Common.GuideTaskTenantTypeEnum = .INST
        if let _ = UserSession.userCenterAdmin?.orgId {
            tenantType = .ORG
        }
        return tenantType
    }
    
    private var cacheKey: Int64? = nil
    
    private var progress: Butterfly_Business.ReceivedGuideTaskLineProgressVO? = nil
    
    /// 校区不同时更新
    func getTaskProgress(forced: Bool = false) -> Promise<Butterfly_Business.ReceivedGuideTaskLineProgressVO> {
        return Promise { seal in
            let tid = getTenantId()
            if forced == false,
               let data = progress,
               let key = cacheKey, key == tid {
                seal.fulfill(data)
                return
            }
            
            let params = QueryReceivedGuideTaskLineRequest(tenantId: tid, tenantType: getTenantType())
            let request = Butterfly_Business.GuideTaskInterface.queryReceivedLineProgress(request: params)
            let _ = provider.rx.makeRequest(MultiTarget(request)).mapObject(type: Butterfly_Business.ReceivedGuideTaskLineProgressVO.self).subscribe { result in
                self.progress = result
                self.cacheKey = tid
                
                seal.fulfill(result)
            } onError: { error in
                seal.reject(error)
            }
        }
    }
    
    /// 通过是否存在新手任务线判断业务本身是否可用
    /// 普通总部无新手任务
    public func isTaskable() -> Promise<Bool> {
        return getTaskProgress().map({ $0.hasLine == true })
//        return Promise { seal in
//            let params = QueryReceivedGuideTaskLineRequest(tenantId: getTenantId(), tenantType: getTenantType())
//            let request = Butterfly_Business.GuideTaskInterface.queryReceivedLineProgress(request: params)
//            let _ = provider.rx.makeRequest(MultiTarget(request)).mapObject(type: Butterfly_Business.ReceivedGuideTaskLineProgressVO.self).subscribe { result in
//                seal.fulfill(result.hasLine == true)
//            } onError: { error in
//                seal.reject(error)
//            }
//        }
    }
    
    //MARK: - 新手任务设置
    
    /// 设置 - 开关当前状态
    public func isGuideSettingOpened() -> Promise<Bool> {
        switch getTenantType() {
        case .INST:
            let params = CommonParamRequest(
                bizAccountId: UserSession.userInst?.adminId,
                instId: UserSession.userInst?.instId,
                version: .V_50,
                xmVersion: nil
            )
            let request = Butterfly_Business.InstConfigInterface.getUserGuideConfig(request: params)
            return Promise { seal in
                let _ = provider.rx.makeRequest(MultiTarget(request)).subscribe { result in
                    if let success = result as? Bool, success == true {
                        seal.fulfill(true)
                    } else {
                        seal.fulfill(false)
                    }
                } onError: { error in
                    seal.reject(error)
                }
            }
        case .ORG:
            let params = GetSingleConfigRequest(
                configType: orgConfigType,
                tenantId: getTenantId(),
                tenantType: .ORG
            )
            let request = Butterfly_Business.CommonConfigInterface.getSingle(request: params)
            return Promise { seal in
                let _ = provider.rx.makeRequest(MultiTarget(request)).mapObject(type: Butterfly_Business.CommonConfigVO.self).subscribe { result in
                    if result.configValue == "TRUE" {
                        seal.fulfill(true)
                    } else {
                        seal.fulfill(false)
                    }
                } onError: { error in
                    seal.reject(error)
                }
            }
        }
    }
    
    /// 所有任务完成
    public func isAllTaskFinished() -> Promise<Bool> {
        return getTaskProgress().map { result in
            let total = result.finishResult?.totalTaskNum ?? 0
            let current = result.finishResult?.finishedTaskNum ?? 0
            return current < total
        }
//        return Promise { seal in
//            let params = QueryReceivedGuideTaskLineRequest(tenantId: getTenantId(), tenantType: getTenantType())
//            let request = Butterfly_Business.GuideTaskInterface.queryReceivedLineProgress(request: params)
//            let _ = provider.rx.makeRequest(MultiTarget(request)).mapObject(type: Butterfly_Business.ReceivedGuideTaskLineProgressVO.self).subscribe { result in
//                let total = result.finishResult?.totalTaskNum ?? 0
//                let current = result.finishResult?.finishedTaskNum ?? 0
//                seal.fulfill(current < total)
//            } onError: { error in
//                seal.reject(error)
//            }
//        }
    }
    
    /// 设置 - 更新开关状态
    public func actualUpdateGuideSettingState(status: Bool) -> Promise<Bool> {
        switch getTenantType() {
        case .INST:
            let params = UpdateGuideConfigRequest(
                bizAccountId: UserSession.userInst?.adminId,
                instId: nil,
                status: status
            )
            let request = Butterfly_Business.InstConfigInterface.updateUserGuideConfig(request: params)
            return Promise { seal in
                let _ = provider.rx.makeRequest(MultiTarget(request)).subscribe { result in
                    if let success = result as? Bool, success == true {
                        seal.fulfill(true)
                    } else {
                        seal.fulfill(false)
                    }
                } onError: { error in
                    seal.reject(error)
                }
            }
        case .ORG:
            let params = ModifyOrgConfigStatusRequest(
                configType: orgConfigType,
                configValue: status,
                orgId: UserSession.userCenterAdmin?.orgId
            )
            let request = OrgConfigInterface.modifyOrgStatus(request: params)
            return Promise { seal in
                let _ = provider.rx.makeRequest(MultiTarget(request)).subscribe { result in
                    if let success = result as? Bool, success == true {
                        seal.fulfill(true)
                    } else {
                        seal.fulfill(false)
                    }
                } onError: { error in
                    seal.reject(error)
                }
            }
        }
    }
    
}
