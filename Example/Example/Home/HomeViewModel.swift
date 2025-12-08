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

protocol DemoDescribable {
    var title: String? { get }
    var detail: String? { get }
}

struct DemoSectionModel {
    let type: SectionType
    let cells: [DemoCellModel]

    init(type: SectionType) {
        self.type = type
        self.cells = type.cells.map({ DemoCellModel(type: $0) })
    }
}

extension DemoSectionModel: DemoDescribable {
    var title: String? {
        return type.rawValue
    }

    var detail: String? {
        return type.desc
    }
}

struct DemoCellModel {
    let type: BaseCellType
}

extension DemoCellModel: DemoDescribable {
    var title: String? {
        return type.rawValue
    }

    var detail: String? {
        return type.desc
    }
}

class HomeViewModel {
    
}
