//
//  CrumbsViewController.swift
//  Ring
//
//  Created by moonShadow on 2026/6/16
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    ///
    public final class CrumbsViewController: DTB.BaseViewController {
        
        private lazy var sections: [DTB.SectionModel] = {
            
            let sampleData = DTB.SampleData(
                primaryKey: nil,
                leftImage: .init(image: .dtb.local("moonphase.waxing.crescent")),
                title: nil,
                detail: "detail",
                desc: "desc",
                tags: ["tag1", "tag2"],
                titleAttr: nil,
                detailAttr: nil,
                showArrow: true,
                jumpable: true,
                selectable: true,
                isSelected: true,
                editable: true,
                extra: nil
            )
            
            var result: [DTB.CellModel] = []
            var cells: [DTB.CellModel] = DTB.CrumbsType.allCases.compactMap { type in
                sampleData.title = type.rawValue
                return DTB.CellModel(
                    data: sampleData,
                    style: .singleCard(),
                    extra: type
                )
            }
            (0..<100).forEach({ _ in result.append(contentsOf: cells) })
            
            return [
                DTB.SectionModel(cells: result)
            ]
        }()
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            setupNavigatonBar(with: .init(title: .dtb.create("deep.crumbs")))
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

extension DTB.CrumbsViewController: DTB.CrumbsSampleViewDelegate {
    
    public func listItemEvent(_ indexPath: IndexPath) {
        guard let cell = sections.dtb[indexPath.section]?.cells.dtb[indexPath.row] else {
            return
        }
        DTB.console.log(cell.extra)
    }
    
}
