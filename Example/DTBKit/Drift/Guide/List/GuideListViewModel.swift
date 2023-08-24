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
    
    func mocks2(completed: (()->())?) {
        self.groups = [
            GuideListGroupModel(
                title: "Step 1.",
                isSelected: false,
                isLocked: false,
                isCompleted: true
            )
        ]
        self.groups.first?.isSelected = true
        
        self.groups.forEach({ $0.mocks() })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completed?()
        }
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
        ] + [
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
        
        self.groups.forEach({ $0.mocks() })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            completed?()
        }
    }
}
