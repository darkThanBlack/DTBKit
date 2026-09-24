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

        /// 第 `index` 个 item 的**基准 frame**（未缩放的布局坐标）。只在缓存失效时被全量拉取一次。
        func reusableScrollView(_ scrollView: ReusableScrollView, frameForItemAt index: Int) -> CGRect

        /// 第 `index` 个 item 的 cell（复用/新建并配置好）。返回 nil 表示该格不显示。
        func reusableScrollView(_ scrollView: ReusableScrollView, cellForItemAt index: Int) -> UIView?
    }
}

extension DTB {

    /// 可复用滚动容器（SpreadSheet 第一层）：**完全自驱**「纯数学 frame 判断」的离屏回收 / 入屏渲染。
    ///
    /// 唯一职责：按 `frame ∩ viewport` 找出可见 index、回收离屏 cell、渲染入屏 cell。布局（frame 怎么算）在业务（第二层）。
    ///
    /// - **frame 缓存**：`frameForItemAt` 只在缓存失效时（首帧 / `reloadData()` / `invalidateFrameCache()`）按 index 顺序全量拉一次；
    ///   之后（含**用户滑动的每一帧**）只做「缓存 frame ∩ 视口」的纯数学比较，不再走协议派发、不再让业务重算 frame。
    /// - **自驱（不劫持 delegate）**：offset / contentSize（KVO）+ bounds（`layoutSubviews` 尺寸去重）三源自动走**增量** reconcile。
    ///   `delegate` 原样留给外层（如 3 联动）。
    /// - **缩放**：继承 `ZoomScrollView`，pinch + 中心点补偿由父类负责。两套机制**共用同一套可见集判断**——把视口 `÷ scale`
    ///   换算回基准坐标系再与缓存 frame 求交；只在「怎么摆」上分叉：
    ///   - `.transform`：cell 保持基准 frame，视觉缩放交给 `contentView` 的 transform（**位图拉伸、文字模糊、不改布局**）。
    ///   - `.frame`：每个可见 cell 摆到 `base × scale`（**矢量、cell 变大 → label 重新折行、文字变多不大**）。
    /// - **内容尺寸**：由缓存 frame 的包围盒推导，自动 × scale（业务不必再手设 `contentSize`）。
    /// - **数据变化**：index 作 key 无法感知「同 index 内容变了」，业务换数据后须显式调 `reloadData()`（= 全量回收 + 重建缓存 + 重渲染）。
    /// - 复用：`dequeueReusableCell(as:)` 按 cell 具体类型分桶，miss 返回 nil、由业务创建。
    public class ReusableScrollView: DTB.ZoomScrollView {

        public weak var dataSource: ReusableScrollViewDataSource?

        /// 当前可见 cell 数（诊断）。
        public var visibleCellCount: Int { visibleCells.count }

        /// 当前缓存的 frame 数（0 = 缓存未建）。
        public var cachedFrameCount: Int { baseFrames?.count ?? 0 }

        /// cell 的唯一父视图 —— 也是 `transform` 机制的作用对象（整块变换，cell 自身 frame 不动）。
        private lazy var contentView: UIView = {
            let v = UIView()
            v.backgroundColor = .clear
            return v
        }()

        /// index → cell。
        private var visibleCells: [Int: UIView] = [:]

        /// 复用池：cell 具体类型（metatype 的 `ObjectIdentifier`，每类单例）→ 空闲实例栈。
        private var reuseQueues: [ObjectIdentifier: [UIView]] = [:]

        /// **基准 frame 缓存**（未缩放坐标）。nil = 未建，下次 reconcile 重建。
        private var baseFrames: [CGRect]?

        /// 基准内容尺寸（缓存 frame 的包围盒）。
        private var baseContentSize: CGSize = .zero

        /// 上次重排时的可见尺寸，`layoutSubviews` 里据此去重。
        private var lastReloadedBoundsSize: CGSize = .zero

        private var offsetObservation: NSKeyValueObservation?
        private var contentSizeObservation: NSKeyValueObservation?

        // MARK: - 性能诊断：只看 reconcileVisible 的执行开销

        /// 最近一次 `reconcileVisible` 的耗时（秒）。
        public private(set) var lastReconcileCost: TimeInterval = 0

        /// `reconcileVisible` 累计耗时（秒）与调用次数（供算均值）。
        public private(set) var reconcileCostTotal: TimeInterval = 0
        public private(set) var reconcileCount: Int = 0

        /// `reconcileVisible` 平均耗时（秒）。
        public var averageReconcileCost: TimeInterval {
            return reconcileCount > 0 ? reconcileCostTotal / Double(reconcileCount) : 0
        }

        /// 清零开销统计（换场景 / 换 zoom 方案前后各调一次，便于对比）。
        public func resetPerf() {
            lastReconcileCost = 0
            reconcileCostTotal = 0
            reconcileCount = 0
        }

        public override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(contentView)
            setupObservations()
        }

        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            addSubview(contentView)
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

        // MARK: - 缩放（继承自 ZoomScrollView）

        /// `transform` 机制：整块基准尺寸的内容容器做变换，cell 自身 frame 不动。
        public override func zoomTargetView() -> UIView? {
            return contentView
        }

        /// `frame` 机制：容器自管 `contentSize` 与 cell 摆位，无需业务参与；转交代理后重排一次可见集。
        public override func zoomDidChangeScale(_ newScale: CGFloat) {
            super.zoomDidChangeScale(newScale)   // 转交业务（业务若让 frame 依赖 scale，应在其中调 invalidateFrameCache()）
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

        /// 全量：失效 frame 缓存、回收所有可见 cell 并重渲染。**数据变化时业务显式调用**（index 作 key 感知不到内容变）。
        public func reloadData() {
            invalidateFrameCache()
            recycleAll()
            reconcileVisible()
        }

        /// 失效 frame 缓存（下次 reconcile 重建）。业务若让 frame 依赖 scale，应在缩放回调里调它。
        public func invalidateFrameCache() {
            baseFrames = nil
            baseContentSize = .zero
        }

        /// 增量：offset / contentSize / bounds / scale 变化自驱调用，diff 回收离屏、渲染入屏、更新仍可见 frame。
        private func reconcileVisible() {
            let t0 = CACurrentMediaTime()
            defer {
                lastReconcileCost = CACurrentMediaTime() - t0
                reconcileCostTotal += lastReconcileCost
                reconcileCount += 1
            }
            guard let dataSource = dataSource else {
                reconcile([])
                return
            }
            // 缓存命中则零协议派发；未建（首帧 / reloadData 后）才全量拉一次
            let frames = baseFrames ?? rebuildFrameCache(dataSource)
            syncLayout()

            guard !frames.isEmpty, bounds.width > 0, bounds.height > 0 else {
                reconcile([])
                return
            }
            let s = max(scale, 0.0001)
            // 视口换算回「基准坐标系」：÷ scale 后与基准 frame 求交 —— 两套机制共用同一套可见集判断
            let viewport = CGRect(
                origin: CGPoint(x: contentOffset.x / s, y: contentOffset.y / s),
                size: CGSize(width: bounds.width / s, height: bounds.height / s)
            )
            // 摆法分叉：transform 位图（frame 保持基准）；frame 矢量（逐格摆到 base × scale，触发 label reflow）
            let layoutScale: CGFloat = (config.mechanism == .frame) ? s : 1.0
            var visible: [(index: Int, frame: CGRect)] = []
            for (index, base) in frames.enumerated() where base.intersects(viewport) {
                visible.append((index, CGRect(
                    x: base.minX * layoutScale,
                    y: base.minY * layoutScale,
                    width: base.width * layoutScale,
                    height: base.height * layoutScale
                )))
            }
            reconcile(visible)
        }

        /// 全量拉取基准 frame（业务算）并缓存；同时推导基准内容尺寸。
        private func rebuildFrameCache(_ dataSource: ReusableScrollViewDataSource) -> [CGRect] {
            let count = dataSource.numberOfItems(in: self)
            guard count > 0 else {
                baseFrames = []
                baseContentSize = .zero
                return []
            }
            var frames: [CGRect] = []
            frames.reserveCapacity(count)
            for index in 0..<count {
                frames.append(dataSource.reusableScrollView(self, frameForItemAt: index))
            }
            baseFrames = frames
            baseContentSize = Self.boundingSize(of: frames)
            return frames
        }

        /// 把 scale 同步到「内容尺寸」与 `contentView`（两套机制摆法不同）。
        private func syncLayout() {
            let s = max(scale, 0.0001)
            let scaled = CGSize(width: baseContentSize.width * s, height: baseContentSize.height * s)

            if contentSize != scaled {
                contentSize = scaled
            }
            // transform 机制保持基准尺寸（视觉缩放靠 transform）；frame 机制直接摆到缩放后尺寸
            let target = (config.mechanism == .frame) ? scaled : baseContentSize
            if contentView.bounds.size != target {
                contentView.transform = .identity
                contentView.layer.anchorPoint = .zero
                contentView.frame = CGRect(origin: .zero, size: target)
            }
            if config.mechanism == .transform {
                let t = CGAffineTransform(scaleX: s, y: s)
                if contentView.transform != t {
                    contentView.transform = t
                }
            }
        }

        private static func boundingSize(of frames: [CGRect]) -> CGSize {
            guard let first = frames.first else { return .zero }
            var maxX = first.maxX
            var maxY = first.maxY
            for frame in frames.dropFirst() {
                maxX = max(maxX, frame.maxX)
                maxY = max(maxY, frame.maxY)
            }
            return CGSize(width: maxX, height: maxY)
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
                    contentView.addSubview(cell)
                    visibleCells[index] = cell
                }
            }
        }
    }
}
