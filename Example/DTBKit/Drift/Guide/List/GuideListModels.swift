//
//  GuideListModel.swift
//  XMBundleLN
//
//  Created by moonShadow on 2023/8/7
//  Copyright © 2023 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
class GuideListGroupModel: GuideGroupItemDataSource {
    
    var title: String?
    
    var isSelected: Bool
    
    var isLocked: Bool
    
    var isCompleted: Bool
    
    // - Custom
    
    /// node.id
    var groupId: Int64?
    
    var cells: [GuideListCellModel] = []
    
    init(groupId: Int64? = nil, title: String? = nil, isSelected: Bool = false, isLocked: Bool, isCompleted: Bool) {
        self.groupId = groupId
        self.title = title
        self.isSelected = isSelected
        self.isLocked = isLocked
        self.isCompleted = isCompleted
    }
    
    func mocks() {
        let model = GuideListCellModel(
            title: title,
            detail: UUID().uuidString,
            roles: "角色：老师，校长，etc...",
            inferTime: "耗时：5分钟",
            bizType: .finish
        )
        model.linkUrl = "https://www.baidu.com"
        model.jumpUrl = "dtb://custom/route?page=0"
        model.jumpable = .success
        
        cells = [
            model
        ] + GuideListCell.BizTypes.allCases.map({ bizType in
            return GuideListCellModel(
                title: "任务标题过长过长过长过长过长过长过长过长过长过长过长过长过长",
                detail: "任务说明过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长",
                roles: nil,
                inferTime: nil,
                bizType: bizType
            )
        })
    }
}

class GuideListCellModel: GuideListCellDataSource {
    
    var primaryKey: String? {
        return "\(taskId ?? 0)"
    }
    
    var title: String?
    
    var detail: String?
    
    var roles: String?
    
    var inferTime: String?
    
    /// 仅用于控制右侧视图展示
    var bizType: GuideListCell.BizTypes
    
    // - Custom
    
    var taskId: Int64?
    
    /// 指南展示 url
    var linkUrl: String?
    
    /// 主页面路由
    var jumpUrl: String?
    
    /// 仅用于判断主页面路由是否能够跳转
    enum JumpStates {
        ///
        case unknown
        /// 可跳转
        case success
        /// 无权限
        case noPermission(message: String?)
        /// 仅 web
        case webOnly(message: String?)
        /// 未解锁
        case locked
        /// 版本过低
        case oldVersion
    }
    /// 
    var jumpable: JumpStates = .unknown
    
    init(taskId: Int64? = nil, title: String? = nil, detail: String? = nil, roles: String? = nil, inferTime: String? = nil, bizType: GuideListCell.BizTypes) {
        self.taskId = taskId
        self.title = title
        self.detail = detail
        self.roles = roles
        self.inferTime = inferTime
        self.bizType = bizType
    }
}
