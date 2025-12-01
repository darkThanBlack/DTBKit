//
//  MineViewModel.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2025/12/1
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

enum MineItemKeys: String, CaseIterable {
    case settings = "settings_title"
    case other = "other"
}

/// 个人中心 ViewModel
class MineViewModel {
    
    private(set) lazy var items: [MineSimpleItemModel] = MineItemKeys.allCases.map({
        MineSimpleItemModel(
            key: $0.rawValue,
            title: .dtb.create($0.rawValue),
            detail: nil,
            showRightArrow: true
        )
    })
    
    init() {}
}
