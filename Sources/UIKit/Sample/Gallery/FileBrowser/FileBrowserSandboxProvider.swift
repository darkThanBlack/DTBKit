//
//  FileBrowserSandboxProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2026/10/31
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {

    // MARK: - 节点

    /// 沙盒文件节点：直接包住一个 `file://` URL。
    ///
    /// 框架的 ``FileNode`` 里**没有 id** —— 「路径栈按什么入栈」是业务自己的账，
    /// 这里取 `standardizedFileURL.path`：同一个文件不管从哪一层被问到，拿到的 id 都一致。
    ///
    /// - Note: `nodeName` 用 `lastPathComponent`；根节点（Documents 本身）名字就是 `Documents`。
    struct SandboxFileNode: DTB.FileNode {

        let url: URL

        var nodeKind: DTB.FileNodeKind

        var nodeSize: Int64?

        var nodeIconToken: String?

        /// 业务侧身份：标准化后的绝对路径
        var nodeID: String { return url.standardizedFileURL.path }

        var nodeName: String? {
            let name = url.lastPathComponent
            return name.isEmpty ? url.standardizedFileURL.path : name
        }

        /// 按 URL 探测类型 / 大小，并顺手算出图标 token。
        ///
        /// - Returns: 文件不存在（比如枚举与读取之间被删掉）时返回 nil，调用方直接跳过这一行 ——
        ///   宁可少一行，也不画一个点不开的幽灵节点。
        static func make(url: URL) -> SandboxFileNode? {
            var isDirectory: ObjCBool = false
            guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
                return nil
            }

            let isFolder: Bool = isDirectory.boolValue
            let size: Int64? = isFolder ? nil : (try? url.resourceValues(forKeys: [.fileSizeKey]))?.fileSize.map(Int64.init)

            return SandboxFileNode(
                url: url,
                nodeKind: isFolder ? .folder : .file,
                nodeSize: size,
                /// 文件夹交给 ``FileBrowserDepends`` 的兜底图标（folder.fill）
                nodeIconToken: isFolder ? nil : DTB.FileBrowserDepends.token(forExtension: url.pathExtension)
            )
        }

        /// 排序：文件夹在前，同类按文件名自然序（`文件2` < `文件10`）
        static func isOrderedBefore(_ lhs: SandboxFileNode, _ rhs: SandboxFileNode) -> Bool {
            if lhs.nodeKind != rhs.nodeKind {
                return lhs.nodeKind == .folder
            }
            let l: String = lhs.url.lastPathComponent
            let r: String = rhs.url.lastPathComponent
            return l.localizedStandardCompare(r) == .orderedAscending
        }
    }

    // MARK: - 数据源

    /// 真实沙盒：``FileBrowserNodeDataSource`` 的实现 —— 用 `FileManager` 列目录，**异步 + 带缓存**。
    ///
    /// 与 ``FileBrowserMockProvider`` 的差别只有「内容从哪来」：路径同样不归它管（那是页面的路径栈），
    /// 接口契约完全一致 —— 所以 ``FileBrowserView`` 一行都不用改。
    ///
    /// - 第一次要某一层：后台线程列目录（真实 IO），主线程回调，于是能看到 loading 文案；
    /// - 之后要同一层：缓存命中、**同步**回调 —— 点面包屑回退是瞬时的；
    /// - 枚举失败（权限 / 目录被删）：`.failure`，框架直接显示 `localizedDescription`。
    ///
    /// - Important: 过期回调由业务自己丢（框架不认请求序号）—— 这里用 ``currentID`` 认「当前层」，
    ///   快速连点、旧请求晚回来时直接不回调。
    final class FileBrowserSandboxProvider: DTB.FileBrowserNodeDataSource {

        /// 沙盒根（默认 Documents）
        let rootURL: URL

        /// 每次**真实**取内容 +1（key = 层 id）；缓存命中的不算
        private(set) var requestCount: [String: Int] = [:]

        /// 内容落地时回调（页面用它刷新「请求次数」）
        var onLoad: (() -> Void)?

        /// 业务侧认定的「当前层」：过期回调在这里丢掉
        var currentID: String?

        private var levelCache: [String: [any DTB.FileNode]] = [:]

        private let queue = DispatchQueue(label: "dtb.sample.filebrowser.sandbox", qos: .userInitiated)

        init(rootURL: URL? = nil) {
            self.rootURL = rootURL
                ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                ?? FileManager.default.temporaryDirectory

            /// Documents 正常存在；保险起见确保一下（否则根节点一进来就是 failure）
            try? FileManager.default.createDirectory(
                at: self.rootURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }

        /// 浏览器入口：根节点
        var root: DTB.SandboxFileNode {
            return DTB.SandboxFileNode(
                url: rootURL,
                nodeKind: .folder,
                nodeSize: nil,
                nodeIconToken: nil
            )
        }

        /// 业务侧改了数据后重新要一次（写入 / 清空示例文件之后）
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
            /// 路径项就是我们自己交出去的那个 model，收窄回来身份就回来了
            guard let node = node as? DTB.SandboxFileNode else {
                completion(.success([]))
                return
            }

            let id: String = node.nodeID
            let url: URL = node.url

            /// 缓存命中：直接同步回调（框架照单收下，不会闪 loading）
            if let cached = levelCache[id] {
                completion(.success(cached))
                onLoad?()
                return
            }

            queue.async { [weak self] in
                guard let self = self else { return }

                let result: Result<[any DTB.FileNode], Error>
                do {
                    let urls: [URL] = try FileManager.default.contentsOfDirectory(
                        at: url,
                        includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey],
                        options: [.skipsHiddenFiles]
                    )
                    let nodes: [any DTB.FileNode] = urls
                        .compactMap({ DTB.SandboxFileNode.make(url: $0) })
                        .sorted(by: DTB.SandboxFileNode.isOrderedBefore)
                        .map({ $0 as any DTB.FileNode })
                    result = .success(nodes)
                } catch {
                    result = .failure(error)
                }

                DispatchQueue.main.async {
                    /// 迟到的、已经不是当前层的回调：业务自己丢
                    guard self.currentID == id else { return }

                    self.requestCount[id, default: 0] += 1
                    if case .success(let nodes) = result {
                        self.levelCache[id] = nodes
                    }

                    completion(result)
                    self.onLoad?()
                }
            }
        }
    }
}
