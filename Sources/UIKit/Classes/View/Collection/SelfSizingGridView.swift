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
            self.columnsPerRow = max(1, columnsPerRow)
            self.lineGap = lineGap
            self.columnGap = columnGap
        }
    }

    /// SelfSizingGridView 的数据源协议。
    ///
    /// 继承 ``UICollectionViewDataSource`` + ``UICollectionViewDelegate``，
    /// 并用关联类型声明「本网格注册的唯一 cell 类型」；
    /// ``SelfSizingGridView/setDataSource(_:)`` 读取该类型完成 cell 注册。
    ///
    /// 由业务侧实现（通常是一个 `NSObject` 子类），网格视图本身不实现。
    public protocol SelfSizingGridDataSource: UICollectionViewDataSource, UICollectionViewDelegate {

        /// 唯一注册的 cell 类型
        associatedtype CellType: UICollectionViewCell
    }
}

extension DTB {

    /// 自身尺寸始终等于 ``UICollectionView`` contentSize 的网格视图。
    ///
    /// 阶段一布局：item 从左到右逐行排列，每行最多 `columnsPerRow` 个；
    /// `item.width = 均分当前宽度`，`item.height = itemHeight`（固定）。
    ///
    /// 视图**不持有数据、不实现数据源**：cell 类型与数据都来自
    /// ``SelfSizingGridDataSource``，通过 ``setDataSource(_:)`` 注入。
    ///
    /// 内部 `collectionView` / `layout` 不对外暴露，尺寸由本类独占计算；
    /// 若需要不同的布局行为，应另起一个 view，而不是改这个的内部件。
    ///
    /// - Note: dataSource / delegate 沿用 UIKit 语义为**弱引用**，调用方需自行持有 source。
    /// - Note: 业务 delegate **不要**实现 `sizeForItemAt`，item 尺寸统一由内部 `layout.itemSize` 决定。
    public final class SelfSizingGridView: UIView {

        /// 当前布局配置。
        public private(set) var config: SelfSizingGridConfig

        /// 当前 item 数量（用于公式计算行数）。
        private var itemCount: Int = 0

        // MARK: - Init

        public init(config: SelfSizingGridConfig = SelfSizingGridConfig()) {
            self.config = config
            super.init(frame: .zero)
            loadViews(in: self)
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - Update

        /// 注入数据源：注册 `T.CellType`，并把 dataSource / delegate 指向 source。
        ///
        /// 泛型只落在方法上，视图本身保持非泛型。
        ///
        /// - Parameter source: 遵循 ``SelfSizingGridDataSource`` 的业务对象（**弱引用**，调用方需持有）
        public func setDataSource<T: SelfSizingGridDataSource>(_ source: T) {
            collectionView.register(T.CellType.self, forCellWithReuseIdentifier: String(describing: T.CellType.self))
            collectionView.dataSource = source
            collectionView.delegate = source
            collectionView.reloadData()
        }

        /// 更新布局配置与 item 数量，并刷新高度与内容。
        ///
        /// - Parameters:
        ///   - config: 新的布局配置
        ///   - numberOfItems: 当前数据源 item 总数（用于公式计算行数）
        public func update(_ config: SelfSizingGridConfig, numberOfItems: Int) {
            self.config = config
            self.itemCount = numberOfItems

            layout.minimumLineSpacing = config.lineGap
            layout.minimumInteritemSpacing = config.columnGap

            collectionView.reloadData()
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }

        // MARK: - Sizing

        public override var intrinsicContentSize: CGSize {
            let w = bounds.width
            guard w > 0, itemCount > 0 else { return CGSize(width: w, height: 0) }
            return CGSize(width: w, height: gridHeight(for: w))
        }

        public override func sizeThatFits(_ size: CGSize) -> CGSize {
            let w = size.width
            guard w > 0, itemCount > 0 else { return CGSize(width: w, height: 0) }
            return CGSize(width: w, height: gridHeight(for: w))
        }

        public override func layoutSubviews() {
            super.layoutSubviews()

            guard bounds.width > 0 else { return }

            let columns = config.columnsPerRow
            let colWidth = (bounds.width - CGFloat(columns - 1) * config.columnGap) / CGFloat(columns)
            let newSize = CGSize(width: colWidth, height: config.itemHeight)
            if layout.itemSize != newSize {
                layout.itemSize = newSize
            }

            let h = gridHeight(for: bounds.width)
            collectionView.snp.updateConstraints { make in
                make.height.equalTo(h)
            }
        }

        /// 网格总高度
        private func gridHeight(for width: CGFloat) -> CGFloat {
            let columns = config.columnsPerRow
            let lines = (itemCount + columns - 1) / columns
            guard lines > 0 else { return 0 }
            return CGFloat(lines) * config.itemHeight + CGFloat(lines - 1) * config.lineGap
        }

        // MARK: - Subviews

        private func loadViews(in box: UIView) {
            box.addSubview(collectionView)
            collectionView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalTo(0)
            }
        }

        /// 内部 collectionView，不对外暴露：布局细节由本类独占，外部有额外需求应另起一个 view。
        private lazy var collectionView: UICollectionView = {
            let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .clear
            cv.isScrollEnabled = false
            cv.showsVerticalScrollIndicator = false
            return cv
        }()

        /// 内部 flowLayout，不对外暴露；`itemSize` 由 ``layoutSubviews()`` 按均分宽度实时计算。
        private lazy var layout: UICollectionViewFlowLayout = {
            let lt = UICollectionViewFlowLayout()
            lt.scrollDirection = .vertical
            lt.minimumLineSpacing = config.lineGap
            lt.minimumInteritemSpacing = config.columnGap
            lt.itemSize = CGSize(width: 1, height: config.itemHeight)
            return lt
        }()
    }
}
