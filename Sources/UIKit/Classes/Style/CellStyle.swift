//
//  CellModel.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/26
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    public struct CellStyle: CellUI {
        
        public var container: (any DTB.ContainerUI)?
        
        public var separator: (any DTB.SeparatorUI)?
        
        public init(container: (any DTB.ContainerUI)? = nil, separator: (any DTB.SeparatorUI)? = nil) {
            self.container = container
            self.separator = separator
        }
    }
}
