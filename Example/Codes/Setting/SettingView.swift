//
//  SettingView.swift
//  Ring
//
//  Created by moonShadow on 2026/5/29
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

///
protocol SettingViewDelegate: AnyObject {
    
    func listItemEvent(_ index: Int)
}

/// 我的
class SettingView: UIView {
    
    weak var delegate: SettingViewDelegate?
    
    private var items: [ArrowRow.Item] = []
    
    /// 更新条目
    ///
    /// 列表很短（个位数），每次直接重建，不做 diff。
    func update(items: [ArrowRow.Item]) {
        self.items = items
        
        contentStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        for (index, item) in items.enumerated() {
            contentStack.addArrangedSubview(
                ArrowRow.card(
                    title: item.title,
                    index: index,
                    count: items.count,
                    target: self,
                    action: #selector(listItemEvent(_:))
                )
            )
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        /// 左右留白由 card style 的 margin 自带，stack 不再 inset
        contentStack.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    //MARK: 事件
    
    @objc private func listItemEvent(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag, items.dtb[index] != nil else {
            return
        }
        delegate?.listItemEvent(index)
    }
    
    //MARK: 懒加载
    
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
