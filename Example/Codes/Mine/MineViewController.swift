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
    
    lazy var customNavigationBar = DTBKit.DTB.SimpleNavigationBar()
    
    private let viewModel = MineViewModel()
    
    private lazy var header = MineHeaderViewModel(
        avatar: DTB.ImageModel(
            remoteUrl: "https://avatars.githubusercontent.com/u/8111265?s=400&u=6af1720f3aa8f2457f4b063f523094127ef1c67e&v=4"
        ),
        name: "moon",
        roles: ["teacher", "student"],
        device: "device_id: "
    )
    
    private lazy var sections: [DTB.SectionModel] = {
        return [
            DTB.SectionModel(
                cells: [
                    .init(
                        data: .init(primaryKey: "setting", title: .dtb.create("setting"), showArrow: true),
                        style: .init(container: .card(.onlyOne))
                    )
                ]
            )
        ]
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidesBottomBarWhenPushed = false
        
        view.backgroundColor = .dtb.create("bg")
        
        loadViews(in: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.updateHeader(header)
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
    
    func listItemEvent(_ data: DTBKit.DTB.CellData) {
        if data.primaryKey == "setting" {
            let vc = SettingViewController()
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        DTB.console.error(data.primaryKey)
    }
}
