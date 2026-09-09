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
    
    private lazy var sections: [DTB.SectionModel] = {
        let keys = [
            "dtb.setting.about",
            "dtb.deep.labs",
            "dtb.login",
            "dtb.user.logout"
        ]
        
        var cells: [DTB.CellModel] = keys.compactMap({
            .init(
                data: .init(primaryKey: $0, title: .dtb.create($0), showArrow: true),
                style: .style("dtb.card_mid")
            )
        })
        cells.first?.style = .style("dtb.card_top")
        cells.last?.style = .style("dtb.card_bottom")
        return [
            DTB.SectionModel(cells: cells)
        ]
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .dtb.create("dtb.bg")
        
        setupNavigatonBar(with: .init(title: "设置"))
        loadViews(in: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.updateSection(sections)
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
    
    func listItemEvent(_ data: DTB.SampleData) {
        if data.primaryKey == "dtb.setting.about" {
            let vc = AboutUsViewController()
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        if data.primaryKey == "dtb.deep.labs" {
            let vc = DTB.LabsViewController()
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        if data.primaryKey == "dtb.login" {
            let vc = LoginViewController()
            let nav = DTB.SystemNavigationController(rootViewController: vc)
            present(nav, animated: true)
            return
        }
        if data.primaryKey == "dtb.user.logout" {
            UserManager.shared.logout()
            return
        }

        DTB.console.error(data.primaryKey)
    }
}
