//
//  ConsoleProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2026/11/5
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import Foundation

extension DTB.Providers {
    
    /// 日志出口的 key。
    ///
    /// 注册后 ``DTB.ConsoleManager`` 会把 `log` / `error` / `assert` 的调用转发给该 provider；
    /// 未注册时使用 ``DTB.ConsoleManager`` 内置的 `Swift.print` 实现。
    public static let consoleKey = DTB.ConstKey<any ConsoleProvider>("dtb.providers.console")
    
    /// 可替换的日志出口（`os_log` / 落盘 / 远端上报等）。
    ///
    /// - Important: 未注册时不会丢日志 —— ``DTB.ConsoleManager`` 自带默认实现，
    ///   所以引导期（Provider 注册之前）的日志同样可见。
    ///
    /// - Important: 实现内部不要再调用 `DTB.console`，否则会递归。
    public protocol ConsoleProvider: AnyObject {
        
        func log(_ item: Any, file: String, line: Int, function: String)
        
        func error(_ item: Any?, file: String, line: Int, function: String)
        
        /// 仅用于上报。DEBUG 下的 `Swift.assert` 陷阱由 ``DTB.ConsoleManager`` 负责，
        /// provider 无法吞掉断言。
        func assertionFailure(_ message: String?, file: String, line: Int, function: String)
    }
}
