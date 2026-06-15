//
//  I18NViewController.swift
//  XMSport
//
//  Created by moonShadow on 2024/2/3
//  Copyright © 2024 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

class I18NViewController: DTB.BaseViewController {
    
    private lazy var sections: [DTB.SectionModel] = {
        var cells: [DTB.CellModel] = [
            .init(
                data: .init(primaryKey: "deep.i18n.follow", title: .dtb.create("deep.i18n.follow"), isSelected: false),
                style: .init(container: .card(.isFirst))
            ),
            .init(
                data: .init(primaryKey: "en", title: "English", isSelected: false),
                style: .init(container: .card())
            ),
            .init(
                data: .init(primaryKey: "zh", title: "简体中文", isSelected: false),
                style: .init(container: .card(.isLast))
            )
        ]
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
    
    deinit {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .dtb.create("bg")
        
        setupNavigatonBar(with: .init(title: .dtb.create("deep.i18n")))
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
    
    private lazy var contentView: I18NView = {
        let view = I18NView()
        view.backgroundColor = .clear
        view.delegate = self
        return view
    }()
}

extension I18NViewController: I18NViewDelegate {
    
    func listItemEvent(_ data: DTBKit.DTB.CellData) {
        // TODO: change & restart
        //        I18nManager.shared.update(language: value)
        //        DTB.app.restart()
        
        sections.first?.cells.forEach({
            $0.data?.isSelected = $0.data?.primaryKey == data.primaryKey
        })
        contentView.updateSection(sections)
    }
}
