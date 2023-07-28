//
//  GuideDocsViewController.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/24
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// 新手引导 - 任务指南
class GuideDocsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        loadViews(in: view)
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(contentView)
        [contentView].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: box.leftAnchor, constant: 0.0),
            contentView.rightAnchor.constraint(equalTo: box.rightAnchor, constant: 0.0),
            contentView.bottomAnchor.constraint(equalTo: box.bottomAnchor, constant: 0.0),
            
            contentView.heightAnchor.constraint(equalTo: box.heightAnchor, multiplier: 0.9)
        ])
    }
    
    private lazy var contentView: GuideDocsView = {
        let contentView = GuideDocsView()
        contentView.backgroundColor = .white
        contentView.delegate = self
        return contentView
    }()
}

extension GuideDocsViewController: GuideDocsViewDelegate {
    
    func closeEvent() {
        navigationController?.dismiss(animated: true)
    }
    
    func popEvent() {
        navigationController?.popViewController(animated: true)
    }
}
