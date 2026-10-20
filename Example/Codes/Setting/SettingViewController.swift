//
//  SettingViewController.swift
//  XMSport
//
//  Created by moonShadow on 2024/2/3
//  Copyright © 2024 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

class SettingViewController: DTB.BaseViewController {
    
    private let items: [ArrowRow.Item] = [
        ArrowRow.Item(key: "dtb.setting.about", title: .dtb.create("dtb.setting.about")),
        ArrowRow.Item(key: "dtb.deep.labs", title: .dtb.create("dtb.deep.labs")),
        ArrowRow.Item(key: "dtb.login", title: .dtb.create("dtb.login")),
        ArrowRow.Item(key: "dtb.user.logout", title: .dtb.create("dtb.user.logout")),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .dtb.create("dtb.bg")
        
        setupNavigatonBar(with: .init(title: "设置"))
        loadViews(in: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.update(items: items)
    }
    
    // MARK: - View
    
    private func loadViews(in box: UIView) {
        box.addSubview(backgroundImageView)
        box.addSubview(contentView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(box)
            make.height.equalTo(backgroundImageView.snp.width)
        }
        contentView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(0)
            make.left.right.bottom.equalTo(box.safeAreaLayoutGuide)
        }
    }
    
    private lazy var backgroundImageView = UIImageView().dtb
        .contentMode(.scaleToFill)
        .image(.dtb.local("background01"))
        .value
    
    private lazy var contentView: SettingView = {
        let view = SettingView()
        view.backgroundColor = .clear
        view.delegate = self
        return view
    }()
}

extension SettingViewController: SettingViewDelegate {
    
    func listItemEvent(_ index: Int) {
        guard let item = items.dtb[index] else { return }
        
        switch item.key {
        case "dtb.setting.about":
            let vc = AboutUsViewController()
            navigationController?.pushViewController(vc, animated: true)
        case "dtb.deep.labs":
            let vc = DTB.LabsViewController()
            navigationController?.pushViewController(vc, animated: true)
        case "dtb.login":
            let vc = LoginViewController()
            let nav = DTB.SystemNavigationController(rootViewController: vc)
            present(nav, animated: true)
        case "dtb.user.logout":
            UserManager.shared.logout()
        default:
            DTB.console.error(item.key)
        }
    }
}
