//
//  GuideRefreshView.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/31
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

protocol GuideRefreshViewDelegate: AnyObject {
    /// 刷新
    func guideListRefreshEvent()
}

/// 新手引导 - 列表刷新提示
class GuideRefreshView: UIView {
    
    weak var delegate: GuideRefreshViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func refreshButtonEvent(button: UIButton) {
        delegate?.guideListRefreshEvent()
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        hintLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        box.addSubview(hintLabel)
        box.addSubview(refreshLabel)
        box.addSubview(refreshImageView)
        box.addSubview(refreshButton)
        
        hintLabel.snp.makeConstraints { make in
            make.top.equalTo(box.snp.top).offset(10.0)
            make.left.equalTo(box.snp.left).offset(16.0)
            make.bottom.equalTo(box.snp.bottom).offset(-10.0)
        }
        refreshLabel.snp.makeConstraints { make in
            make.centerY.equalTo(hintLabel.snp.centerY)
            make.left.equalTo(hintLabel.snp.right).offset(2.0)
        }
        refreshImageView.snp.makeConstraints { make in
            make.centerY.equalTo(box.snp.centerY)
            make.left.equalTo(refreshLabel.snp.right).offset(2.0)
            make.right.greaterThanOrEqualTo(box.snp.right).offset(-16.0)
            make.width.height.equalTo(14.0)
        }
        refreshButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(box)
            make.left.equalTo(refreshLabel.snp.left).offset(0)
            make.right.equalTo(refreshImageView.snp.right).offset(-0)
        }
    }
    
    private lazy var hintLabel: UILabel = {
        let hintLabel = UILabel()
        hintLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        hintLabel.textColor = DriftAdapter.color_666666()
        hintLabel.text = "任务完成后，点击刷新了解最新进度~"
        return hintLabel
    }()
    
    private lazy var refreshLabel: UILabel = {
        let refreshLabel = UILabel()
        refreshLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        refreshLabel.textColor = DriftAdapter.color_FF8534()
        refreshLabel.text = "刷新"
        return refreshLabel
    }()
    
    private lazy var refreshImageView: UIImageView = {
        let refreshImageView = UIImageView()
        refreshImageView.image = DriftAdapter.imageNamed("guide_refresh")
        refreshImageView.contentMode = .scaleAspectFit
        return refreshImageView
    }()
    
    private lazy var refreshButton: UIButton = {
        let refreshButton = UIButton(type: .custom)
        refreshButton.backgroundColor = .clear
        refreshButton.addTarget(self, action: #selector(refreshButtonEvent(button:)), for: .touchUpInside)
        return refreshButton
    }()
}

