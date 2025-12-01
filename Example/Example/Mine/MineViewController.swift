//
//  MineViewController.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2025/11/28
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

class MineViewController: BaseViewController {

    private lazy var viewModel = {
        let vm = MineViewModel()
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
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func reloadData() {
        self.contentView.update(self.viewModel.items)
    }

    private lazy var contentView = {
        let view = MineView()
        view.delegate = self
        return view
    }()
}

extension MineViewController: MineSimpleListViewDelegate {
    
    func simpleListDidTapItemEvent(_ model: any MineSimpleItemDelegate) {
        guard let key = MineItemKeys(rawValue: model.key ?? "") else {
            return
        }
        switch key {
        case .settings:
            let settingVC = SettingsViewController()
            navigationController?.pushViewController(settingVC, animated: true)
        case .other:
            break
            
        }
    }
    
}
