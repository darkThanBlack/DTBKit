//
//  GuideListViewController.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/22
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

/// 新手引导 - 任务列表
class GuideListViewController: UIViewController {
    
    //MARK: Life Cycle
    
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
    
    private lazy var contentView: GuideListView = {
        let contentView = GuideListView()
        contentView.backgroundColor = .white
        contentView.delegate = self
        return contentView
    }()
}

extension GuideListViewController: GuideListViewDelegate {
    
    func closeEvent() {
        navigationController?.dismiss(animated: true)
    }
    
    func pushEvent() {
        let docsVC = GuideDocsViewController()
        navigationController?.pushViewController(docsVC, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            SimpleVisualViewController.show(in: {
                let label = EdgeLabel()
                label.text = "Edge Label"
                label.textColor = .systemRed
                label.backgroundColor = .systemYellow
                label.edgeInsets = UIEdgeInsets(top: 4.0, left: 16.0, bottom: 8.0, right: 32.0)
                return label
            }, behavior: .center)
        }
    }
}
