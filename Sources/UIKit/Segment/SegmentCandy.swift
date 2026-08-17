//
//  SegmentCandy.swift
//  Ring
//
//  Created by moonShadow on 2026/6/22
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

/// ChildVC 保活，lazy add，切走时仅 isHidden + beginAppearanceTransition(false)
///
/// 使用：
/// ```
/// final class MyVC: DTB.BaseViewController, SegmentCandy {
///     var segment: DTB.SegmentView { ... }
///     var childPages: [UIViewController] { [page0, page1, page2] }
///     var movedIndexes: Set<Int> = []
///
///     func numberOfItems(...) { childPages.count }
///     func segment(_:itemFor:) { DefaultSegmentItem() }
/// }
/// ```
public protocol SegmentCandy: UIViewController, DTB.SegmentViewDataSource, DTB.SegmentViewDelegate {

    var segment: DTB.SegmentView { get }
    var childPages: [UIViewController] { get }
    var movedIndexes: Set<Int> { get set }
    func reloadSegmentData()
}

public extension SegmentCandy {

    // MARK: - reloadData
    
    /// 替代 segment.reloadData()，内部清理 movedIndexes
    func reloadSegmentData() {
        movedIndexes.removeAll()
        segment.reloadData()
    }

    // MARK: - DataSource: pageFor
    
    func segmentItemNumbers(_ view: DTB.SegmentView) -> Int {
        return childPages.count
    }
    
    func segment(_ view: DTB.SegmentView, pageFor index: Int) -> UIView {
        if let cached = view.pageView(at: index) { return cached }

        let child = childPages[index]
        addChild(child)
        return child.view
    }

    // MARK: - Delegate: willHide

    func segment(_ view: DTB.SegmentView, willHidePageAt index: Int) {
        guard index < childPages.count else { return }
        let child = childPages[index]
        child.beginAppearanceTransition(false, animated: false)
        child.endAppearanceTransition()
    }

    // MARK: - Delegate: willShow

    func segment(_ view: DTB.SegmentView, willShowPageAt index: Int) {
        guard index < childPages.count else { return }
        let child = childPages[index]
        
        if !movedIndexes.contains(index) {
            child.didMove(toParent: self)
            movedIndexes.insert(index)
        }
        child.beginAppearanceTransition(true, animated: false)
        child.endAppearanceTransition()
    }

    // MARK: - canSelect / didSelect

    func segment(_ view: DTB.SegmentView, canSelectPageAt index: Int) -> Bool { true }
    func segment(_ view: DTB.SegmentView, didSelectPageAt index: Int) {}
}
