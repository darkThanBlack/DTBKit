//
//  MineViewController.swift
//  Ring
//
//  Created by moonShadow on 2026/5/18
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

class MineViewController: UIViewController, DTB.SimpleNavigationBarHandler {
    
    lazy var customNavigationBar = DTB.SimpleNavigationBar()
    
    private let viewModel = MineViewModel()
    
    private lazy var header = MineHeaderViewModel(
        avatar: DTB.ImageData(
            remoteUrl: "https://avatars.githubusercontent.com/u/8111265?s=400&u=6af1720f3aa8f2457f4b063f523094127ef1c67e&v=4"
        ),
        name: "moon",
        roles: ["teacher", "student"],
        device: "device_id: "
    )
    
    private let items: [ArrowRow.Item] = [
        ArrowRow.Item(key: "dtb.setting", title: .dtb.create("dtb.setting")),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidesBottomBarWhenPushed = false
        
        view.backgroundColor = .dtb.create("dtb.bg")
        
        loadViews(in: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.updateHeader(header)
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
            make.top.left.right.bottom.equalTo(box.safeAreaLayoutGuide)
        }
    }
    
    private lazy var backgroundImageView = UIImageView().dtb
        .contentMode(.scaleToFill)
        .image(.dtb.local("background01"))
        .value
    
    private lazy var contentView: MineView = {
        let view = MineView()
        view.backgroundColor = .clear
        view.delegate = self
        return view
    }()
}

extension MineViewController: MineViewDelegates {
    
    func mineHeaderViewAvatarEvent() {
        
    }
    
    func mineHeaderViewDeviceEvent() {
        
    }
    
    func listItemEvent(_ index: Int) {
        guard let item = items.dtb[index] else { return }
        
        switch item.key {
        case "dtb.setting":
            let vc = SettingViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            DTB.console.error(item.key)
        }
    }
}
