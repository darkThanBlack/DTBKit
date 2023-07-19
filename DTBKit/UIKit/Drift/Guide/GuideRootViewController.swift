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
class GuideRootViewController: UIViewController {
    
    //MARK: Interface
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        view.addSubview(contentView)
        
        loadViews(in: view)
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        
        loadConstraints(in: box)
    }
    
    private func loadConstraints(in box: UIView) {
        
    }
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    
}

