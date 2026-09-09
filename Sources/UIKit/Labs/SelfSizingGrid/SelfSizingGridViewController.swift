//
//  SelfSizingGridViewController.swift
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
    
    /// SelfSizingGridView 展示页。
    ///
    /// 一个纵向 stack 里排列多组不同布局配置的网格，展示「自身尺寸 == contentSize」。
    public final class SelfSizingGridViewController: DTB.BaseViewController {
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            setupNavigatonBar(with: .init(title: .dtb.create("dtb.deep.grid")))
            loadViews(in: view)
            buildGrids()
        }
        
        // MARK: - Data
        
        /// 网格 dataSource / delegate 是弱引用，这里负责持有。
        private var sources: [GridDemoSource] = []
        
        private func buildGrids() {
            let groups: [(DTB.SelfSizingGridConfig, [(title: String, detail: String)])] = [
                (
                    .init(itemHeight: 50, columnsPerRow: 2, lineGap: 24, columnGap: 12),
                    [("总收入", "¥1,234"), ("游客数", "3,456"), ("订单数", "789"), ("复购率", "45%")]
                ),
                (
                    .init(itemHeight: 60, columnsPerRow: 3, lineGap: 16, columnGap: 8),
                    [("A", "1"), ("B", "2"), ("C", "3"), ("D", "4"), ("E", "5"), ("F", "6"), ("G", "7")]
                ),
                (
                    .init(itemHeight: 40, columnsPerRow: 4, lineGap: 12, columnGap: 8),
                    [("周一", "晴"), ("周二", "阴"), ("周三", "雨"), ("周四", "晴"), ("周五", "多云"), ("周六", "晴"), ("周日", "晴"), ("周一", "晴")]
                )
            ]
            
            for (config, items) in groups {
                let source = GridDemoSource(items: items)
                sources.append(source)
                
                let grid = DTB.SelfSizingGridView(config: config)
                grid.setDataSource(source)
                
                contentStack.addArrangedSubview(grid)
                grid.update(config, numberOfItems: items.count)
            }
        }
        
        // MARK: - View
        
        private func loadViews(in box: UIView) {
            box.addSubview(scrollView)
            scrollView.addSubview(contentStack)
            
            scrollView.snp.makeConstraints { make in
                make.edges.equalTo(box.safeAreaLayoutGuide)
            }
            contentStack.snp.makeConstraints { make in
                make.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
                make.width.equalTo(scrollView.snp.width).offset(-32)
            }
        }
        
        private lazy var scrollView: UIScrollView = {
            let sv = UIScrollView()
            sv.alwaysBounceVertical = true
            sv.showsVerticalScrollIndicator = false
            return sv
        }()
        
        private lazy var contentStack = UIStackView().dtb
            .axis(.vertical)
            .alignment(.fill)
            .spacing(24)
            .value
    }
}

/// 网格展示页专用数据源：每种布局一份数据，cell 渲染复用 ``DTB.GridCell1``。
///
/// `CellType` 由关联类型声明，网格视图据此完成注册；`reuseIdentifier` 走协议默认实现。
private final class GridDemoSource: NSObject, DTB.SelfSizingGridDataSource {
    
    typealias CellType = DTB.GridCell1
    
    private let items: [(title: String, detail: String)]
    
    init(items: [(String, String)]) {
        self.items = items
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CellType.self), for: indexPath) as? CellType else {
            return UICollectionViewCell()
        }
        let item = items[indexPath.row]
        cell.config(title: item.title, detail: item.detail)
        return cell
    }
}
