//
//  DemoDefines.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/30
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    
import UIKit

///
extension DemoCellModel {
    
    enum CellType: String, CaseIterable {
        
        case edgeLabel, bundleImage, guide, webView, tableView
        
        var desc: String? {
            switch self {
            case .edgeLabel:  return "带内边距的 UILabel"
            default:
                return nil
            }
        }
    }
}

///
extension DemoSectionModel {
    
    enum SectionType: String, CaseIterable {
        
        case `default`
        
        var desc: String? {
            return nil
        }
        
        var cells: [DemoCellModel.CellType] {
            switch self {
            case .default:
                return DemoCellModel.CellType.allCases
            }
        }
    }
}

// MARK: -

///
class DemoEntry {
    
    ///
    func enter(_ type: DemoCellModel.CellType) {
        switch type {
        case .edgeLabel:
            SimpleVisualViewController.show(in: {
                let label = EdgeLabel()
                label.text = "Edge Label"
                label.textColor = .systemRed
                label.backgroundColor = .systemYellow
                label.edgeInsets = UIEdgeInsets(top: 4.0, left: 16.0, bottom: 8.0, right: 32.0)
                return label
            }, behavior: .center)
        case .bundleImage:
            SimpleVisualViewController.show(in: {
                let imageView = UIImageView()
                imageView.dtb.setImage(named: "logo", bundleName: "DTBKit-Basic", frameworkName: "DTBKit")
                return imageView
            }, behavior: .center)
        case .guide:
            Drift.shared.start()
        case .webView:
//            let vc = SimpleWebViewController()
//            Navigate.topMost()?.navigationController?.pushViewController(vc, animated: true)
            SimpleVisualViewController.show(in: {
                let enterView = GuideEnterView()
                enterView.closeable = true
                return enterView
            }, behavior: nil, layouter: { son, father in
                father.addSubview(son)
                son.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.left.equalToSuperview().offset(0)
                    make.right.equalToSuperview().offset(-0)
                }
            })
        case .tableView:
            let vc = SimpleTableViewController()
            DTB.topMost?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
