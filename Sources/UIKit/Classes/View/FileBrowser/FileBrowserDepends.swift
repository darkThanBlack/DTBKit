//
//  FileBrowserDepends.swift
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

    /// 文件浏览器（``PathBarView`` / ``FileListView`` / ``FileBrowserView``）的**外部依赖收束**。
    ///
    /// 组件内部不直接碰主题 key —— 文字 / 颜色 / 图片全部经这里一层薄转，
    /// 于是「换皮 / 换文案 / 换图标」只有这一个改动点（也可整文件拷走改名，参照 ``DTB.Crumb1`` 的模板思路）。
    ///
    /// 参照 ``DTB.DiskUsageDepends`` 的形式。
    ///
    /// - Note: 只收「文案 / 颜色 / 字体 / 图片」这类会随主题变化的东西；
    ///   尺寸与布局常量（图标盒、留白、字号）就地写字面量 —— 它们跟着布局走，收在这里反而看不出来。
    ///
    /// - Note: 若某个业务想彻底脱开主题（像 ``DTB.SampleDepends`` 那样写死 HEX），
    ///   把下面的 `.dtb.create("…")` 换成 `UIColor.dtb.hex("…")` 即可，组件侧一行都不用动。
    struct FileBrowserDepends {

        // MARK: - Text

        /// 取内容期间的状态文案（列表藏起来，居中显示其中一句）
        static func loadingText() -> String { return .dtb.create("dtb.file.browser.loading") }

        /// 这一层确实没有内容
        static func emptyText() -> String { return .dtb.create("dtb.file.browser.empty") }

        // MARK: - Color

        /// 路径条 / 列表背景
        static func backgroundColor() -> UIColor { return .dtb.create("dtb.bg2") }

        /// 强调色：当前层文字 / 文件夹图标
        static func themeColor() -> UIColor { return .dtb.create("dtb.theme") }

        /// 行标题
        static func textColor() -> UIColor { return .dtb.create("dtb.text") }

        /// 祖先层文字 / 行副标题 / 文件图标
        static func lightTextColor() -> UIColor { return .dtb.create("dtb.text2") }

        /// 分隔符 / 尾部箭头
        static func disabledTextColor() -> UIColor { return .dtb.create("dtb.text_disabled") }

        /// 行图标底色
        static func iconBackgroundColor() -> UIColor { return .dtb.create("dtb.bg3") }

        // MARK: - Font

        /// 祖先层
        static func pathFont() -> UIFont { return UIFont.systemFont(ofSize: 13.0, weight: .regular) }

        /// 当前层（比祖先层重一档，用于「我在哪」的区分）
        static func pathCurrentFont() -> UIFont { return UIFont.systemFont(ofSize: 13.0, weight: .semibold) }

        // MARK: - Image

        /// SF Symbol（iOS 13+）；低版本返回 nil，调用方按「无图标」降级。
        ///
        /// 这里刻意不经过 `UIImage.dtb.local`：那需要宿主注册 localImage 提供者，
        /// 框架组件不该有这种隐式前置条件。
        static func image(systemName: String) -> UIImage? {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: systemName)
            }
            return nil
        }

        static func folderImage() -> UIImage? { return image(systemName: "folder.fill") }

        static func fileImage() -> UIImage? { return image(systemName: "doc.fill") }

        static func arrowImage() -> UIImage? { return image(systemName: "chevron.right") }

        /// 行图标：`nodeIconToken`（SF Symbol 名，优先）→ 按 ``FileNode/nodeKind`` 兜底
        static func nodeImage(_ node: any DTB.FileNode) -> UIImage? {
            if let token = node.nodeIconToken, let image = image(systemName: token) {
                return image
            }
            return (node.nodeKind == .folder) ? folderImage() : fileImage()
        }

        /// 图标着色：文件夹走强调色，文件走中性色
        static func nodeTintColor(_ node: any DTB.FileNode) -> UIColor {
            return (node.nodeKind == .folder) ? themeColor() : lightTextColor()
        }

        /// 常见后缀 → SF Symbol 名（业务可在自己 model 里用它算出 ``FileNode/nodeIconToken``）
        static func token(forExtension ext: String?) -> String? {
            switch ext?.lowercased() {
            case "pdf":                                 return "doc.richtext"
            case "doc", "docx", "pages", "txt", "md":   return "doc.text"
            case "xls", "xlsx", "csv", "numbers":       return "chart.bar"
            case "ppt", "pptx", "key":                  return "rectangle.on.rectangle"
            case "png", "jpg", "jpeg", "gif", "bmp", "heic", "webp":  return "photo"
            case "mp3", "wav", "m4a", "aac", "caf":     return "music.note"
            case "mp4", "mov", "avi", "mkv", "m4v":     return "film"
            case "zip", "rar", "7z", "tar", "gz":       return "archivebox"
            default:                                    return nil
            }
        }
    }
}
