//
//  ColorSettingsViewController.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2025/12/1
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

class ColorSettingsViewController: BaseViewController {

    private lazy var viewModel = {
        let vm = ColorSettingsViewModel()
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
        loadNavigation(title: .dtb.create("color_settings_title"))

        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(0)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func reloadData() {
        viewModel.reloadData { [weak self] in
            self?.contentView.update(self?.viewModel.items ?? [])
        }
    }

    private lazy var contentView = {
        let view = LanguageSettingsView()
        view.delegate = self
        return view
    }()
}

extension ColorSettingsViewController: MineSimpleListViewDelegate {

    func simpleListDidTapItemEvent(_ model: any MineSimpleItemDelegate) {
        viewModel.didSelect(key: model.key)
    }
}
