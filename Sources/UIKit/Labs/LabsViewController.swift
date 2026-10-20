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
        
        /// 条目：只存数据
        private struct Item {
            
            /// 跳转标识
            let key: String
            
            let title: String
            
            let detail: String
        }
        
        private let items: [Item] = [
            Item(key: "dtb.deep.disk",   title: .dtb.create("dtb.deep.disk"),   detail: .dtb.create("dtb.deep.disk.desc")),
            Item(key: "dtb.deep.i18n",   title: .dtb.create("dtb.deep.i18n"),   detail: .dtb.create("dtb.deep.i18n.desc")),
            Item(key: "dtb.deep.color",  title: .dtb.create("dtb.deep.color"),  detail: .dtb.create("dtb.deep.color.desc")),
            Item(key: "dtb.deep.sample", title: .dtb.create("dtb.deep.sample"), detail: .dtb.create("dtb.deep.sample.desc")),
        ]
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            setupNavigatonBar(with: .init(title: .dtb.create("dtb.deep.labs")))
            loadViews(in: view)
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
            
            contentStack.addArrangedSubview(makeHintCard())
            
            items.enumerated().forEach { index, item in
                contentStack.addArrangedSubview(makeArrowCard(item, tag: index))
            }
        }
        
        /// 顶部警示卡：样式在代码里拼（非 json）
        private func makeHintCard() -> UIView {
            let row = DTB.LabsArrowRow()
            row.update(
                title: nil,
                titleAttr: NSAttributedString(
                    string: .dtb.create("dtb.common.warning"),
                    attributes: .dtb.create
                        .foregroundColor(.dtb.create("dtb.warning"))
                        .font(.dtb.create(size: 17.0))
                        .value
                ),
                detail: .dtb.create("dtb.deep.labs.desc"),
                showArrow: false
            )
            
            return DTB.Container(
                child: row,
                style: DTB.ContainerStyle(
                    margin: UIEdgeInsets(top: 8.0, left: 16.0, bottom: 16.0, right: 16.0),
                    padding: UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0),
                    shape: DTB.ShapeStyle(
                        corners: [.allCorners],
                        radius: .fixed(12.0),
                        fillColor: .dtb.create("dtb.bg3"),
                        strokeColor: .dtb.create("dtb.warning"),
                        lineWidth: 1.0
                    )
                )
            )
        }
        
        /// 普通行：`dtb.card` 卡片 + 尾部箭头
        private func makeArrowCard(_ item: Item, tag: Int) -> UIView {
            let row = DTB.LabsArrowRow()
            row.update(title: item.title, detail: item.detail, showArrow: true)
            
            let card = DTB.Container(child: row, style: .style("dtb.card"))
            card.tag = tag
            card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(listItemEvent(_:))))
            return card
        }
        
        // MARK: - 跳转
        
        @objc private func listItemEvent(_ sender: UITapGestureRecognizer) {
            guard let item = items.dtb[sender.view?.tag] else {
                DTB.console.error(sender.view?.tag)
                return
            }
            
            switch item.key {
            case "dtb.deep.disk":
                navigationController?.pushViewController(DTB.DiskUsageViewController(), animated: true)
            case "dtb.deep.i18n":
                navigationController?.pushViewController(DTB.I18NViewController(), animated: true)
            case "dtb.deep.color":
                navigationController?.pushViewController(DTB.ColorViewController(), animated: true)
            case "dtb.deep.sample":
                navigationController?.pushViewController(DTB.SampleViewController(), animated: true)
            default:
                DTB.console.error(item.key)
            }
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
