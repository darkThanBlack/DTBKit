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

    /// 自身尺寸始终等于 ``UICollectionView`` contentSize 的网格视图。
    ///
    /// 阶段一布局：item 从左到右逐行排列，每行最多 `columnsPerRow` 个；
    /// `item.width = 均分当前宽度`，`item.height = itemHeight`（固定）。
    ///
    /// - Parameters:
    ///   - Cell: 仅注册的一种 cell 类型
    ///   - Item: 数据源元素类型
    public final class SelfSizingGridView<Cell: UICollectionViewCell, Item>: UIView {

        public typealias CellConfig = (_ cell: Cell, _ item: Item, _ index: Int) -> Void

        // MARK: - Config

        private let itemHeight: CGFloat
        private let columnsPerRow: Int
        private let lineGap: CGFloat
        private let columnGap: CGFloat
        private let cellConfig: CellConfig

        // MARK: - Data

        private var items: [Item] = []

        // MARK: - Init

        public init(
            itemHeight: CGFloat,
            columnsPerRow: Int,
            lineGap: CGFloat = 0,
            columnGap: CGFloat = 0,
            cellConfig: @escaping CellConfig
        ) {
            self.itemHeight = itemHeight
            self.columnsPerRow = max(1, columnsPerRow)
            self.lineGap = lineGap
            self.columnGap = columnGap
            self.cellConfig = cellConfig
            super.init(frame: .zero)
            loadViews(in: self)
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - Update

        public func update(_ items: [Item]) {
            self.items = items
            collectionView.reloadData()
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }

        // MARK: - Sizing

        public override var intrinsicContentSize: CGSize {
            let w = bounds.width
            guard w > 0, items.count > 0 else { return CGSize(width: w, height: 0) }
            return CGSize(width: w, height: gridHeight(for: w))
        }

        public override func sizeThatFits(_ size: CGSize) -> CGSize {
            let w = size.width
            guard w > 0, items.count > 0 else { return CGSize(width: w, height: 0) }
            return CGSize(width: w, height: gridHeight(for: w))
        }

        public override func layoutSubviews() {
            super.layoutSubviews()

            guard bounds.width > 0 else { return }

            let colWidth = (bounds.width - CGFloat(columnsPerRow - 1) * columnGap) / CGFloat(columnsPerRow)
            let newSize = CGSize(width: colWidth, height: itemHeight)
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
            let lines = (items.count + columnsPerRow - 1) / columnsPerRow
            guard lines > 0 else { return 0 }
            return CGFloat(lines) * itemHeight + CGFloat(lines - 1) * lineGap
        }

        // MARK: - Subviews

        private lazy var layout: UICollectionViewFlowLayout = {
            let lt = UICollectionViewFlowLayout()
            lt.scrollDirection = .vertical
            lt.itemSize = CGSize(width: 1, height: 1)
            lt.minimumLineSpacing = lineGap
            lt.minimumInteritemSpacing = columnGap
            return lt
        }()

        private lazy var collectionView: UICollectionView = {
            let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .clear
            cv.isScrollEnabled = false
            cv.showsVerticalScrollIndicator = false
            cv.dataSource = self
            cv.delegate = self
            cv.register(Cell.self, forCellWithReuseIdentifier: String(describing: Cell.self))
            return cv
        }()

        private func loadViews(in box: UIView) {
            box.addSubview(collectionView)
            collectionView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalTo(0)
            }
        }
    }
}

// MARK: - UICollectionView

extension DTB.SelfSizingGridView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: Cell.self),
            for: indexPath
        ) as? Cell else {
            return UICollectionViewCell()
        }
        let item = items[indexPath.row]
        cellConfig(cell, item, indexPath.row)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        layout.itemSize
    }
}
