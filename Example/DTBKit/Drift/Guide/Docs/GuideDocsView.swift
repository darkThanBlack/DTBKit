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
import WebKit
import SnapKit

protocol GuideDocsViewDelegate: AnyObject {
    
    func closeEvent()
    
    func popEvent()
}

/// 新手引导 - 任务指南
class GuideDocsView: UIView {
    
    func load(url: String) {
        if let theUrl = URL(string: url) {
            DispatchQueue.main.async {
                self.webView.load(URLRequest(url: theUrl))
            }
        }
    }
    
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
        box.addSubview(webView)
        box.addSubview(popButton)
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(box.snp.top).offset(0)
            make.left.equalTo(box.snp.left).offset(16.0)
            make.right.equalTo(box.snp.right).offset(-16.0)
        }
        popButton.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.top.equalTo(webView.snp.bottom).offset(16.0)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(box.safeAreaLayoutGuide.snp.bottom).offset(-16.0)
            } else {
                make.bottom.equalTo(box.snp.bottom).offset(-16.0)
            }
            make.height.greaterThanOrEqualTo(22.0)
        }
    }
    
    private lazy var backgroundView: GuideContainerView = {
        let view = GuideContainerView()
        view.backgroundColor = .white
        
        view.title = "任务指南"
        view.closeEventHandler = { [weak self] in
            self?.delegate?.closeEvent()
        }
        return view
    }()
    
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = .all
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.backgroundColor = .white
//        webView.uiDelegate = self
//        webView.navigationDelegate = self
        return webView
    }()
    
    private lazy var popButton: UIButton = {
        let popButton = UIButton(type: .custom)
        popButton.setTitle("<— 返回任务列表", for: .normal)
        popButton.setTitleColor(DriftAdapter.color_FF8534(), for: .normal)
        popButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        popButton.addTarget(self, action: #selector(popButtonEvent(button:)), for: .touchUpInside)
        return popButton
    }()
}

