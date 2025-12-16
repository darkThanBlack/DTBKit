//
//  Container.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/16
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    ///
    @objc(DTBContainer)
    public final class Container: BaseView, DTB.LayoutEventLazyFireable {
        
        public var lazyLayoutEventsPool_: [DTB.LayoutEventLazyFireTiming : [(DTB.Container) -> ()]] = [:]
        
        public override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            lazyLayoutsWhenDidMoveToSuperview_()
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            lazyLayoutsWhenLayoutSubviews_()
        }
        
    }
    
}
