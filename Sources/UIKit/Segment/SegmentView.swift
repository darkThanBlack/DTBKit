//
//  SegmentView.swift
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
    
    /// Optional
    public protocol SegmentViewDelegate: AnyObject {
        
        func segment(_ view: DTB.SegmentView, canSelectPageAt index: Int) -> Bool
        
        func segment(_ view: DTB.SegmentView, willHidePageAt index: Int)
        
        func segment(_ view: DTB.SegmentView, willShowPageAt index: Int)
        
        func segment(_ view: DTB.SegmentView, didSelectPageAt index: Int)
    }
    
    /// Required
    public protocol SegmentViewDataSource: AnyObject {
        
        func segmentItemNumbers(_ view: DTB.SegmentView) -> Int
        
        func segmentHeader(_ view: DTB.SegmentView) -> DTB.SegmentHeaderView
        
        func segment(_ view: DTB.SegmentView, itemFor index: Int) -> DTB.SegmentItem
        
        func segment(_ view: DTB.SegmentView, pageFor index: Int) -> UIView
    }
}

public extension DTB.SegmentViewDelegate {
    
    func segment(_ view: DTB.SegmentView, canSelectPageAt index: Int) -> Bool { true }
    func segment(_ view: DTB.SegmentView, willHidePageAt index: Int) {}
    func segment(_ view: DTB.SegmentView, willShowPageAt index: Int) {}
    func segment(_ view: DTB.SegmentView, didSelectPageAt index: Int) {}
}

public extension DTB.SegmentViewDataSource {
    
    func segmentHeader(_ view: DTB.SegmentView) -> DTB.SegmentHeaderView {
        DTB.DefaultSegmentHeader()
    }
}

extension DTB {
    
    @objc(DTBSegmentView)
    public final class SegmentView: UIView {
        
        public weak var dataSource: SegmentViewDataSource?
        public weak var delegate: SegmentViewDelegate?
        
        public private(set) var selectedIndex: Int = 0
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /// 返回已缓存的 page view，nil 表示尚未创建
        public func pageView(at index: Int) -> UIView? {
            guard index >= 0, index < pageViews.count else { return nil }
            return pageViews[index]
        }
        
        public func setSelectedIndex(_ index: Int, animated: Bool = true) {
            guard let ds = dataSource, index >= 0, index < ds.segmentItemNumbers(self) else { return }
            guard index != selectedIndex else { return }
            
            let old = selectedIndex
            selectedIndex = index
            headerView.setSelectedIndex(index, animated: animated)
            showPage(at: index, old: old)
        }
        
        public func reloadData() {
            headerView.removeFromSuperview()
            pageContainer.removeFromSuperview()
            pageViews.removeAll()
            selectedIndex = 0
            
            guard let ds = dataSource else { return }
            
            headerView = ds.segmentHeader(self)
            headerView.dataSource = self
            headerView.delegate = self
            addSubview(headerView)
            addSubview(pageContainer)
            
            headerView.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
            }
            pageContainer.snp.makeConstraints { make in
                make.top.equalTo(headerView.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
            
            pageViews = Array(repeating: nil, count: ds.segmentItemNumbers(self))
            
            guard pageViews.count > 0 else { return }
            headerView.reloadData()
            showPage(at: 0, old: 0)
        }
        
        // MARK: - Private
        
        private lazy var headerView = DTB.SegmentHeaderView()
        
        private lazy var pageContainer: UIView = {
            let v = UIView()
            v.backgroundColor = .clear
            return v
        }()
        
        /// 用 nil 占位作为 lazy load 标记
        private var pageViews: [UIView?] = []
        
        private func showPage(at index: Int, old: Int) {
            guard let ds = dataSource, index < pageViews.count else { return }
            
            // hide old
            if let oldView = pageView(at: old) {
                delegate?.segment(self, willHidePageAt: old)
                oldView.isHidden = true
            }
            
            // 每次调 pageFor，业务更新数据
            let v = ds.segment(self, pageFor: index)
            
            // 首次 addSubview
            if pageViews[index] == nil {
                pageContainer.addSubview(v)
                v.snp.makeConstraints { make in make.edges.equalToSuperview() }
                pageViews[index] = v
            }
            
            // show new
            delegate?.segment(self, willShowPageAt: index)
            v.isHidden = false
            delegate?.segment(self, didSelectPageAt: index)
        }
    }
}

extension DTB.SegmentView: DTB.SegmentHeaderViewDataSource {
    
    public func segmentHeaderItemNumbers(_ header: DTB.SegmentHeaderView) -> Int {
        return dataSource?.segmentItemNumbers(self) ?? 0
    }
    
    public func segmentHeader(_ header: DTB.SegmentHeaderView, itemFor index: Int) -> DTB.SegmentItem {
        dataSource!.segment(self, itemFor: index)
    }
}

extension DTB.SegmentView: DTB.SegmentHeaderViewDelegate {
    
    public func segmentHeader(_ view: DTB.SegmentHeaderView, canSelectAt index: Int) -> Bool {
        delegate?.segment(self, canSelectPageAt: index) ?? true
    }
    
    public func segmentHeader(_ view: DTB.SegmentHeaderView, didSelectAt index: Int) {
        guard index != selectedIndex else { return }
        let old = selectedIndex
        selectedIndex = index
        showPage(at: index, old: old)
    }
}
