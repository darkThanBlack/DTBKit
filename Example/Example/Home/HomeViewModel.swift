//
//  HomeViewModel.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2025/12/8
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB.SimpleSectionModel: HomeSectionHeaderData {
    
    var title: String? {
        return header?.title
    }
    
    var detail: String? {
        return header?.detail
    }
}

extension DTB.SimpleModel: HomeCellData {}

///
class HomeViewModel {
    
    var sections: [DTB.SimpleSectionModel] = [
        .init(
            header: .init(title: "Core", detail: "pod 'DTBKit/Core'"),
            cells: DemoMenu.CoreTypes.allCases.compactMap(
                { type in
                    return .init(
                        primaryKey: type.rawValue,
                        title: .dtb.create("menu_\(type.rawValue)"),
                        desc: .dtb.create("menu_\(type.rawValue)_detail"),
                        jumpable: true
                    )
                })
        ),
        .init(
            header: .init(title: "Other", detail: ""),
            cells: DemoMenu.OtherTypes.allCases.compactMap(
                { type in
                    return .init(
                        primaryKey: type.rawValue,
                        title: .dtb.create("menu_\(type.rawValue)"),
                        desc: .dtb.create("menu_\(type.rawValue)_detail"),
                        jumpable: true
                    )
                })
        )
    ]
}
