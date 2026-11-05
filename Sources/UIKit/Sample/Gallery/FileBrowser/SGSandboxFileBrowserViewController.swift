//
//  SGSandboxFileBrowserViewController.swift
//  DTBKit
//
//  Created by moonShadow on 2026/10/31
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit
import QuickLook

extension DTB {

    /// FileBrowser 展示页 · **真实沙盒**版（Sample 画廊页）。
    ///
    /// 与 ``SGFileBrowserViewController`` 的唯一差别是「内容从哪来」：
    /// - ``SGFileBrowserViewController`` 用内存 mock（异步假延时 + 缓存）；
    /// - 本页用 ``FileBrowserSandboxProvider`` 列真实的 `Documents` 目录（后台 IO + 缓存）。
    ///
    /// 于是 ``FileBrowserView`` 一行都不用改 —— 它本来就只认两份数据源
    /// （路径源 = 本页的 ``FilePathStack``，内容源 = provider），这正是框架把
    /// 「路径 / 内容 / 事件」拆成三个槽的意义：换数据源 = 换一个对象。
    ///
    /// 交互：
    /// - 点文件夹：路径栈压一层，重新取内容；
    /// - 点面包屑：回退到该层（缓存命中 → 同步回调，不闪 loading）；
    /// - **点文件：用系统 QuickLook 预览**（`QLPreviewController`，支持文本 / 图片 / PDF / 音视频等）；
    /// - 「写入示例文件」往沙盒里写一批**真实文件**（md / json / html / png / 嵌套目录），
    ///   方便在没有外部文件时验证浏览与预览；「清空示例」只删这个示例子目录。
    final class SGSandboxFileBrowserViewController: DTB.BaseViewController, DTB.FileBrowserPathDataSource, DTB.FileBrowserDelegate {

        /// 内容源：真实 FileManager（换一套实现即换数据源，本页其余代码不动）
        private let provider = DTB.FileBrowserSandboxProvider()

        /// 路径栈：现在在哪一层（框架不持有 paths，所以这就是唯一那份账）
        private lazy var stack = DTB.FilePathStack(rootID: provider.root.nodeID)

        /// id → 节点：路径条问「第 i 项是什么」时得拿得出来
        private var nodeCache: [String: DTB.SandboxFileNode] = [:]

        /// 当前要预览的文件（`QLPreviewControllerDataSource` 只认它）
        private var previewURL: URL?

        override func viewDidLoad() {
            super.viewDidLoad()

            loadViews(in: view)

            browser.pathDataSource = self
            browser.nodeDataSource = provider
            browser.delegate = self

            /// 内容落地（含缓存命中）后刷新「当前层 / 请求次数」——异步回调不经过本页，所以用这个钩子
            provider.onLoad = { [weak self] in
                self?.refreshInfo()
            }

            let root = provider.root
            nodeCache[root.nodeID] = root
            reload()
        }

        // MARK: - DTB.FileBrowserPathDataSource

        func fileBrowserPathNumbers(_ browser: DTB.FileBrowserView) -> Int {
            return stack.ids.count
        }

        /// 路径项就是我们自己的 model —— 框架只读 `nodeName`；身份在后面 `nodesOf` 里靠 `as?` 收窄拿回来
        func fileBrowser(_ browser: DTB.FileBrowserView, pathItemFor index: Int) -> any DTB.PathNode {
            return nodeCache[stack.ids[index]] ?? provider.root
        }

        // MARK: - DTB.FileBrowserDelegate

        /// 点了面包屑祖先（框架只报第几项）：回退到该层再重画
        func fileBrowser(_ browser: DTB.FileBrowserView, didSelectPathAt index: Int) {
            stack.trim(toDepth: index + 1)
            reload()
        }

        /// 点了一行：文件夹往下走一层，**文件交给系统预览**
        func fileBrowser(_ browser: DTB.FileBrowserView, didSelectNodeAt index: Int) {
            guard let node = node(at: index) else { return }

            switch node.nodeKind {
            case .folder:
                nodeCache[node.nodeID] = node
                stack.push(node.nodeID)
                reload()

            case .file:
                preview(node.url)
            }
        }

        // MARK: - 预览

        /// 用系统默认预览打开文件。
        ///
        /// `QLPreviewController` 就是「系统默认预览」本身：文本 / 图片 / PDF / 音视频 / Office 等交给系统渲染，
        /// 它不支持的类型会显示 QuickLook 自己的「无法预览」页（不额外做兜底，避免演示页出现第二套打开方式）。
        private func preview(_ url: URL) {
            selectLabel.text = "预览 → \(url.lastPathComponent)"

            previewURL = url

            let controller = QLPreviewController()
            controller.dataSource = self
            present(controller, animated: true, completion: nil)
        }

        // MARK: - 路径（这一层才是框架之外的业务）

        /// **业务唯一的写入口**：改自己的路径栈，然后让浏览器重画 + 重取内容
        private func reload() {
            /// 过期保护是业务的事（框架不认请求序号）：先认下「当前层」，迟到的回调由数据源自己丢
            provider.currentID = stack.topID

            browser.reloadData()
            refreshInfo()
        }

        /// 「第几行」→ 自己的节点：框架只报下标，这份映射是业务的事（数据源里那份账）
        private func node(at index: Int) -> DTB.SandboxFileNode? {
            let level = provider.level(stack.topID)
            guard level.indices.contains(index) else { return nil }
            return level[index] as? DTB.SandboxFileNode
        }

        private func refreshInfo() {
            let top = stack.topID
            let base = provider.rootURL.standardizedFileURL.path
            var relative: String = top.hasPrefix(base) ? String(top.dropFirst(base.count)) : top
            if relative.isEmpty { relative = "/" }

            let count = provider.requestCount[top] ?? 0
            infoLabel.text = "当前 \(relative) · 请求 \(count)"
        }

        // MARK: - 示例文件（写的是真文件，不是 mock 节点）

        /// 示例子目录：只往这里写 / 只删这里，不动 Documents 里的其它内容
        private var demoURL: URL {
            return provider.rootURL.appendingPathComponent("DTBFileBrowserDemo", isDirectory: true)
        }

        @objc private func seedAction() {
            let fm = FileManager.default
            let base = demoURL

            do {
                try fm.createDirectory(at: base.appendingPathComponent("图片"), withIntermediateDirectories: true)
                try fm.createDirectory(at: base.appendingPathComponent("嵌套/第二层"), withIntermediateDirectories: true)

                try """
                # 沙盒文件浏览器

                这一页的数据源是**真实的 Documents 目录**，不是内存 mock。

                - 点文件夹：进入下一层（后台列目录，首次会看到 loading）
                - 点文件：系统 QuickLook 预览
                - 点面包屑：回退（缓存命中，瞬时）
                """.write(to: base.appendingPathComponent("说明.md"), atomically: true, encoding: .utf8)

                try """
                {
                  "name": "DTBKit",
                  "preview": "QuickLook",
                  "generated": "2026-10-31"
                }
                """.write(to: base.appendingPathComponent("示例数据.json"), atomically: true, encoding: .utf8)

                try """
                <!DOCTYPE html>
                <html>
                <head><meta charset="utf-8"><title>DTBKit</title></head>
                <body style="font-family:-apple-system;padding:24px">
                  <h1 style="color:#FF7700">DTBKit FileBrowser</h1>
                  <p>这个 HTML 也是沙盒里的真实文件，用 QuickLook 打开。</p>
                </body>
                </html>
                """.write(to: base.appendingPathComponent("预览.html"), atomically: true, encoding: .utf8)

                try "第二层的文本文件。\n".write(
                    to: base.appendingPathComponent("嵌套/第二层/更深一层.txt"),
                    atomically: true,
                    encoding: .utf8
                )

                if let data = demoImageData() {
                    try data.write(to: base.appendingPathComponent("图片/预览示例.png"))
                }
            } catch {
                selectLabel.text = "写入失败：\(error.localizedDescription)"
                return
            }

            provider.invalidateCache()
            reload()
            selectLabel.text = "已写入示例文件 → \(base.path)"
        }

        @objc private func clearAction() {
            let fm = FileManager.default
            if fm.fileExists(atPath: demoURL.path) {
                do {
                    try fm.removeItem(at: demoURL)
                } catch {
                    selectLabel.text = "清空失败：\(error.localizedDescription)"
                    return
                }
            }

            /// 可能正停在示例子目录里：路径栈回到根，避免指着一个已删除的目录
            stack = DTB.FilePathStack(rootID: provider.root.nodeID)
            provider.invalidateCache()
            reload()
            selectLabel.text = "已清空示例文件"
        }

        /// 生成一张真实 PNG（纯 UIKit 绘制，不依赖任何资源）
        private func demoImageData() -> Data? {
            let size = CGSize(width: 320.0, height: 200.0)
            let renderer = UIGraphicsImageRenderer(size: size)
            let image = renderer.image { context in
                UIColor.dtb.hex("FF7700").setFill()
                context.fill(CGRect(origin: .zero, size: size))

                let title = "DTBKit" as NSString
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 40.0, weight: .bold),
                    .foregroundColor: UIColor.white
                ]
                let titleSize = title.size(withAttributes: titleAttributes)
                title.draw(
                    at: CGPoint(x: (size.width - titleSize.width) / 2.0, y: 64.0),
                    withAttributes: titleAttributes
                )

                let subtitle = "QuickLook Preview" as NSString
                let subtitleAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
                    .foregroundColor: UIColor.white
                ]
                let subtitleSize = subtitle.size(withAttributes: subtitleAttributes)
                subtitle.draw(
                    at: CGPoint(x: (size.width - subtitleSize.width) / 2.0, y: 118.0),
                    withAttributes: subtitleAttributes
                )
            }
            return image.pngData()
        }

        // MARK: - View

        private func loadViews(in box: UIView) {
            box.addSubview(controlRow)
            box.addSubview(browser)
            box.addSubview(selectLabel)

            controlRow.snp.makeConstraints { make in
                make.top.left.right.equalTo(box.safeAreaLayoutGuide)
                make.height.equalTo(76.0)
            }
            selectLabel.snp.makeConstraints { make in
                make.left.right.equalTo(box.safeAreaLayoutGuide).inset(16.0)
                make.bottom.equalTo(box.safeAreaLayoutGuide).offset(-16.0)
            }
            browser.snp.makeConstraints { make in
                make.top.equalTo(controlRow.snp.bottom)
                make.left.right.equalToSuperview()
                make.bottom.equalTo(selectLabel.snp.top).offset(-8.0)
            }

            controlRow.addSubview(titleLabel)
            controlRow.addSubview(seedButton)
            controlRow.addSubview(clearButton)
            controlRow.addSubview(infoLabel)

            titleLabel.snp.makeConstraints { make in
                make.top.left.equalToSuperview().offset(8.0)
                make.right.lessThanOrEqualToSuperview().offset(-16.0)
            }
            seedButton.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(6.0)
                make.left.equalToSuperview().offset(16.0)
            }
            clearButton.snp.makeConstraints { make in
                make.left.equalTo(seedButton.snp.right).offset(8.0)
                make.centerY.equalTo(seedButton)
            }
            infoLabel.snp.makeConstraints { make in
                make.left.greaterThanOrEqualTo(clearButton.snp.right).offset(8.0)
                make.right.equalToSuperview().offset(-16.0)
                make.centerY.equalTo(seedButton)
            }
        }

        // MARK: - 懒加载

        private lazy var browser = DTB.FileBrowserView()

        private lazy var controlRow: UIView = {
            let view = UIView()
            view.backgroundColor = DTB.SampleDepends.bg2Color()
            return view
        }()

        private lazy var titleLabel: UILabel = {
            let view = UILabel()
            view.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            view.textColor = DTB.SampleDepends.text3Color()
            view.text = "数据源 = 真实沙盒 Documents（点文件走系统 QuickLook）"
            return view
        }()

        private lazy var infoLabel: UILabel = {
            let view = UILabel()
            view.font = UIFont.monospacedDigitSystemFont(ofSize: 11.0, weight: .regular)
            view.textColor = DTB.SampleDepends.text3Color()
            view.textAlignment = .right
            return view
        }()

        private lazy var seedButton: UIButton = {
            return makeButton(title: "写入示例文件", action: #selector(seedAction))
        }()

        private lazy var clearButton: UIButton = {
            return makeButton(title: "清空示例", action: #selector(clearAction))
        }()

        private func makeButton(title: String, action: Selector) -> UIButton {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
            button.setTitleColor(DTB.SampleDepends.textColor(), for: .normal)
            button.layer.cornerRadius = 6.0
            button.layer.borderWidth = 1.0
            button.layer.borderColor = DTB.SampleDepends.borderColor().cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
            button.addTarget(self, action: action, for: .touchUpInside)
            return button
        }

        private lazy var selectLabel: UILabel = {
            let view = UILabel()
            view.numberOfLines = 2
            view.font = UIFont.systemFont(ofSize: 12.0)
            view.textColor = DTB.SampleDepends.text2Color()
            view.text = "点文件 → QuickLook 预览；点文件夹 → 进入下一层"
            return view
        }()
    }
}

// MARK: - QuickLook

extension DTB.SGSandboxFileBrowserViewController: QLPreviewControllerDataSource {

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return previewURL == nil ? 0 : 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        /// `NSURL` 自带 `QLPreviewItem` 实现，直接交给系统
        return (previewURL ?? provider.rootURL) as NSURL
    }
}
