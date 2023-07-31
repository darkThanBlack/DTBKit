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
    
    var groupList: [GuideGroupItemDataSource] {
        return groups
    }
    
    private var groups: [GuideGroupModel] = []
    
    func select(group: Int? = nil) {
        if let index = group, index < groups.count {
            groups.first(where: { $0.isSelected })?.isSelected = false
            groups[index].isSelected = true
        }
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
    
    init(title: String? = nil, isSelected: Bool, isLocked: Bool, isCompleted: Bool) {
        self.title = title
        self.isSelected = isSelected
        self.isLocked = isLocked
        self.isCompleted = isCompleted
    }
}
