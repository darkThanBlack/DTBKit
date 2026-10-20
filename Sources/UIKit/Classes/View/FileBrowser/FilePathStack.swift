//
//  FilePathStack.swift
//  DTBKit
//
//  Created by moonShadow on 2026/10/8
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import Foundation

extension DTB {

    /// 面包屑的路径栈（纯逻辑，只认 id，不依赖 UIKit、不依赖 ``FileNode``）。
    ///
    /// 值语义：`push` / `trim` 都是原地变换，谁持有谁负责回写。
    /// 栈里恒有至少一层（根）。
    public struct FilePathStack: Equatable {

        /// 从根到当前层，恒非空
        public private(set) var ids: [String]

        public init(rootID: String) {
            self.ids = [rootID]
        }

        /// 深度（含根），最小 1
        public var depth: Int { return ids.count }

        public var rootID: String { return ids[0] }

        public var topID: String { return ids[ids.count - 1] }

        public func index(of id: String) -> Int? {
            return ids.firstIndex(of: id)
        }

        /// 追加一层；若 id 已在栈中则视为「绕回来」，先回退到该层（防环）
        ///
        /// - Returns: 该层在栈中的下标
        @discardableResult
        public mutating func push(_ id: String) -> Int {
            if let index = index(of: id) {
                ids.removeSubrange((index + 1)..<ids.count)
                return index
            }
            ids.append(id)
            return ids.count - 1
        }

        /// 保留前 depth 层（点面包屑）；越界一律 clamp 到根，不崩
        public mutating func trim(toDepth depth: Int) {
            let count = max(1, min(depth, ids.count))
            ids.removeSubrange(count..<ids.count)
        }
    }
}
