//
//  ReusableScrollView.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/16
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {

    /// 可复用 cell 基类：出队复用路径会先调 `prepareForReuse()`，业务子类在此重置残留状态。
    ///
    /// 框架不负责创建（无 `register` / 无 `required init`）：复用池 miss 时由业务 `dequeueReusableCell(as:) ?? MyCell()` 创建。
    open class ReusableCell: UIView {

        public override init(frame: CGRect) {
            super.init(frame: frame)
        }

        public required init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        /// 复用前重置。子类 override 后必须调 `super.prepareForReuse()`。
        open func prepareForReuse() {}
    }
}

extension DTB {

    /// 数据源（复用线，必须协议）。
    ///
    /// 身份是 **index**（类比 tableView 的 indexPath）；frame 由业务算（第二层布局），经 `frameForItemAt` 按需提供。
    public protocol ReusableScrollViewDataSource: AnyObject {

        /// 总 item 数。
        func numberOfItems(in scrollView: ReusableScrollView) -> Int

        /// 第 `index` 个 item 的 frame（内容坐标）。缩放/换布局时业务在此算新值，缓存与否由业务自决。
        func reusableScrollView(_ scrollView: ReusableScrollView, frameForItemAt index: Int) -> CGRect

        /// 第 `index` 个 item 的 cell（复用/新建并配置好）。返回 nil 表示该格不显示。
        func reusableScrollView(_ scrollView: ReusableScrollView, cellForItemAt index: Int) -> UIView?
    }
}

extension DTB {

    /// 可复用滚动容器（SpreadSheet 第一层）：**完全自驱**「纯数学 frame 判断」的离屏回收 / 入屏渲染。
    ///
    /// 唯一职责：按 `frameForItemAt ∩ viewport` 找出可见 index、回收离屏 cell、渲染入屏 cell。布局（frame 怎么算）在业务（第二层）。
    ///
    /// - **自驱（不劫持 delegate）**：offset（KVO `contentOffset`）、contentSize（KVO `contentSize`）、bounds（`layoutSubviews` 尺寸去重）
    ///   三个变化源都自动走**增量** reconcile（回收离屏、渲染入屏、更新仍可见 frame）。`delegate` 原样留给外层（如 3 联动）。
    /// - **数据变化**：index 作 key 无法感知「同 index 内容变了」，业务换数据后须显式调 `reloadData()` 做**全量回收 + 重渲染**。
    /// - 复用：`dequeueReusableCell(as:)` 按 cell 具体类型分桶，miss 返回 nil、由业务创建。
    /// - 内存：cell 由 `visibleCells`（index → cell）字典持有，无 item 对象、无 `cell ↔ 数据` 环。
    public final class ReusableScrollView: UIScrollView {

        public weak var dataSource: ReusableScrollViewDataSource?

        /// 当前可见 cell 数（诊断）。
        public var visibleCellCount: Int { visibleCells.count }

        /// index → cell。
        private var visibleCells: [Int: UIView] = [:]

        /// 复用池：cell 具体类型（metatype 的 `ObjectIdentifier`，每类单例）→ 空闲实例栈。
        private var reuseQueues: [ObjectIdentifier: [UIView]] = [:]

        /// 上次重排时的可见尺寸，`layoutSubviews` 里据此去重。
        private var lastReloadedBoundsSize: CGSize = .zero

        private var offsetObservation: NSKeyValueObservation?
        private var contentSizeObservation: NSKeyValueObservation?

        public override init(frame: CGRect) {
            super.init(frame: frame)
            setupObservations()
        }

        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupObservations()
        }

        private func setupObservations() {
            offsetObservation = observe(\.contentOffset, options: [.new]) { [weak self] _, _ in
                self?.reconcileVisible()
            }
            contentSizeObservation = observe(\.contentSize, options: [.new]) { [weak self] _, _ in
                self?.reconcileVisible()
            }
        }

        public override func layoutSubviews() {
            super.layoutSubviews()
            guard bounds.size != lastReloadedBoundsSize else { return }
            lastReloadedBoundsSize = bounds.size
            reconcileVisible()
        }

        // MARK: - 复用

        /// 出队一个已回收的 `C` 类型 cell（复用路径先 `prepareForReuse()`）；未命中返回 nil，由业务创建。
        public func dequeueReusableCell<C: ReusableCell>(as type: C.Type) -> C? {
            let key = ObjectIdentifier(type)
            var queue = reuseQueues[key] ?? []
            guard !queue.isEmpty else { return nil }
            let cell = queue.removeLast()
            reuseQueues[key] = queue
            (cell as? ReusableCell)?.prepareForReuse()
            return cell as? C
        }

        // MARK: - 重排

        /// 全量：回收所有可见 cell 并重渲染。**数据变化时业务显式调用**（index 作 key 感知不到内容变）。
        public func reloadData() {
            recycleAll()
            reconcileVisible()
        }

        /// 增量：offset / contentSize / bounds 变化自驱调用，diff 回收离屏、渲染入屏、更新仍可见 frame。
        private func reconcileVisible() {
            guard let dataSource = dataSource else {
                reconcile([])
                return
            }
            let count = dataSource.numberOfItems(in: self)
            let viewport = CGRect(origin: contentOffset, size: bounds.size)
            var visible: [(index: Int, frame: CGRect)] = []
            for index in 0..<count {
                let frame = dataSource.reusableScrollView(self, frameForItemAt: index)
                if frame.intersects(viewport) {
                    visible.append((index, frame))
                }
            }
            reconcile(visible)
        }

        private func recycleAll() {
            for cell in visibleCells.values {
                cell.removeFromSuperview()
                reuseQueues[ObjectIdentifier(type(of: cell)), default: []].append(cell)
            }
            visibleCells.removeAll()
        }

        private func reconcile(_ visibleItems: [(index: Int, frame: CGRect)]) {
            let next = Set(visibleItems.map { $0.index })

            // 1. 回收：当前有、下一帧没有的（先收集，避免遍历中改字典）
            var toRecycle: [Int] = []
            for index in visibleCells.keys where !next.contains(index) {
                toRecycle.append(index)
            }
            for index in toRecycle {
                guard let cell = visibleCells.removeValue(forKey: index) else { continue }
                cell.removeFromSuperview()
                reuseQueues[ObjectIdentifier(type(of: cell)), default: []].append(cell)
            }

            // 2. 复用/新建 + 定位（保持 index 顺序）
            for (index, frame) in visibleItems {
                if let cell = visibleCells[index] {
                    cell.frame = frame
                } else {
                    guard let cell = dataSource?.reusableScrollView(self, cellForItemAt: index) else {
                        continue
                    }
                    cell.frame = frame
                    addSubview(cell)
                    visibleCells[index] = cell
                }
            }
        }
    }
}
