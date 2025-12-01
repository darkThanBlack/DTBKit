//
//  MineSimpleListView.swift
//  tarot
//
//  Created by moonShadow on 2025/11/19
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit
import DTBKit
import SnapKit

protocol MineSimpleListViewDelegate: AnyObject {
    
    func simpleListDidTapItemEvent(_ model: MineSimpleItemDelegate)
}

///
class MineSimpleListView: UIView {
    
    weak var delegate: MineSimpleListViewDelegate?
    
    private var itemModels: [MineSimpleItemDelegate] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 更新UI数据
    func update(_ list: [MineSimpleItemDelegate]) {
        // 清除现有items
        itemsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        itemModels = list

        // 创建新的UserInfoItemView
        for (index, model) in list.enumerated() {
            let itemView = MineSimpleItemView()
            itemView.update(model)

            // 添加点击手势
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(itemTapped(_:)))
            itemView.addGestureRecognizer(tapGesture)
            itemView.tag = index
            itemView.isUserInteractionEnabled = true

            itemsStackView.addArrangedSubview(itemView)

            // 设置高度约束
            itemView.snp.makeConstraints { make in
                make.height.equalTo(53)
            }
        }
    }

    private func setupUI() {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.06)
        self.layer.cornerRadius = 16
        
        self.addSubview(itemsStackView)

        itemsStackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    @objc private func itemTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedView = gesture.view,
              let index = itemsStackView.arrangedSubviews.firstIndex(where: { $0 == tappedView }),
              let model = itemModels.dtb[index] else {
            return
        }
        delegate?.simpleListDidTapItemEvent(model)
    }
    
    private lazy var itemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        return stackView
    }()
}
