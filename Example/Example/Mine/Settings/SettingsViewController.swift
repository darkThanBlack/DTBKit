//
//  SettingsViewController.swift
//  tarot
//
//  Created by Claude on 2025/11/19
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//

import UIKit

/// 设置页面
class SettingsViewController: BaseViewController {

    private lazy var viewModel = {
        let vm = SettingsViewModel()
        return vm
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        reloadData()
    }
    
    private func setupUI() {
        loadNavigation(title: .dtb.create("settings_title"))

        view.addSubview(settingsView)
        settingsView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(0)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func reloadData() {
        view.dtb.showHUD()
        viewModel.reloadData().done {
            // do nth.
        }.catch { error in
            self.view.dtb.toast(error.localizedDescription)
        }.finally {
            self.view.dtb.hideHUD()
            self.settingsView.update(self.viewModel.items)
        }
    }

    private lazy var settingsView = {
        let view = SettingsView()
        view.delegate = self
        return view
    }()
}

extension SettingsViewController: MineSimpleListViewDelegate {
    
    func simpleListDidTapItemEvent(_ model: any MineSimpleItemDelegate) {
        guard let key = SettingsItemKeys(rawValue: model.key ?? "") else {
            return
        }
        switch key {
        case .linkedAccount:
            handleLinkedAccount()
        case .languages:
            handleLanguages()
        }
    }
    
    // MARK: - Item Actions

    private func handleLinkedAccount() {
        let accountLinkingVC = AccountLinkingViewController()
        navigationController?.pushViewController(accountLinkingVC, animated: true)
    }

    private func handleLanguages() {
        let languageVC = LanguageSettingsViewController()
        navigationController?.pushViewController(languageVC, animated: true)
    }
}
