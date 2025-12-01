//
//  MineView.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2025/12/1
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

class MineView: UIView {
    
    weak var delegate: MineSimpleListViewDelegate? {
        didSet {
            listView.delegate = delegate
        }
    }
    
    func update(_ list: [MineSimpleItemDelegate]) {
        listView.update(list)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(16.0)
            make.leading.trailing.equalTo(self).inset(16)
            make.bottom.lessThanOrEqualTo(self.snp.bottom).offset(-16.0)
        }
    }
    
    private lazy var listView = {
        let view = MineSimpleListView()
        view.backgroundColor = .dtb.create("background_card")
        return view
    }()
}
