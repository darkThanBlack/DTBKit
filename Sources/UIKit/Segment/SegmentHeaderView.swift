//
//  SegmentHeaderView.swift
//  Ring
//
//  Created by moonShadow on 2026/6/18
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {
    
    public protocol SegmentHeaderViewDelegate: AnyObject {
        
        /// 返回 false 阻止切换
        func segmentHeader(_ view: DTB.SegmentHeaderView, canSelectAt index: Int) -> Bool
        
        /// 已经选中
        func segmentHeader(_ view: DTB.SegmentHeaderView, didSelectAt index: Int)
    }
    
    public protocol SegmentHeaderViewDataSource: AnyObject {
        
        func segmentHeaderItemNumbers(_ header: DTB.SegmentHeaderView) -> Int
        
        func segmentHeader(_ header: DTB.SegmentHeaderView, itemFor index: Int) -> DTB.SegmentItem
    }
}

public extension DTB.SegmentHeaderViewDelegate {
    
    func segmentHeader(_ view: DTB.SegmentHeaderView, canSelectAt index: Int) -> Bool { return true }
}

extension DTB {
    
    /// 基类，子类 override `layoutItems(_:)` 自定义布局
    @objc(DTBSegmentHeaderView)
    open class SegmentHeaderView: UIView {
        
        public weak var dataSource: SegmentHeaderViewDataSource?
        
        public weak var delegate: SegmentHeaderViewDelegate?
        
        public private(set) var itemViews: [DTB.SegmentItem] = []
        
        public private(set) var selectedIndex: Int = 0
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            addGestureRecognizer(tap)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public func setSelectedIndex(_ index: Int, animated: Bool = true) {
            guard let ds = dataSource, index >= 0, index < ds.segmentHeaderItemNumbers(self) else { return }
            for (i, item) in itemViews.enumerated() {
                item.isSelected = i == index
            }
            selectedIndex = index
        }
        
        public func reloadData() {
            selectedIndex = 0
            itemViews.forEach { $0.removeFromSuperview() }
            itemViews.removeAll()
            
            guard let ds = dataSource else { return }
            
            for i in 0..<ds.segmentHeaderItemNumbers(self) {
                let itemView = ds.segmentHeader(self, itemFor: i)
                itemView.tag = i
                itemView.isSelected = i == selectedIndex
                itemViews.append(itemView)
            }
            
            layoutItems(itemViews)
        }
        
        /// 子类重写
        open func layoutItems(_ items: [DTB.SegmentItem]) {
            DTB.console.error("fatal error: 错误的方法调用，或子类没有正确实现")
        }
        
        // 通过触摸位置转化统一处理单击事件
        @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let ds = dataSource else { return }
            
            guard let idx = itemViews.firstIndex(where: {
                $0.bounds.contains(gesture.location(in: $0))
            }) else {
                return
            }
            guard (delegate?.segmentHeader(self, canSelectAt: idx) ?? true) else {
                return
            }
            guard idx >= 0, idx < ds.segmentHeaderItemNumbers(self) else {
                return
            }
            
            for (j, v) in itemViews.enumerated() {
                v.isSelected = j == idx
            }
            selectedIndex = idx
            delegate?.segmentHeader(self, didSelectAt: idx)
        }
    }
}
