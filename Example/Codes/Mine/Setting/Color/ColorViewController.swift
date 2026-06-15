//
//  ColorViewController.swift
//  XMSport
//
//  Created by moonShadow on 2024/2/3
//  Copyright © 2024 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

class ColorViewController: DTB.BaseViewController {
    
    private lazy var sections: [DTB.SectionModel] = {
        let keys = [
            "deep.i18n.follow",
            "light_mode",
            "dark_mode"
        ]
        
        var cells: [DTB.CellModel] = keys.compactMap({
            .init(
                data: .init(primaryKey: $0, title: .dtb.create($0), isSelected: false),
                style: .init(container: .card())
            )
        })
        cells.first?.style = .init(container: .card(.isFirst))
        cells.last?.style = .init(container: .card(.isLast))
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
        
        setupNavigatonBar(with: .init(title: .dtb.create("deep.theme")))
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
    
    private lazy var contentView: ColorView = {
        let view = ColorView()
        view.backgroundColor = .clear
        view.delegate = self
        return view
    }()
}

extension ColorViewController: ColorViewDelegate {
    
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
