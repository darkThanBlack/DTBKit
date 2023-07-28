//
//  GuideDocsView.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/27
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit
import SnapKit

protocol GuideDocsViewDelegate: AnyObject {
    
    func closeEvent()
    
    func popEvent()
}

/// 新手引导 - 任务指南
class GuideDocsView: UIView {
    
    weak var delegate: GuideDocsViewDelegate?
    
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
    
    @objc private func popButtonEvent(button: UIButton) {
        delegate?.popEvent()
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(popButton)
        
        popButton.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.centerY.equalTo(box.snp.centerY)
        }
    }
    
    private lazy var backgroundView: GuideContainerView = {
        let view = GuideContainerView()
        view.title = "任务指南"
        view.closeEventHandler = { [weak self] in
            self?.delegate?.closeEvent()
        }
        return view
    }()
    
    private lazy var popButton: UIButton = {
        let popButton = UIButton(type: .custom)
        popButton.backgroundColor = .green
        popButton.setTitle("pop", for: .normal)
        popButton.addTarget(self, action: #selector(popButtonEvent(button:)), for: .touchUpInside)
        return popButton
    }()
}

