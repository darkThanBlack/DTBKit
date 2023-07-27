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

protocol GuideListViewDelegate: AnyObject {
    ///
    func closeEvent()
    ///
    func pushEvent()
}

///
class GuideListView: UIView {
    
    weak var delegate: GuideListViewDelegate?
    
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
        
        box.addSubview(pushButton)
        pushButton.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.centerY.equalTo(box.snp.centerY)
        }
    }
    
    private lazy var backgroundView: GuideContainerView = {
        let view = GuideContainerView()
        view.closeEventHandler = { [weak self] in
            self?.delegate?.closeEvent()
        }
        return view
    }()
    
    private lazy var pushButton: UIButton = {
        let pushButton = UIButton(type: .custom)
        pushButton.backgroundColor = .green
        pushButton.setTitle("push", for: .normal)
        pushButton.addTarget(self, action: #selector(pushButtonEvent(button:)), for: .touchUpInside)
        return pushButton
    }()
}
