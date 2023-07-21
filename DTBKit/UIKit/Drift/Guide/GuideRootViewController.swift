//
//  GuideRootViewController.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/19
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
public class GuideRootViewController: UIViewController {
    
    //MARK: Interface
    
    //MARK: Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .clear
        
        view.addSubview(contentView)
        
        loadViews(in: view)
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(contentView)
        
        loadConstraints(in: box)
    }
    
    private func loadConstraints(in box: UIView) {
        [contentView].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        if #available(iOS 11.0, *) {
            contentView.topAnchor.constraint(equalTo: box.safeAreaLayoutGuide.topAnchor, constant: 0.0).isActive = true
            contentView.bottomAnchor.constraint(equalTo: box.safeAreaLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
        } else {
            contentView.topAnchor.constraint(equalTo: box.topAnchor, constant: 0.0).isActive = true
            contentView.bottomAnchor.constraint(equalTo: box.bottomAnchor, constant: 0.0).isActive = true
        }
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: box.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: box.rightAnchor),
        ])
    }
    
    ///
    private lazy var contentView: GuideRootView = {
        let contentView = GuideRootView()
        contentView.backgroundColor = .yellow
        return contentView
    }()
    
}

