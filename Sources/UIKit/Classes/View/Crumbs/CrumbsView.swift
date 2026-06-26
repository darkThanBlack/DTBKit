//
//  CrumbsView.swift
//  Alamofire
//
//  Created by moonShadow on 2026/6/25
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    public enum CrumbsType: String, CaseIterable {
        
        case tdi_arrow_1, tdi_select_1
        
        case itdi_arrow_1
    }
    
    /// 基类用于方便展示和内部调用
    ///
    /// 实际业务使用时不建议引入基类，开发者自己拷贝一份具体实现，按需改名，微调
    open class CrumbsView: UIView {
        
        open func updateData(_ data: DTB.SampleData?) {
            fatalError("wrong call")
        }
        
        public static func create(_ type: CrumbsType) -> CrumbsView {
            switch type {
            case .tdi_arrow_1:
                return Crumb1()
            case .tdi_select_1:
                return Crumb2()
            case .itdi_arrow_1:
                return Crumb3()
            }
        }
        
    }
}

