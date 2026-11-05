//
//  DTBConsole.swift
//  DTBKit
//
//  Created by moonShadow on 2025/11/30
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import Foundation

extension DTB {
    
    /// Same name as ``web.console``
    ///
    /// 日志门面：注册了 ``DTB.Providers/ConsoleProvider`` 时全部转发过去，
    /// 否则使用内置的 `Swift.print` 实现（引导期也不会丢日志）。
    public final class ConsoleManager {
        
        public static let shared = ConsoleManager()
        private init() {}
        
        /// 当前注册的日志出口；`nil` = 使用默认实现
        private var provider: (any DTB.Providers.ConsoleProvider)? {
            return DTB.Providers.get(DTB.Providers.consoleKey)
        }
        
        @inline(__always)
        public func log(
            _ item: Any,
            file: String = #file,
            line: Int = #line,
            function: String = #function
        ) {
            if let provider = provider {
                provider.log(item, file: file, line: line, function: function)
                return
            }
#if DEBUG
            Swift.print("DTB__LOG  \(item)")
#endif
        }
        
        @inline(__always)
        public func error(
            _ item: Any? = nil,
            file: String = #file,
            line: Int = #line,
            function: String = #function
        ) {
            if let provider = provider {
                provider.error(item, file: file, line: line, function: function)
                return
            }
            if let obj = item {
                Swift.print("DTB__ERROR  \(String(reflecting: obj))\nfunction=\(function) file=\(file) line=\(line)")
            } else {
                Swift.print("DTB__ERROR  function=\(function) file=\(file) line=\(line)")
            }
        }
        
        @inline(__always)
        public func assert(
            _ message: String? = nil,
            file: String = #file,
            line: Int = #line,
            function: String = #function
        ) {
#if DEBUG
            /// 先让 provider 上报，再触发断言陷阱（陷阱本身不可被 provider 吞掉）
            DTB.Providers.get(DTB.Providers.consoleKey)?.assertionFailure(message, file: file, line: line, function: function)
            Swift.assert(false, "DTB__ASSERT  message=\(message ?? "")\nfunction=\(function) file=\(file) line=\(line)")
#else
            /// Release 保持原行为：降级为一条 error（已注册 provider 时同样会转发）
            error(message, file: file, line: line, function: function)
#endif
        }
    }
}
