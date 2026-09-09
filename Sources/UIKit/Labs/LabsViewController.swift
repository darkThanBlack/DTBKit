//
//  BetaViewController.swift
//  XMSport
//
//  Created by moonShadow on 2025/7/31
//  Copyright © 2025 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// 实验性功能
    public final class LabsViewController: DTB.BaseViewController {
        
        private lazy var sections: [DTB.SectionModel] = {
            
            let hintCells = [
                DTB.CellModel(
                    data: DTB.SampleData(
                        title: .dtb.create("dtb.common.warning"),
                        detail: .dtb.create("dtb.deep.labs.desc"),
                        titleAttr: NSAttributedString(
                            string: .dtb.create("dtb.common.warning"),
                            attributes: .dtb.create
                                .foregroundColor(.dtb.create("dtb.warning"))
                                .font(.dtb.create(size: 17.0))
                                .value
                        ),
                    ),
                    style: DTB.ContainerStyle(
                        margin: UIEdgeInsets(top: 8.0, left: 16.0, bottom: 4.0, right: 16.0),
                        padding: UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0),
                        shape: DTB.ShapeStyle(
                            corners: [.allCorners],
                            radius: .fixed(12.0),
                            fillColor: .dtb.create("dtb.bg3"),
                            strokeColor: .dtb.create("dtb.warning"),
                            lineWidth: 1.0,
                        )
                    ),
                    extra: DTB.CrumbsType.tdi_arrow_1
                )
            ]
            
            let subCells: [DTB.CellModel] = [
                ("dtb.deep.disk",   "dtb.deep.disk.desc"),
                ("dtb.deep.i18n",   "dtb.deep.i18n.desc"),
                ("dtb.deep.color",  "dtb.deep.color.desc"),
                ("dtb.deep.crumbs", "dtb.deep.crumbs.desc"),
                ("dtb.deep.grid",   "dtb.deep.grid.desc"),
            ].compactMap({
                DTB.CellModel(
                    data: .init(primaryKey: $0.0, title: .dtb.create($0.0), detail: .dtb.create($0.1), showArrow: true),
                    style: .style("dtb.card"),
                    extra: DTB.CrumbsType.tdi_arrow_1
                )
            })
            
            return [
                DTB.SectionModel(cells: hintCells),
                DTB.SectionModel(cells: subCells)
            ]
        }()
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            setupNavigatonBar(with: .init(title: .dtb.create("dtb.deep.labs")))
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

extension DTB.LabsViewController: DTB.CrumbsSampleViewDelegate {
    
    public func listItemEvent(_ indexPath: IndexPath) {
        let key = sections.dtb[indexPath.section]?.cells.dtb[indexPath.row]?.data?.primaryKey
        switch key {
        case "dtb.deep.disk":
            let vc = DTB.DiskUsageViewController()
            navigationController?.pushViewController(vc, animated: true)
        case "dtb.deep.i18n":
            let vc = DTB.I18NViewController()
            navigationController?.pushViewController(vc, animated: true)
        case "dtb.deep.color":
            let vc = DTB.ColorViewController()
            navigationController?.pushViewController(vc, animated: true)
        case "dtb.deep.crumbs":
            let vc = DTB.CrumbsViewController()
            navigationController?.pushViewController(vc, animated: true)
        case "dtb.deep.grid":
            let vc = DTB.SelfSizingGridViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            DTB.console.error(key)
        }
    }
}
