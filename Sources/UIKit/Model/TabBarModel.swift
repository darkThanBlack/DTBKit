//
//  TabBarModel.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/25
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    public struct TabBarModel: TabBarData {
        
        public var backgroundColor: UIColor
        
        public var unSelectTintColor: UIColor
        
        public var selectedTintColor: UIColor
        
        public init(backgroundColor: UIColor, unSelectTintColor: UIColor, selectedTintColor: UIColor) {
            self.backgroundColor = backgroundColor
            self.unSelectTintColor = unSelectTintColor
            self.selectedTintColor = selectedTintColor
        }
    }
}
