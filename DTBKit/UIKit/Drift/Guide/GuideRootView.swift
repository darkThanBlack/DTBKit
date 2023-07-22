//
//  GuideRootView.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/19
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// Restrict drift in safe area
public class GuideRootView: UIView {
    
    //MARK: Interface
    
    //MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        driftView.fireAbsorb()
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(driftView)
        
        let driftSize = driftView.sizeThatFits(bounds.size)
        let oldFrame: [String: CGFloat]? = Drift.defaults(getForKey: .driftedFrame)
        driftView.frame = CGRect(
            x: oldFrame?["x"] ?? 0,
            y: oldFrame?["y"] ?? 0,
            width: driftSize.width,
            height: driftSize.height
        )
    }
    
    private lazy var driftView: GuideDriftView = {
        let driftView = GuideDriftView()
        return driftView
    }()
}

