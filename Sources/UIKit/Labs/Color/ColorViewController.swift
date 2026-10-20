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
        
        /// 条目：只存数据
        private struct Item {
            
            /// 与 ``DTB.ColorManager/Mode`` 对应；nil = follow system
            let key: String?
            
            let title: String
            
            let detail: String?
            
            /// 分组卡片样式（首/尾圆角不同）
            let cardStyle: String
        }
        
        private let items: [Item] = [
            Item(
                key: nil,
                title: .dtb.create("dtb.deep.follow_system"),
                detail: nil,
                cardStyle: "dtb.card_top"
            ),
            Item(
                key: "light",
                title: .dtb.create("dtb.deep.color.light"),
                detail: nil,
                cardStyle: "dtb.card_mid"
            ),
            Item(
                key: "dark",
                title: .dtb.create("dtb.deep.color.dark"),
                detail: .dtb.create("dtb.deep.color.dark.desc"),
                cardStyle: "dtb.card_mid"
            ),
            Item(
                key: "auto_dark",
                title: .dtb.create("dtb.deep.color.dark.auto"),
                detail: .dtb.create("dtb.deep.color.dark.auto.desc"),
                cardStyle: "dtb.card_bottom"
            ),
        ]
        
        /// 行视图：刷新选中态用
        private var rows: [DTB.LabsSelectRow] = []
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            setupNavigatonBar(with: .init(title: .dtb.create("dtb.deep.color")))
            loadViews(in: view)
        }
        
        public override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            refreshSelection()
        }
        
        // MARK: - View
        
        private func loadViews(in box: UIView) {
            box.addSubview(scrollView)
            scrollView.addSubview(contentStack)
            
            scrollView.snp.makeConstraints { make in
                make.top.equalTo(customNavigationBar.snp.bottom)
                make.left.right.bottom.equalTo(box.safeAreaLayoutGuide)
            }
            /// 左右留白由 card style 的 margin 自带，stack 不再 inset
            contentStack.snp.makeConstraints { make in
                make.edges.equalTo(scrollView)
                make.width.equalTo(scrollView.snp.width)
            }
            
            for (index, item) in items.enumerated() {
                let row = DTB.LabsSelectRow()
                row.update(title: item.title, detail: item.detail, isSelected: false)
                rows.append(row)
                
                let card = DTB.Container(child: row, style: .style(item.cardStyle))
                card.tag = index
                card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(listItemEvent(_:))))
                contentStack.addArrangedSubview(card)
            }
        }
        
        /// 当前选中项（跟随 ``DTB.ColorManager`` 的实际状态）
        private func refreshSelection() {
            let selected: Int = {
                switch DTB.ColorManager.shared.currentMode ?? .followSystem {
                case .followSystem, .custom:
                    return 0
                case .light:
                    return 1
                case .dark:
                    return 2
                case .autoDark:
                    return 3
                }
            }()
            
            rows.enumerated().forEach { index, row in
                guard let item = items.dtb[index] else { return }
                row.update(title: item.title, detail: item.detail, isSelected: (index == selected))
            }
        }
        
        // MARK: - 事件
        
        @objc private func listItemEvent(_ sender: UITapGestureRecognizer) {
            guard let item = items.dtb[sender.view?.tag] else { return }
            
            let alert = UIAlertController(title: .dtb.create("dtb.common.hint"), message: .dtb.create("dtb.deep.color.ensure"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: .dtb.create("dtb.common.cancel"), style: .default))
            alert.addAction(UIAlertAction(title: .dtb.create("dtb.common.ensure"), style: .default, handler: { _ in
                switch item.key {
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
            present(alert, animated: true)
        }
        
        // MARK: - 懒加载
        
        private lazy var scrollView: UIScrollView = {
            let sv = UIScrollView()
            sv.alwaysBounceVertical = true
            sv.showsVerticalScrollIndicator = false
            return sv
        }()
        
        private lazy var contentStack: UIStackView = {
            let s = UIStackView()
            s.axis = .vertical
            s.alignment = .fill
            s.distribution = .fill
            s.spacing = 0.0
            return s
        }()
    }
    
}
