//
//  DiskUsageView.swift
//  XMSport
//
//  Created by moonShadow on 2025/6/27
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

protocol DiskCacheEventsDelegate: DiskCacheHintViewDelegate, AnyObject {
    
    ///
    func diskCacheRefreshButtonEvent()
}

/// 存储空间
class DiskUsageView: UIView {
    
    weak var delegate: DiskCacheEventsDelegate? {
        didSet {
            hintView.delegate = delegate
            cacheStack.arrangedSubviews.forEach({ item in
                if let hintView = item as? DiskCacheHintView {
                    hintView.delegate = delegate
                }
            })
        }
    }
    
    func reloadUsage(by data: DiskUsageProgressViewDataSource & DiskUsageHintViewDataSource) {
        progressView.update(data)
        hintView.update(data)
    }
    
    func reloadCaches(by list: [DiskCacheHintViewDataSource]) {
        if cacheStack.arrangedSubviews.count != list.count {
            cacheStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
            
            list.forEach { data in
                let hintView = DiskCacheHintView()
                hintView.backgroundColor = .white
                hintView.layer.masksToBounds = true
                hintView.layer.cornerRadius = 5.0
                
                hintView.delegate = self.delegate
                cacheStack.addArrangedSubview(hintView)
            }
        }
        
        for (index, data) in list.enumerated() {
            guard index < cacheStack.arrangedSubviews.count,
                  let hintView = cacheStack.arrangedSubviews[index] as? DiskCacheHintView else {
                continue
            }
            hintView.update(data)
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
        box.addSubview(progressView)
        box.addSubview(hintView)
        box.addSubview(cacheStack)
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(box.snp.top).offset(16.0)
            make.left.equalTo(box.snp.left).offset(16.0)
            make.right.equalTo(box.snp.right).offset(-16.0)
        }
        hintView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(32.0)
            make.left.equalTo(box.snp.left).offset(16.0)
            make.right.equalTo(box.snp.right).offset(-16.0)
        }
        cacheStack.snp.makeConstraints { make in
            make.top.equalTo(hintView.snp.bottom).offset(16.0)
            make.left.equalTo(box.snp.left).offset(16.0)
            make.right.equalTo(box.snp.right).offset(-16.0)
            make.bottom.lessThanOrEqualTo(box.snp.bottom).offset(-16.0)
        }
    }
    
    private lazy var stacks: UIStackView = {
        let stacks = UIStackView(arrangedSubviews: [
            progressView,
            hintView
        ])
        stacks.axis = .vertical
        stacks.alignment = .center
        stacks.distribution = .equalSpacing
        stacks.spacing = 8.0
        return stacks
    }()
    
    private lazy var progressView = {
        let view = DiskUsageProgressView()
        return view
    }()
    
    private lazy var hintView = {
        let view = DiskUsageHintView()
        return view
    }()
    
    private lazy var cacheStack: UIStackView = {
        let stacks = UIStackView()
        stacks.axis = .vertical
        stacks.alignment = .fill
        stacks.distribution = .equalSpacing
        stacks.spacing = 8.0
        return stacks
    }()
}

