//
//  GuideListView.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/24
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit
import SnapKit

protocol GuideListViewDelegate: GuideGroupViewDelegate, GuideRefreshViewDelegate {
    ///
    func closeEvent()
    ///
    func pushEvent()
}

/// 新手引导 - 任务列表
class GuideListView: UIView {
    
    weak var delegate: GuideListViewDelegate? {
        didSet {
            self.groupView.delegate = delegate
            self.refreshView.delegate = delegate
        }
    }
    
    ///
    func setupItems(with datas: [GuideGroupItemDataSource]) {
        groupView.setupItems(with: datas)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        loadViews(in: backgroundView.contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeButtonEvent(button: UIButton) {
        delegate?.closeEvent()
    }
    
    @objc private func pushButtonEvent(button: UIButton) {
        delegate?.pushEvent()
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(titleLabel)
        box.addSubview(hintLabel)
        box.addSubview(groupView)
        box.addSubview(pushButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(box.snp.top).offset(0)
            make.left.equalTo(box.snp.left).offset(16.0)
            make.right.equalTo(box.snp.right).offset(-16.0)
        }
        hintLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2.0)
            make.left.equalTo(box.snp.left).offset(16.0)
            make.right.equalTo(box.snp.right).offset(-16.0)
        }
        groupView.snp.makeConstraints { make in
            make.top.equalTo(hintLabel.snp.bottom).offset(0)
            make.left.right.equalTo(box)
            make.height.equalTo(48.0)
        }
        pushButton.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.centerY.equalTo(box.snp.centerY)
        }
    }
    
    private lazy var backgroundView: GuideContainerView = {
        let view = GuideContainerView()
        view.backgroundColor = .white
        
        view.closeEventHandler = { [weak self] in
            self?.delegate?.closeEvent()
        }
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        titleLabel.textColor = DriftAdapter.color_333333()
        return titleLabel
    }()
    
    private lazy var hintLabel: UILabel = {
        let hintLabel = UILabel()
        hintLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        hintLabel.textColor = DriftAdapter.color_999999()
        hintLabel.numberOfLines = 2
        return hintLabel
    }()
    
    private lazy var groupView: GuideGroupView = {
        let groupView = GuideGroupView()
        return groupView
    }()
    
    private lazy var refreshView: GuideRefreshView = {
        let refreshView = GuideRefreshView()
        return refreshView
    }()
    
    private lazy var pushButton: UIButton = {
        let pushButton = UIButton(type: .custom)
        pushButton.backgroundColor = .green
        pushButton.setTitle("push", for: .normal)
        pushButton.addTarget(self, action: #selector(pushButtonEvent(button:)), for: .touchUpInside)
        return pushButton
    }()
}
