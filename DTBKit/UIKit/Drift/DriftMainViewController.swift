//
//  DriftMainViewController.swift
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
public class DriftMainViewController: UIViewController {
    
    //MARK: Interface
    
    public lazy var drift: DriftView = {
        let driftView = DriftView()
        return driftView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .clear
        
        view.addSubview(drift)
        
        let driftSize = drift.sizeThatFits(UIScreen.main.bounds.size)
        let oldFrame: [String: CGFloat]? = Drift.defaults(getForKey: .driftedFrame)
        drift.frame = CGRect(
            x: oldFrame?["x"] ?? 0,
            y: oldFrame?["y"] ?? 0,
            width: driftSize.width,
            height: driftSize.height
        )
        drift.fireAbsorb()
    }
}
