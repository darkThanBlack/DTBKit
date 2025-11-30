//
//  SettingsViewModel.swift
//  tarot
//
//  Created by Claude on 2025/11/19
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//

import Foundation

enum SettingsItemKeys: String, CaseIterable {
    case linkedAccount = "user_info_linking_title"
    case languages = "language_settings_title"
}

/// 设置页面 ViewModel
class SettingsViewModel {
    
    private(set) lazy var items: [MineSimpleItemModel] = SettingsItemKeys.allCases.map({
        MineSimpleItemModel(
            key: $0.rawValue,
            title: .dtb.create($0.rawValue),
            detail: nil,
            showRightArrow: true
        )
    })
    
    init() {}

    func reloadData() -> Promise<Void> {
        return Promise<Void> { seal in
            self.items.forEach({ model in
                guard let key = SettingsItemKeys(rawValue: model.key ?? "") else {
                    return
                }
                switch key {
                case .linkedAccount:
                    model.detail = nil
                case .languages:
                    model.detail = nil
                }
            })
            seal.fulfill(())
        }
    }
}
