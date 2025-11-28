//
//  CustomTabBar.swift
//  Example
//
//  Created by moonShadow on 2025/10/23
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

/// 自定义 TabBar 视图
class CustomTabBar: UIVisualEffectView {
    
    private var selectedIndex: Int = 0 {
        didSet {
            updateSelectedState()
        }
    }

    var onItemSelected: ((Int) -> Void)?
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        setupSubviews(in: contentView)
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func selectItem(at index: Int) {
        selectedIndex = index
    }

    // MARK: - Private Methods
    
    private func setupSubviews(in box: UIView) {
        // 启用用户交互
        isUserInteractionEnabled = true

        // 设置 StackView
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard bounds.size.width > 0 else {
            return
        }
        layer.cornerRadius = bounds.size.height / 2.0
        layer.masksToBounds = true
    }
    
    // 首页 Tab 项
    private lazy var homeItem = {
        let item = CustomTabBarItem()
        item.update(
            unSelectImageName: "home_unselect",
            selectedImageName: "home_select"
        )
        item.onTapped = { [weak self] in
            self?.handleItemTap(index: 0)
        }
        return item
    }()
    
    // 个人中心 Tab 项
    private lazy var profileItem = {
        let item = CustomTabBarItem()
        item.update(
            unSelectImageName: "mine_unselect",
            selectedImageName: "mine_select"
        )
        item.onTapped = { [weak self] in
            self?.handleItemTap(index: 1)
        }
        return item
    }()
    
    private lazy var stackView = {
        let stack = UIStackView(arrangedSubviews: [homeItem, profileItem])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    private func handleItemTap(index: Int) {
        print("CustomTabBar handleItemTap called with index: \(index)")
        selectedIndex = index
        onItemSelected?(index)
    }

    private func updateSelectedState() {
        for (index, view) in stackView.arrangedSubviews.enumerated() {
            if let item = view as? CustomTabBarItem {
                item.isSelected = (index == selectedIndex)
            }
        }
    }
}
