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


import UIKit

extension DTB {
    
    /// Same name as ``web.console``
    public final class ConsoleManager {
        
        public static let shared = ConsoleManager()
        private init() {}
        
        @inline(__always)
        public func log(
            _ item: Any,
            file: String = #file,
            line: Int = #line,
            function: String = #function
        ) {
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
            Swift.assert(false, "DTB__ASSERT  message=\(message ?? "")\nfunction=\(function) file=\(file) line=\(line)")
#else
            error(message)
#endif
        }
    }
}
