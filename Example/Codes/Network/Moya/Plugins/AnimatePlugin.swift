//
//  AnimatePlugin.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/16
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import Moya

class AnimatePlugin {
    
    private var isAnimating = false
}

extension AnimatePlugin: PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
        // TODO: enable no animate
        /// 偶发崩溃: NSInvalidArgumentException
        /// -[__NSTaggedDate member:]: unrecognized selector sent to instance 0x8000000000000000
        /// 
        /// 处理:
        /// 1. memory 有锁
        /// 2. 全部拷贝一份: https://www.jianshu.com/p/c4bd2960b3fa 0x3
//        let __path = target.path
//        if var pool = DTB.app.get(DTB.MemoryKey.moyaNoAnimatePathPool), pool.contains(__path) {
//            pool.remove(__path)
//            DTB.app.set(pool, key: DTB.MemoryKey.moyaNoAnimatePathPool)
//            
//            return
//        }
        
        show()
    }
    
    func didReceive(_ result: Swift.Result<Response, MoyaError>, target: TargetType) {
        hide()
    }
    
    private func show() {
        guard isAnimating == false else {
            return
        }
        isAnimating = true
        
        UIView.dtb.showHUD()
    }
    
    private func hide() {
        guard isAnimating else {
            return
        }
        isAnimating = false
        
        UIView.dtb.hideHUD()
    }
}
