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
    
    /// Named web console.
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
            if let provider = DTB.Providers.get(DTB.Providers.consoleKey) {
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
            if let provider = DTB.Providers.get(DTB.Providers.consoleKey) {
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
            _ item: Any? = nil,
            file: String = #file,
            line: Int = #line,
            function: String = #function
        ) {
            if let provider = DTB.Providers.get(DTB.Providers.consoleKey) {
                provider.assert(item, file: file, line: line, function: function)
                return
            }
#if DEBUG
            Swift.assert(false, "DTB__ASSERT  message=\(item ?? "")\nfunction=\(function) file=\(file) line=\(line)")
#else
            error(item, file: file, line: line, function: function)
#endif
        }
    }
}
