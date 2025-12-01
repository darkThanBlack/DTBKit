//
//  ColorSettingsViewModel.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2025/12/1
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

class ColorSettingsViewModel {
    
    private(set) lazy var items: [MineSimpleItemModel] = ExampleApp.SupportColors.allCases.map({
        MineSimpleItemModel(key: $0.key, title: $0.localTitle)
    })
    
    init() {}
    
    func reloadData(completion: (() -> ())?) {
        self.items.forEach({ model in
            model.isSelected = model.key == DTB.ColorManager.shared.currentKey
        })
        completion?()
    }
    
    func didSelect(key: String?) {
        
        func showAlert(completion: ((Result<Void, Error>) -> ())?) {
            DTB.alert()
                .title(.dtb.create("common_hint"))
                .message(.dtb.create("color_settings_hint"))
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
                DTB.ColorManager.shared.update(key: key)
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
