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

extension DTB {
    
    /// 展示对主题颜色的控制
    public final class ColorViewController: DTB.BaseViewController {
        
        private lazy var sections: [DTB.SectionModel] = {
            let cells: [DTB.CellModel] = [
                .init(
                    data: .init(primaryKey: nil, title: .dtb.create("deep.follow_system")),
                    style: .style("card_top")
                ),
                .init(
                    data: .init(primaryKey: "light", title: .dtb.create("deep.color.light")),
                    style: .style("card_mid")
                ),
                .init(
                    data: .init(primaryKey: "dark", title: .dtb.create("deep.color.dark"), detail: .dtb.create("deep.color.dark.desc")),
                    style: .style("card_mid")
                ),
                .init(
                    data: .init(primaryKey: "auto_dark", title: .dtb.create("deep.color.dark.auto"), detail: .dtb.create("deep.color.dark.auto.desc")),
                    style: .style("card_bottom")
                ),
            ]
            
            // 样式
            cells.forEach({ $0.extra = DTB.CrumbsType.tdi_select_1 })
            
            // 当前选中状态
            switch DTB.ColorManager.shared.currentMode ?? .followSystem {
            case .followSystem, .custom:
                cells[0].data?.isSelected = true
            case .light: cells[1].data?.isSelected = true
            case .dark: cells[2].data?.isSelected = true
            case .autoDark: cells[3].data?.isSelected = true
            }
            
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
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            setupNavigatonBar(with: .init(title: .dtb.create("deep.color")))
            loadViews(in: view)
        }
        
        public override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            contentView.updateSection(sections)
        }
        
        // MARK: - View
        
        private func loadViews(in box: UIView) {
            box.addSubview(contentView)
            contentView.snp.makeConstraints { make in
                make.top.equalTo(customNavigationBar.snp.bottom).offset(0)
                make.left.right.bottom.equalTo(box.safeAreaLayoutGuide)
            }
        }
        
        private lazy var contentView: DTB.CrumbsSampleView = {
            let view = DTB.CrumbsSampleView()
            view.backgroundColor = .clear
            view.delegate = self
            return view
        }()
    }
    
}

extension DTB.ColorViewController: DTB.CrumbsSampleViewDelegate {
    
    public func listItemEvent(_ indexPath: IndexPath) {
        guard let data = sections.dtb[indexPath.section]?.cells.dtb[indexPath.row]?.data else { return }
        let alert = UIAlertController(title: .dtb.create("common.hint"), message: .dtb.create("deep.color.ensure"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .dtb.create("common.cancel"), style: .default))
        alert.addAction(UIAlertAction(title: .dtb.create("common.ensure"), style: .default, handler: { _ in
            switch data.primaryKey {
            case "light":
                DTB.ColorManager.shared.update(mode: .light)
            case "dark":
                DTB.ColorManager.shared.update(mode: .dark)
            case "auto_dark":
                DTB.ColorManager.shared.update(mode: .autoDark)
            default:
                DTB.ColorManager.shared.update(mode: .followSystem)
            }
            NotificationCenter.default.post(name: DTB.Notifications.appNeedRestart, object: nil)
        }))
        self.present(alert, animated: true)
    }
}
