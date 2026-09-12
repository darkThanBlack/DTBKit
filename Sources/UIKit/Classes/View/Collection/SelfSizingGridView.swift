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
        
        /// item 高度（固定）
        public var itemHeight: CGFloat
        
        /// 每行最大 item 数
        public var columnsPerRow: Int
        
        /// 行间距
        public var lineGap: CGFloat
        
        /// 列间距
        public var columnGap: CGFloat
        
        public init(
            itemHeight: CGFloat = 50,
            columnsPerRow: Int = 2,
            lineGap: CGFloat = 0,
            columnGap: CGFloat = 0
        ) {
            self.itemHeight = itemHeight
            self.columnsPerRow = columnsPerRow
            self.lineGap = lineGap
            self.columnGap = columnGap
        }
    }
}

extension DTB {
    
    /// 自身尺寸始终等于内容尺寸的网格视图。
    ///
    /// 阶段一布局：item 从左到右逐行排列，每行最多 `columnsPerRow` 个；
    /// `item.width = 均分当前宽度`，`item.height = itemHeight`（固定）。
    ///
    /// 尺寸（均分宽 × itemHeight）由本类独占计算，item 只负责在给定 frame 内自适应内容。
    ///
    /// 无 dataSource / 无 cell 注册 / 无复用：业务在 `update(_ items:)` 里一次性给完整视图数组，
    /// 并自行在 map 闭包内决定「同 index 返回什么 / 是否复用缓存实例」。
    ///
    /// 【item 契约】item 采用「适应给定 frame」：容器给定 frame，item 内容在其内自适应；
    /// 预设尺寸（列宽 / itemHeight）是「内容上限」——低了压缩/截断，高了留白。
    /// 故 item 内部不得用 required 固定尺寸约束，可伸缩部分用低优先级以便优雅降级。
    /// 要「内容撑开、绝不压缩」→ SelfSizingFlowView。
    public final class SelfSizingGridView: UIView {
        
        /// 当前布局配置。
        public private(set) var config = SelfSizingGridConfig()
        
        /// 当前挂载的 item 视图。
        private var itemViews: [UIView] = []
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Update
        
        /// 更新 item：整体替换，并刷新高度与内容。
        ///
        /// - Parameter items: 完整 item 视图数组。框架按数组顺序从左到右、从上到下排 frame；
        ///   业务在调用前自行完成「创建 + 配数据」，要复用实例就在 map 闭包里返回缓存实例。
        public func update(items: [UIView]) {
            itemViews.forEach { $0.removeFromSuperview() }
            itemViews = items
            items.forEach { addSubview($0) }
            relayout()
            print("update.items fired")
        }
        
        /// 更新布局配置，并刷新高度与内容。
        public func update(config: SelfSizingGridConfig) {
            self.config = config
            relayout()
        }
        
        // MARK: - Layout
        
        /// 触发重排
        private func relayout() {
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
        
        public override var intrinsicContentSize: CGSize {
            return CGSize(width: UIView.noIntrinsicMetric, height: gridHeight)
        }
        
        public override func sizeThatFits(_ size: CGSize) -> CGSize {
            return CGSize(width: size.width, height: gridHeight)
        }
        
        /// 计算总高度（阶段一：行数 × itemHeight，不依赖宽度）。
        private var gridHeight: CGFloat {
            guard itemViews.count > 0 else { return 0 }
            /// 每行个数
            let per = max(1, config.columnsPerRow)
            /// 最后一行个数
            let lastPer = itemViews.count % per
            /// 行数
            let lines = (itemViews.count / per) + (lastPer > 0 ? 1 : 0)
            
            let result = CGFloat(lines) * config.itemHeight + CGFloat(lines - 1) * config.lineGap
            return result
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            guard bounds.width > 0 else { return }
            
            guard itemViews.count > 0 else { return }
            /// 每行个数
            let per = max(1, config.columnsPerRow)
            /// 最后一行个数
            // let lastPer = itemViews.count % per
            /// 行数
            // let lines = (itemViews.count / per) + (lastPer > 0 ? 1 : 0)
            /// 固定宽度
            let itemWidth = (bounds.width - CGFloat(per - 1) * config.columnGap) / CGFloat(per)
            
            itemViews.enumerated().forEach { index, view in
                view.frame = CGRect(
                    x: CGFloat(index % per) * (itemWidth + config.columnGap),
                    y: CGFloat(index / per) * (config.itemHeight + config.lineGap),
                    width: itemWidth,
                    height: config.itemHeight
                )
            }
        }
        
    }
    
}
