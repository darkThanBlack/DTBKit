//
//  FileBrowserMockProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2026/10/8
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {

    /// 画廊用的假节点（业务 model 的形状：只描述自己，不持有子树）
    ///
    /// - Note: `nodeID` 是**业务自己的字段** —— 框架的 ``FileNode`` 里没有 id。
    ///   它是业务侧的账：路径栈按它入栈，``FileBrowserDataSource/fileBrowser(_:nodesOf:completion:)``
    ///   里靠 `as?` 收窄回本类型把它取出来。
    struct FileBrowserMockNode: DTB.FileNode {

        let nodeID: String

        let nodeName: String?

        var nodeKind: DTB.FileNodeKind = .file

        var nodeSize: Int64?

        var nodeIconToken: String?

        /// 便捷构造：按后缀自动给图标 token（演示 ``FileBrowserDepends/token(forExtension:)``）
        static func file(_ id: String, _ name: String, size: Int64? = nil) -> FileBrowserMockNode {
            let ext = name.components(separatedBy: ".").last
            return FileBrowserMockNode(
                nodeID: id,
                nodeName: name,
                nodeKind: .file,
                nodeSize: size,
                nodeIconToken: DTB.FileBrowserDepends.token(forExtension: ext)
            )
        }

        static func folder(_ id: String, _ name: String) -> FileBrowserMockNode {
            return FileBrowserMockNode(nodeID: id, nodeName: name, nodeKind: .folder)
        }
    }

    /// 内存 mock：``FileBrowserNodeDataSource`` 的参考实现 —— **异步 + 带缓存**的假内容源
    /// （路径不归它管，那是本页自己的栈）。
    ///
    /// - 第一次要某一层：假装一段网络耗时（``fakeDelay``）再回调，于是能看到 loading 文案；
    /// - 之后要同一层：缓存命中、**同步**回调 —— 所以「点面包屑回退」是瞬时的，也不再算一次请求
    ///   （``requestCount`` 只统计真实请求，画廊用它证明这一点）。
    ///
    /// 内容刻意覆盖确定性边界：超长文件名 / 空目录 / 不可进入的目录 / 大目录 / 二三层嵌套。
    final class FileBrowserMockProvider: DTB.FileBrowserNodeDataSource {

        /// 每次**真实**取内容 +1（key = 层 id）；缓存命中的不算
        private(set) var requestCount: [String: Int] = [:]

        /// 内容落地时回调（画廊用它刷新「请求次数」）
        var onLoad: (() -> Void)?

        /// 假装网络耗时（真实实现里这里是网络 / FileManager）
        var fakeDelay: TimeInterval = 0.35

        /// 业务侧认定的「当前层」：过期回调由业务自己丢（框架不管这件事）
        ///
        /// 框架判不出来你的数据源是同步还是异步、请求能不能取消，所以「快速连点多个节点、旧请求晚回来」
        /// 这种形态必须在这里解决 —— 认出不是当前层就直接不回调。
        var currentID: String?

        /// 进不去的节点 id —— 由上层在 ``FileBrowserDelegate/fileBrowser(_:canSelectNodeAt:)`` 里拦下。
        /// 协议里**没有** `isLocked`：「哪些进不去」是业务规则，不是节点的属性。
        let lockedIDs: Set<String> = ["f://locked"]

        /// 浏览器入口：根节点
        var root: DTB.FileBrowserMockNode {
            return DTB.FileBrowserMockNode.folder("root://", "全部文件")
        }

        init() {
            build()
        }

        /// 业务侧改了数据后重新要一次（画廊的「重新加载」按钮）
        func invalidateCache() {
            levelCache.removeAll()
        }

        /// 某一层当前的内容：框架只报「第几行」，把行号映射回自己的节点是业务的事
        func level(_ id: String) -> [any DTB.FileNode] {
            return levelCache[id] ?? []
        }

        // MARK: - DTB.FileBrowserNodeDataSource

        func fileBrowser(
            _ browser: DTB.FileBrowserView,
            nodesOf node: any DTB.PathNode,
            completion: @escaping (Result<[any DTB.FileNode], Error>) -> Void
        ) {
            /// 框架不声明 id：路径项就是我们自己交出去的那个 model，收窄回来身份就回来了
            guard let id = (node as? DTB.FileBrowserMockNode)?.nodeID else {
                completion(.success([]))
                return
            }

            /// 缓存命中：直接同步回调（框架照单收下，不会闪 loading）
            if let cached = levelCache[id] {
                completion(.success(cached))
                onLoad?()
                return
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + fakeDelay) { [weak self] in
                guard let self = self else { return }

                /// 迟到的、已经不是当前层的回调：业务自己丢
                guard self.currentID == id else { return }

                self.requestCount[id, default: 0] += 1

                let nodes: [any DTB.FileNode] = (self.childrenMap[id] ?? []).map({ $0 as any DTB.FileNode })
                self.levelCache[id] = nodes

                completion(.success(nodes))
                self.onLoad?()
            }
        }

        // MARK: - 假数据

        private var childrenMap: [String: [DTB.FileBrowserMockNode]] = [:]

        private var levelCache: [String: [any DTB.FileNode]] = [:]

        private func build() {
            childrenMap["root://"] = [
                .folder("f://homework", "作业"),
                .folder("f://images", "图片素材"),
                .folder("f://empty", "空目录"),
                .folder("f://long", "这是一个特别长的文件夹名称用来验证中间截断的表现"),
                .folder("f://locked", "进不去的目录（canSelectNodeAt 拦住）"),
                .file("d://readme", "课程说明.pdf", size: 1_258_291),
                .file("d://noext", "没有后缀的文件", size: 4_096)
            ]

            childrenMap["f://homework"] = [
                .folder("f://homework/1", "第一单元"),
                .folder("f://homework/2", "第二单元"),
                .folder("f://homework/3", "第三单元（空）"),
                .file("d://homework/a", "作业模板.docx", size: 24_576),
                .file("d://homework/b", "参考答案.pdf", size: 512_000),
                .file("d://homework/c", "朗读录音.mp3", size: 3_145_728),
                .file("d://homework/d", "演示视频.mp4", size: 128_974_848),
                .file("d://homework/e", "资料打包.zip", size: 8_388_608)
            ]

            childrenMap["f://homework/1"] = [
                .folder("f://homework/1/1", "课后练习"),
                .file("d://homework/1/a", "第一课.docx", size: 18_432),
                .file("d://homework/1/b", "第一课答案.pdf", size: 226_048)
            ]

            childrenMap["f://homework/1/1"] = [
                .file("d://homework/1/1/a", "练习一.docx", size: 12_288),
                .file("d://homework/1/1/b", "练习二.docx", size: 13_312),
                .file("d://homework/1/1/c", "练习三.docx", size: 11_264)
            ]

            childrenMap["f://homework/2"] = [
                .file("d://homework/2/a", "第二课.docx", size: 20_480),
                .file("d://homework/2/b", "第二课答案.pdf", size: 230_400)
            ]

            childrenMap["f://homework/3"] = []

            /// 大目录：60 个文件（验证长列表滚动）
            childrenMap["f://images"] = (1...60).map { index in
                DTB.FileBrowserMockNode.file(
                    "d://images/\(index)",
                    String(format: "照片_%03d.png", index),
                    size: Int64(index) * 102_400
                )
            }

            /// 空目录：故意留空（验证空态文案）
            childrenMap["f://empty"] = []

            childrenMap["f://long"] = [
                .folder("f://long/sub", "子层：再长一点的名字试试看它会不会把整行撑爆掉"),
                .file("d://long/a", "2026学年第一学期期末考试复习提纲与重点整理（最终版）.pdf", size: 2_097_152),
                .file("d://long/b", "a-very-long-file-name-used-to-verify-middle-truncation-behaviour.docx", size: 45_056)
            ]

            childrenMap["f://long/sub"] = [
                .file("d://long/sub/a", "就是来看看面包屑有多长的.pdf", size: 102_400)
            ]

            /// 进不去的目录：内容照样给一份（否则「点不进去」与「里面是空的」会混在一起）
            childrenMap["f://locked"] = [
                .file("d://locked/a", "你看不到我.pdf", size: 1_024)
            ]
        }
    }
}
