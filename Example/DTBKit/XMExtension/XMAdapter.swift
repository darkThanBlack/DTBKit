//
//  XMAdapter.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/30
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

//@_exported import DTBKit

extension DTBKitable {
    public var xm: DTBKitWrapper<Self> { return dtb }
    public static var xm: DTBKitStaticWrapper<Self> { return dtb }
}

extension DTBKitStructable {
    public var xm: DTBKitWrapper<Self> { return dtb }
    public static var xm: DTBKitStaticWrapper<Self> { return dtb }
}

//MARK: - playground

//public extension Array {
//
//    /// 数组对齐
//    /// - 方便操作 UIStack 类似结构时使用, 先保证页面持有的 sources<UIView> 与模型列表 targets<ViewModel> 的 count 相等, 多删少加, 再 for-in 赋一遍值.
//    /// - 调用：``Array<Any>.align(...``
//    /// - 2*O(n)
//    ///
//    /// - Parameters:
//    ///   - sources: 页面对象
//    ///   - targets: 数据模型
//    ///   - creater: 生成更多的对象
//    ///   - remover: 移除多余的对象
//    ///   - syncer: 将模型数据同步到对象上
//    ///   - completedHandler: DispatchQueue.main.async
//    static func align<S, T>(
//        sources: inout [S],
//        targets: [T],
//        creater: ((T)->(S))?,
//        remover: ((inout S)->())?,
//        syncer: ((inout S, T)->())?,
//        completedHandler: (()->())?
//    ) {
//        if sources.count != targets.count {
//            if targets.count < sources.count {
//                let endIndex = targets.endIndex
//                for index in endIndex..<sources.count {
//                    remover?(&sources[index])
//                }
//                sources.removeSubrange(endIndex..<sources.count)
//            } else {
//                let endIndex = sources.endIndex
//                for index in endIndex..<targets.count {
//                    if let item = creater?(targets[index]) {
//                        sources.append(item)
//                    }
//                }
//            }
//        }
//
//        guard sources.count == targets.count else {
//            return
//        }
//        for idx in 0..<sources.count {
//            syncer?(&sources[idx], targets[idx])
//        }
//
//        DispatchQueue.main.async {
//            completedHandler?()
//        }
//    }
//}

// MARK: L0 - Units.swift

// @available(*, message: "Use .xm.ns instead.")
//var numberValue: NSNumber {

// @available(*, message: "Use .xm.ns instead.")
//var numberValue: NSNumber {

// @available(*, message: "Use .xm.div100() instead.")
//func dividedBy100() -> String {

// @available(*, message: "Use .xm.float.div(100) instead.")
//var xmFloat: Float64 {

// @available(*, message: "Use .xm.string instead.")
//var toString: String {

// todo.
//var xmDuration: String {

// todo.
//var durationDesp: String {

// @available(*, message: "Use .xm.multi(100).int() instead.")
//var xmInt: Int {

// @available(*, message: "Use .xm.multi(100).int64() instead.")
//var xmInt64: Int64 {

// @available(*, message: "Use .xm.multi(100).int64() instead.")
//var toString: String {

// todo.
//var toString: String {

// @available(*, message: "Use .xm.string(NumberFormatter.xm.fixed) instead.")
//func toString(decimal: Int = 2, splitDigit: Int? = nil, prefix: String? = nil, isRound: Bool = true) -> String? {

// @available(*, message: "Use .xm.string(NumberFormatter.xm.multi) instead.")
//func toString(maxDecimal: Int, splitDigit: Int? = nil, prefix: String? = nil, isRound: Bool = true) -> String? {

// @available(*, message: "Use .xm.string(NumberFormatter.xm.multi.suffix("+")) instead.")
//func toSymbolString() -> String? {
