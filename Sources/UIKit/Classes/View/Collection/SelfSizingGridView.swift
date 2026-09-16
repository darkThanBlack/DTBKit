//
//  SelfSizingGridView.swift
//  DTBKit
//
//  Created by moonShadow on 2026/8/20
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {

    /// SelfSizingGridView 的布局配置。
    public struct SelfSizingGridConfig {

        /// item 宽度：`nil` = 均分（容器按 `itemsPerLine` 均分），非 nil = 固定
        public var itemWidth: CGFloat?

        /// item 高度：`nil` = 均分，非 nil = 固定
        public var itemHeight: CGFloat?

        /// 每行 / 每列最大 item 数（均分数）
        public var itemsPerLine: Int

        /// 副轴间距
        public var lineSpacing: CGFloat

        /// 主轴间距
        public var itemSpacing: CGFloat

        public init(
            itemWidth: CGFloat? = nil,
            itemHeight: CGFloat? = nil,
            itemsPerLine: Int = 2,
            lineSpacing: CGFloat = 0,
            itemSpacing: CGFloat = 0
        ) {
            self.itemWidth = itemWidth
            self.itemHeight = itemHeight
            self.itemsPerLine = itemsPerLine
            self.lineSpacing = lineSpacing
            self.itemSpacing = itemSpacing
        }
    }
}

extension DTB {

    /// 自身尺寸始终等于内容尺寸的网格视图。
    ///
    /// 布局：均分数 = `itemsPerLine`；模式由 item 尺寸推导——
    /// `itemHeight` 固定 → 横排（均分宽、撑高），`itemWidth` 固定 → 竖排（均分高、撑宽），双固定 → 换行（撑高）。
    ///
    /// 均分模式撑开轴总长走公式法、无需 invalidate；换行模式副轴总长依赖主轴，用 `cachedSize` 收敛。
    ///
    /// item 采用「适应给定 frame」：预设尺寸（均分轴 / 固定轴）是内容上限，内容在其内自适应（压缩/截断/留白）。
    public final class SelfSizingGridView: UIView {

        /// 当前布局配置。
        public private(set) var config = SelfSizingGridConfig()

        /// 当前挂载的 item 视图。
        private var itemViews: [UIView] = []

        /// 换行模式（双固定）的收敛缓存：副轴总长依赖主轴实值，需 layoutSubviews 算后 invalidate 收敛。
        private var cachedSize: CGSize = .zero

        /// 布局模式（由 item 尺寸推导）。
        private enum Mode {
            case horizontal  // itemHeight 固定 → 均分宽、撑高
            case vertical    // itemWidth 固定 → 均分高、撑宽
            case wrap        // 双固定 → 换行、撑高
            case invalid     // 双 nil
        }

        private var mode: Mode {
            switch (config.itemWidth, config.itemHeight) {
            case (nil, .some):     return .horizontal
            case (.some, nil):     return .vertical
            case (.some, .some):   return .wrap
            case (nil, nil):       return .invalid
            }
        }

        public override init(frame: CGRect) {
            super.init(frame: frame)
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - Update

        /// 更新 items：整体替换
        ///
        /// - Parameter items: 完整 item 视图数组。框架按数组顺序沿主轴排 frame；
        ///   业务在调用前自行完成「创建 + 配数据」
        public func update(items: [UIView]) {
            itemViews.forEach { $0.removeFromSuperview() }
            itemViews = items
            items.forEach { addSubview($0) }
            refreshCachedSize()
            relayout()
        }

        /// 更新布局配置，并刷新尺寸与内容。
        public func update(config: SelfSizingGridConfig) {
            self.config = config
            refreshCachedSize()
            relayout()
        }

        // MARK: - Layout

        /// 触发重排
        private func relayout() {
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }

        /// update 时若换行模式且主轴已定，立即重算缓存，让 invalidate 后的首次 intrinsic 查询直接拿新值。
        private func refreshCachedSize() {
            cachedSize = .zero
            guard mode == .wrap, bounds.width > 0 else { return }
            cachedSize = layoutWrap(by: bounds.size)
        }

        public override var intrinsicContentSize: CGSize {
            switch mode {
            case .horizontal:
                return CGSize(width: UIView.noIntrinsicMetric, height: gridLength)
            case .vertical:
                return CGSize(width: gridLength, height: UIView.noIntrinsicMetric)
            case .wrap:
                return CGSize(width: UIView.noIntrinsicMetric, height: cachedSize.height)
            case .invalid:
                return .zero
            }
        }

        public override func sizeThatFits(_ size: CGSize) -> CGSize {
            switch mode {
            case .horizontal: return CGSize(width: size.width, height: gridLength)
            case .vertical:   return CGSize(width: gridLength, height: size.height)
            case .wrap:       return layoutWrap(by: size)
            case .invalid:    return .zero
            }
        }

        /// 均分模式撑开轴总长（公式法，不依赖给定轴实值）：横排 = 总高，竖排 = 总宽。
        private var gridLength: CGFloat {
            guard itemViews.count > 0 else { return 0 }
            let per = max(1, config.itemsPerLine)
            let lines = (itemViews.count + per - 1) / per
            switch mode {
            case .horizontal:
                guard let h = config.itemHeight, h > 0 else { return 0 }
                return CGFloat(lines) * h + CGFloat(lines - 1) * config.lineSpacing
            case .vertical:
                guard let w = config.itemWidth, w > 0 else { return 0 }
                return CGFloat(lines) * w + CGFloat(lines - 1) * config.itemSpacing
            case .wrap, .invalid:
                return 0
            }
        }

        public override func layoutSubviews() {
            super.layoutSubviews()

            guard itemViews.count > 0 else { return }
            let per = max(1, config.itemsPerLine)

            switch mode {
            case .horizontal:
                guard bounds.width > 0, let h = config.itemHeight, h > 0 else { return }
                let w = (bounds.width - CGFloat(per - 1) * config.itemSpacing) / CGFloat(per)
                itemViews.enumerated().forEach { index, view in
                    view.frame = CGRect(
                        x: CGFloat(index % per) * (w + config.itemSpacing),
                        y: CGFloat(index / per) * (h + config.lineSpacing),
                        width: w,
                        height: h
                    )
                }
            case .vertical:
                guard bounds.height > 0, let w = config.itemWidth, w > 0 else { return }
                let h = (bounds.height - CGFloat(per - 1) * config.lineSpacing) / CGFloat(per)
                itemViews.enumerated().forEach { index, view in
                    view.frame = CGRect(
                        x: CGFloat(index / per) * (w + config.itemSpacing),
                        y: CGFloat(index % per) * (h + config.lineSpacing),
                        width: w,
                        height: h
                    )
                }
            case .wrap:
                guard bounds.width > 0 else { return }
                let result = layoutWrap(by: bounds.size)
                if result != cachedSize {
                    cachedSize = result
                    invalidateIntrinsicContentSize()
                }
            case .invalid:
                break
            }
        }

        /// 双固定 → 换行（均分轴 = 宽，副轴总长依赖主轴，配合 `cachedSize` 收敛）。
        @discardableResult
        private func layoutWrap(by size: CGSize) -> CGSize {
            guard size.width > 0, let w = config.itemWidth, let h = config.itemHeight, w > 0, h > 0 else {
                return CGSize(width: size.width, height: 0)
            }
            var x: CGFloat = 0
            var y: CGFloat = 0
            for index in itemViews.indices {
                if x > 0 && x + w > size.width {
                    x = 0
                    y += h + config.lineSpacing
                }
                itemViews[index].frame = CGRect(x: x, y: y, width: w, height: h)
                x += w + config.itemSpacing
            }
            return CGSize(width: size.width, height: y + h)
        }

    }

}
