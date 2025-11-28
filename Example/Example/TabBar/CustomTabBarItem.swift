//
//  CustomTabBarItem.swift
//  Example
//
//  Created by moonShadow on 2025/10/23
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// 自定义 TabBar 按钮项
class CustomTabBarItem: UIView {
    
    var isSelected: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    var onTapped: (() -> Void)?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(unSelectImageName: String? = nil, selectedImageName: String? = nil) {
        if let name = unSelectImageName {
            unSelectView.image = UIImage(named: name)
        }
        if let name = selectedImageName {
            selectView.image = UIImage(named: name)
        }
    }
    
    private func setupUI() {
        // 启用用户交互
        isUserInteractionEnabled = true
        
        addSubview(unSelectView)
        addSubview(selectView)
        
        unSelectView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        selectView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        print("CustomTabBarItem handleTap called")
        onTapped?()
    }
    
    private func updateAppearance() {
        if isSelected {
            // 选中状态：显示渐变图标
            unSelectView.isHidden = true
            selectView.isHidden = false
        } else {
            // 未选中状态：显示普通图标
            unSelectView.isHidden = false
            selectView.isHidden = true
        }
    }
    
    
    private lazy var unSelectView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var selectView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
}
