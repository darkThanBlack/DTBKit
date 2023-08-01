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

///
class GuideViewModel {
    
    private var groups: [GuideGroupModel] = []
    
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
    
    func mocks(completed: (()->())?) {
        self.groups = [
            GuideGroupModel(
                title: "Step 1.",
                isSelected: false,
                isLocked: false,
                isCompleted: true
            ),
            GuideGroupModel(
                title: "第二步",
                isSelected: false,
                isLocked: false,
                isCompleted: false
            ),
            GuideGroupModel(
                title: "第三步标题很长很长很长",
                isSelected: false,
                isLocked: false,
                isCompleted: false
            ),
            GuideGroupModel(
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

///
class GuideGroupModel: GuideGroupItemDataSource {
    
    let primaryKey: String = UUID().uuidString
    
    var title: String?
    
    var isSelected: Bool
    
    var isLocked: Bool
    
    var isCompleted: Bool
    
    var cells: [GuideListCellModel] = []
    
    init(title: String? = nil, isSelected: Bool, isLocked: Bool, isCompleted: Bool) {
        self.title = title
        self.isSelected = isSelected
        self.isLocked = isLocked
        self.isCompleted = isCompleted
        
        mocks()
    }
    
    func mocks() {
        cells = [
            GuideListCellModel(
                title: title,
                detail: primaryKey,
                roles: "角色：老师，校长，etc...",
                inferTime: "耗时：5分钟",
                bizType: .finish
            )
        ] + GuideListCell.BizTypes.allCases.map({ bizType in
            return GuideListCellModel(
                title: "任务标题过长过长过长过长过长过长过长过长过长过长过长过长过长",
                detail: "任务说明过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长过长",
                roles: "角色：老师，校长，etc...  过长过长过长过长过长过长过长过长过长过长过长",
                inferTime: "耗时：5分钟 过长过长过长过长过长",
                bizType: bizType
            )
        })
    }
}

class GuideListCellModel: GuideListCellDataSource {
    
    var primaryKey: String? = UUID().uuidString
    
    var title: String?
    
    var detail: String?
    
    var roles: String?
    
    var inferTime: String?
    
    var bizType: GuideListCell.BizTypes
    
    init(primaryKey: String? = nil, title: String? = nil, detail: String? = nil, roles: String? = nil, inferTime: String? = nil, bizType: GuideListCell.BizTypes) {
        self.primaryKey = primaryKey
        self.title = title
        self.detail = detail
        self.roles = roles
        self.inferTime = inferTime
        self.bizType = bizType
    }
}
