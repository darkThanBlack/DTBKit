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
    
    ///
    public final class ConsoleManager {
        
        public static let shared = ConsoleManager()
        private init() {}
        
        @inline(__always)
        public func print(
            _ items: Any...,
            file: String = #file,
            line: Int = #line,
            function: String = #function
        ) {
#if DEBUG
            Swift.print("DTB__LOG  function=\(function)")
            Swift.print(items)
#endif
        }
        
        @inline(__always)
        public func error(
            _ items: Any...,
            file: String = #file,
            line: Int = #line,
            function: String = #function
        ) {
            Swift.print("--- DTB__ERROR START ---\nfile=\(file) line=\(line) function=\(function)")
            Swift.debugPrint(items)
            Swift.print("--- DTB__ERROR END ---")
        }
    }
}
