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
    case languages = "language_settings_title"
    case colors = "color_settings_title"
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

    func reloadData(completed: (() -> ())?) {
        self.items.forEach({ model in
            guard let key = SettingsItemKeys(rawValue: model.key ?? "") else {
                return
            }
            switch key {
            case .languages:
                model.detail = ExampleApp.SupportLanguages(key: DTB.I18NManager.shared.currentKey).localTitle
            case .colors:
                model.detail = ExampleApp.SupportColors(key: DTB.ColorManager.shared.currentKey).localTitle
            }
        })
        completed?()
    }
}
