//
//  CellModel.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/29
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    public final class CellModel {
        
        public var data: DTB.CellData?
        
        public var style: DTB.CellStyle?
        
        public var extra: Any? = nil
        
        public init(
            data: DTB.CellData? = nil,
            style: DTB.CellStyle? = nil,
            extra: Any? = nil
        ) {
            self.data = data
            self.style = style
            self.extra = extra
        }
    }
}
