//
//  DemoNavigationView.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/30
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    
import UIKit

///
class DemoNavigationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func backButtonEvent(button: UIButton) {
        DTB.Navigate.popAnyway()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backButton.sizeToFit()
        backButton.center = CGPoint(
            x: 16.0 + backButton.bounds.midX,
            y: bounds.midY
        )
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(backButton)
    }
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        backButton.setTitleColor(UIColor.systemBlue, for: .normal)
        backButton.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.6), for: .highlighted)
        backButton.addTarget(self, action: #selector(backButtonEvent(button:)), for: .touchUpInside)
        return backButton
    }()
}

