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
        
        /// 条目：只存数据
        private struct Item {
            
            /// 与 ``DTB.I18NManager/currentKey`` 对应；nil = follow system
            let key: String?
            
            let title: String
            
            /// 分组卡片样式（首/尾圆角不同）
            let cardStyle: String
        }
        
        private let items: [Item] = [
            Item(
                key: nil,
                title: .dtb.create("dtb.deep.follow_system"),
                cardStyle: "dtb.card_top"
            ),
            Item(
                key: "en",
                title: "English",
                cardStyle: "dtb.card_mid"
            ),
            Item(
                key: "zh",
                title: "简体中文",
                cardStyle: "dtb.card_bottom"
            ),
        ]
        
        /// 行视图：刷新选中态用
        private var rows: [DTB.LabsSelectRow] = []
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            setupNavigatonBar(with: .init(title: .dtb.create("dtb.deep.i18n")))
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
                row.update(title: item.title, detail: nil, isSelected: false)
                rows.append(row)
                
                let card = DTB.Container(child: row, style: .style(item.cardStyle))
                card.tag = index
                card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(listItemEvent(_:))))
                contentStack.addArrangedSubview(card)
            }
        }
        
        /// 当前选中项（跟随 ``DTB.I18NManager`` 的实际状态）
        private func refreshSelection() {
            let current = DTB.I18NManager.shared.currentKey
            let selected = items.firstIndex(where: { $0.key == current }) ?? 0
            
            rows.enumerated().forEach { index, row in
                guard let item = items.dtb[index] else { return }
                row.update(title: item.title, detail: nil, isSelected: (index == selected))
            }
        }
        
        // MARK: - 事件
        
        @objc private func listItemEvent(_ sender: UITapGestureRecognizer) {
            guard let item = items.dtb[sender.view?.tag] else { return }
            
            let title: String = {
                switch item.key {
                case "en":  return "Hint"
                case "zh":  return "提示"
                default:    return .dtb.create("dtb.common.hint")
                }
            }()
            
            let message: String = {
                switch item.key {
                case "en":  return "Switching languages requires restarting APP. Continue?"
                case "zh":  return "切换语言需要重启 APP，是否继续？"
                default:    return .dtb.create("dtb.deep.i18n.ensure")
                }
            }()
            
            let cancel: String = {
                switch item.key {
                case "en":  return "Cancel"
                case "zh":  return "取消"
                default:    return .dtb.create("dtb.common.cancel")
                }
            }()
            
            let ensure: String = {
                switch item.key {
                case "en":  return "Ensure"
                case "zh":  return "确定"
                default:    return .dtb.create("dtb.common.ensure")
                }
            }()
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: cancel, style: .default))
            alert.addAction(UIAlertAction(title: ensure, style: .default, handler: { _ in
                DTB.I18NManager.shared.update(key: item.key)
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
