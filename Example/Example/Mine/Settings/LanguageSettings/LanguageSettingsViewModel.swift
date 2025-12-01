//
//  LanguageSettingsViewModel.swift
//  tarot
//
//  Created by Claude on 2025/11/19
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//

import UIKit

/// 多语言设置 ViewModel
class LanguageSettingsViewModel {
    
    private(set) lazy var items: [MineSimpleItemModel] = ExampleApp.SupportLanguages.allCases.map({
        MineSimpleItemModel(key: $0.key, title: $0.localTitle)
    })
    
    init() {}
    
    func reloadData(completion: (() -> ())?) {
        self.items.forEach({ model in
            model.isSelected = model.key == DTB.I18NManager.shared.currentKey
        })
        completion?()
    }
    
    func didSelect(key: String?) {
        
        func showAlert(completion: ((Result<Void, Error>) -> ())?) {
            DTB.alert()
                .title(.dtb.create("common_hint"))
                .message(.dtb.create("language_settings_hint"))
                .addAction(.init(title: .dtb.create("common_cancel"), handler: { _ in
                    completion?(.failure(NSError.dtb.ignore()))
                }))
                .addAction(.init(title: .dtb.create("common_continue"), handler: { _ in
                    completion?(.success(()))
                }))
                .show()
        }
        
        showAlert { result in
            switch result {
            case .success:
                DTB.I18NManager.shared.update(key: key)
                // restart APP
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    NotificationCenter.default.post(name: AppDelegate.restartNotificationKey, object: nil)
                }
            case .failure:
                break
            }
        }
    }
}
