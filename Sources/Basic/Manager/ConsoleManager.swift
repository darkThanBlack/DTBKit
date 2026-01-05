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
            Swift.print("DTB__LOG  \(item)  function=\(function)")
#endif
        }
        
        @inline(__always)
        public func error(
            _ item: Any,
            file: String = #file,
            line: Int = #line,
            function: String = #function
        ) {
            Swift.print("--- DTB__ERROR START\nfile=\(file) line=\(line) function=\(function)")
            Swift.debugPrint(item)
            Swift.print("--- DTB__ERROR END")
        }
        
        @inline(__always)
        public func fail(
            _ message: String? = nil,
            file: String = #file,
            line: Int = #line,
            function: String = #function
        ) {
            Swift.print("--- DTB__ASSERT \nfile=\(file) line=\(line) function=\(function) \nmessage=\(message ?? "")")
#if DEBUG
            Swift.assertionFailure()
#endif
        }
    }
}
