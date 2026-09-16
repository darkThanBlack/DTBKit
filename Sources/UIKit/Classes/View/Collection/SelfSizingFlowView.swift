//
//  SelfSizingFlowView.swift
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

    /// SelfSizingFlowView 的布局配置。
    public struct SelfSizingFlowConfig {

        /// 主轴
        ///
        /// - horizontal: item 水平从左向右排列
        /// - vertical: item 垂直从上往下排列
        public var axis: DTB.Axis = .horizontal

        /// 副轴
        public var alignment: DTB.Alignment

        /// 行间距
        public var lineSpacing: CGFloat

        /// 列间距
        public var itemSpacing: CGFloat

        public init(
            axis: DTB.Axis = .horizontal,
            alignment: DTB.Alignment = .center,
            lineSpacing: CGFloat = 0.0,
            itemSpacing: CGFloat = 0.0
        ) {
            self.axis = axis
            self.alignment = alignment
            self.lineSpacing = lineSpacing
            self.itemSpacing = itemSpacing
        }
    }
}

extension DTB {

    /// SelfSizingFlowView 的数据源（可选入口，`dataSource != nil` 即协议模式）。
    ///
    /// 与 `update(items:)` 裸数组模式共存：`reloadData()` 内 for 循环拉快照后仍走裸数组数据流，布局引擎零 fork。
    /// 无 `sizeForItemAt`（item 自报尺寸走 `sizeThatFits`/约束）、无 delegate（item 非 cell，点击由 item 在 `itemAt` 内自处理）、无 dequeue（全展开无离屏回收）。
    ///
    /// 实例复用职责在业务：`itemAt` 可能随 `reloadData` 多次回调，业务自行在 model 内缓存「同 index 同实例」。
    public protocol SelfSizingFlowDataSource: AnyObject {

        func numberOfItems(in flowView: SelfSizingFlowView) -> Int

        func flowView(_ flowView: SelfSizingFlowView, itemAt index: Int) -> UIView
    }
}

extension DTB {

    /// 自身尺寸始终等于内容尺寸的流式视图。
    ///
    /// 布局：item 沿主轴逐排排列、超界换排；宽高均由 item 自报，排内尺寸 = 该排 max(item)。
    /// 主轴由 `axis` 决定：`.horizontal` 横排（超宽换行，撑高依赖宽）、`.vertical` 竖排（超高换列，撑宽依赖高）。
    ///
    /// 撑开轴依赖换排、换排依赖主轴尺寸，而 `intrinsicContentSize` 无参拿不到主轴尺寸——
    /// 故缓存 `cachedSize`，在 `layoutSubviews` 算出结果、变化时 `invalidateIntrinsicContentSize` 触发外层重查收敛。
    ///
    /// item 需自报尺寸：约束 item 建约束、frame item 重写 `sizeThatFits` 即可。
    public final class SelfSizingFlowView: UIView {

        /// 当前布局配置。
        public private(set) var config = SelfSizingFlowConfig()

        /// 可选数据源：非 nil 即协议模式，`reloadData()` 从它拉取；置 nil 切回裸 `update(items:)` 模式。
        public weak var dataSource: SelfSizingFlowDataSource?

        /// 当前挂载的 item 视图。
        private var itemViews: [UIView] = []

        /// 缓存每个 item 的固有 size
        private var itemSizes: [CGSize] = []

        /// 最近一次 layout 算出的总 size（依赖轴由外部给，撑开轴由本类算）。
        private var cachedSize: CGSize = .zero

        public override init(frame: CGRect) {
            super.init(frame: frame)
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - Update

        /// 重新加载数据：`dataSource != nil` 时从数据源拉取并替换；否则保留当前 items 仅重排。
        ///
        /// `itemAt` 只在 `reloadData()` 里回调、每 index 恰好一次；布局收敛（`relayout`/`layoutSubviews`/intrinsic 查询）绝不重调。
        public func reloadData() {
            guard let ds = dataSource else {
                relayout()
                return
            }
            let count = ds.numberOfItems(in: self)
            var views: [UIView] = []
            views.reserveCapacity(count)
            for index in 0..<count {
                views.append(ds.flowView(self, itemAt: index))
            }
            update(items: views)
        }

        /// 更新 items：整体替换
        ///
        /// - Parameter items: 完整 item 视图数组。框架按数组顺序沿主轴排 frame；
        ///   业务在调用前自行完成「创建 + 配数据」
        public func update(items: [UIView]) {
            itemViews.forEach { $0.removeFromSuperview() }
            itemViews = items
            items.forEach { addSubview($0) }

            /// measure：立即求解每个 item 的固有 size（不依赖容器宽）
            itemSizes = items.map {
                $0.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            }
            refreshCachedSize()
            relayout()
        }

        /// 更新布局配置，并刷新内容。
        public func update(config: SelfSizingFlowConfig) {
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

        /// update 时若依赖轴已定，立即重算缓存，让 invalidate 后的首次 intrinsic 查询就直接拿到新值。
        private func refreshCachedSize() {
            switch config.axis {
            case .horizontal:
                cachedSize = bounds.width > 0 ? layoutItems(by: bounds.size) : .zero
            case .vertical:
                cachedSize = bounds.height > 0 ? layoutItems(by: bounds.size) : .zero
            }
        }

        public override var intrinsicContentSize: CGSize {
            switch config.axis {
            case .horizontal:
                return CGSize(width: UIView.noIntrinsicMetric, height: cachedSize.height)
            case .vertical:
                return CGSize(width: cachedSize.width, height: UIView.noIntrinsicMetric)
            }
        }

        public override func sizeThatFits(_ size: CGSize) -> CGSize {
            return layoutItems(by: size)
        }

        public override func layoutSubviews() {
            super.layoutSubviews()

            switch config.axis {
            case .horizontal:
                guard bounds.width > 0 else { return }
            case .vertical:
                guard bounds.height > 0 else { return }
            }

            let result = layoutItems(by: bounds.size)
            /// 依赖轴或撑开轴任一变化 → 触发外层重查，收敛
            if result != cachedSize {
                cachedSize = result
                invalidateIntrinsicContentSize()
            }
        }

        /// 入参为提议 size，返回推测总宽高，副作用是依次设置 item frame。
        @discardableResult
        private func layoutItems(by size: CGSize) -> CGSize {
            switch config.axis {
            case .horizontal:
                return layoutHorizontal(by: size)
            case .vertical:
                return layoutVertical(by: size)
            }
        }

        /// 横排：主轴 = 宽，副轴 = 高。
        private func layoutHorizontal(by size: CGSize) -> CGSize {
            guard size.width > 0, !itemViews.isEmpty else {
                return CGSize(width: size.width, height: 0)
            }

            /// 第一遍：分行（每行 item 索引范围 + 行高 = max）
            var lines: [(range: Range<Int>, height: CGFloat)] = []
            var x: CGFloat = 0
            var lineHeight: CGFloat = 0
            var lineStart = 0
            for index in itemSizes.indices {
                let w = itemSizes[index].width
                /// 换行（首格不判；超宽项溢出，不压缩）
                if x > 0 && x + w > size.width {
                    lines.append((lineStart..<index, lineHeight))
                    x = 0
                    lineHeight = 0
                    lineStart = index
                }
                x += w + config.itemSpacing
                lineHeight = max(lineHeight, itemSizes[index].height)
            }
            lines.append((lineStart..<itemSizes.count, lineHeight))

            /// 第二遍：摆 frame（副轴对齐）
            var y: CGFloat = 0
            for line in lines {
                var lx: CGFloat = 0
                for index in line.range {
                    let s = itemSizes[index]
                    let dy = offset(itemLength: s.height, lineLength: line.height)
                    itemViews[index].frame = CGRect(x: lx, y: y + dy, width: s.width, height: s.height)
                    lx += s.width + config.itemSpacing
                }
                y += line.height + config.lineSpacing
            }
            return CGSize(width: size.width, height: y - config.lineSpacing)
        }

        /// 竖排：主轴 = 高，副轴 = 宽。
        private func layoutVertical(by size: CGSize) -> CGSize {
            guard size.height > 0, !itemViews.isEmpty else {
                return CGSize(width: 0, height: size.height)
            }

            /// 第一遍：分列（每列 item 索引范围 + 列宽 = max）
            var columns: [(range: Range<Int>, width: CGFloat)] = []
            var y: CGFloat = 0
            var columnWidth: CGFloat = 0
            var columnStart = 0
            for index in itemSizes.indices {
                let h = itemSizes[index].height
                /// 换列（首格不判；超宽项溢出，不压缩）
                if y > 0 && y + h > size.height {
                    columns.append((columnStart..<index, columnWidth))
                    y = 0
                    columnWidth = 0
                    columnStart = index
                }
                y += h + config.itemSpacing
                columnWidth = max(columnWidth, itemSizes[index].width)
            }
            columns.append((columnStart..<itemSizes.count, columnWidth))

            /// 第二遍：摆 frame（副轴对齐）
            var x: CGFloat = 0
            for column in columns {
                var ly: CGFloat = 0
                for index in column.range {
                    let s = itemSizes[index]
                    let dx = offset(itemLength: s.width, lineLength: column.width)
                    itemViews[index].frame = CGRect(x: x + dx, y: ly, width: s.width, height: s.height)
                    ly += s.height + config.itemSpacing
                }
                x += column.width + config.lineSpacing
            }
            return CGSize(width: x - config.lineSpacing, height: size.height)
        }

        /// 副轴对齐偏移（item 在该排内的偏移）。
        private func offset(itemLength: CGFloat, lineLength: CGFloat) -> CGFloat {
            switch config.alignment {
            case .leading:
                return 0
            case .center:
                return (lineLength - itemLength) / 2.0
            case .trailing:
                return lineLength - itemLength
            }
        }

    }

}
