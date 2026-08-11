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

extension DTB {
    
    /// 展示对国际化字符串的控制
    public final class I18NViewController: DTB.BaseViewController {
        
        private lazy var sections: [DTB.SectionModel] = {
            
            /// primaryKey 和实际的语言标志符对应
            var cells: [DTB.CellModel] = [
                .init(
                    data: .init(primaryKey: nil, title: .dtb.create("deep.follow_system")),
                    style: .style("card_top")
                ),
                .init(
                    data: .init(primaryKey: "en", title: "English"),
                    style: .style("card_mid")
                ),
                .init(
                    data: .init(primaryKey: "zh", title: "简体中文"),
                    style: .style("card_bottom")
                )
            ]
            
            // 样式
            cells.forEach({ $0.extra = DTB.CrumbsType.tdi_select_1 })
            
            // 当前选中状态
            let idx = cells.firstIndex(where: { $0.data?.primaryKey == DTB.I18NManager.shared.currentKey }) ?? 0
            cells[idx].data?.isSelected = true
            
            return [
                DTB.SectionModel(cells: cells)
            ]
        }()
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            setupNavigatonBar(with: .init(title: .dtb.create("deep.i18n")))
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


extension DTB.I18NViewController: DTB.CrumbsSampleViewDelegate {
    
    public func listItemEvent(_ indexPath: IndexPath) {
        guard let data = sections.dtb[indexPath.section]?.cells.dtb[indexPath.row]?.data else { return }
        
        let title: String = {
            switch data.primaryKey {
            case "en":  return "Hint"
            case "zh":  return "提示"
            default:    return .dtb.create("common.hint")
            }
        }()
        
        let message: String = {
            switch data.primaryKey {
            case "en":  return "Switching languages requires restarting APP. Continue?"
            case "zh":  return "切换语言需要重启 APP，是否继续？"
            default:    return .dtb.create("deep.i18n.ensure")
            }
        }()
        
        let cancel: String = {
            switch data.primaryKey {
            case "en":  return "Cancel"
            case "zh":  return "取消"
            default:    return .dtb.create("common.cancel")
            }
        }()
        
        let ensure: String = {
            switch data.primaryKey {
            case "en":  return "Ensure"
            case "zh":  return "确定"
            default:    return .dtb.create("common.ensure")
            }
        }()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancel, style: .default))
        alert.addAction(UIAlertAction(title: ensure, style: .default, handler: { _ in
            DTB.I18NManager.shared.update(key: data.primaryKey)
            NotificationCenter.default.post(name: DTB.Notifications.appNeedRestart, object: nil)
        }))
        self.present(alert, animated: true)
    }
}
