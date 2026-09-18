//
//  BaseSelfSizingView.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/17
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {

    /// 作为自定义 View 需要同时支持 Frame 和 AutoLayout 布局方案的唯一实践
    ///
    /// 子类需要在 layoutInferSize 内计算出自身固有大小并返回
    ///
    /// 关键在于通过在 layoutSubviews 里一旦发现 inferSize 变化就通知 autoLayout
    open class BaseSelfSizingView: UIView {

        /// 上一次算出的固有尺寸
        public private(set) var inferSize: CGSize = .zero

        /// 调试标签：同一页面多实例时区分日志（仅调试日志用，不影响布局行为）。
        public var debugTag: String = ""

        #if DEBUG
        /// 调用计数：观察 layoutSubviews / intrinsicContentSize / sizeThatFits 的重新调用开销
        private var layoutSubviewsCallCount = 0
        private var intrinsicContentSizeCallCount = 0
        private var sizeThatFitsCallCount = 0
        #endif

        /// 子类实现：根据给定 size 布局子视图，返回自身应有的尺寸（inferSize）。
        ///
        /// - Parameter size: 当前 bounds.size。
        /// - Returns: inferSize；依赖轴无效时返回 `inferSize`（本次不算、不收敛）。
        /// - 副作用：设置子视图 frame。
        @discardableResult
        open func layoutInferSize(by size: CGSize) -> CGSize {
            return .zero
        }

        open override func layoutSubviews() {
            super.layoutSubviews()

            #if DEBUG
            layoutSubviewsCallCount += 1
            DTB.console.log("[BaseSelfSizing][\(debugTag)] layoutSubviews #\(layoutSubviewsCallCount) bounds=\(bounds.size) inferSize(before)=\(inferSize)")
            #endif

            // 不判 bounds.isEmpty：依赖给定轴的子类，副轴（如高度）在第一轮收敛前本来就是 0，
            // 若在此提前 return 会卡死。是否「可算」由子类在 layoutInferSize 内自行判断（依赖轴无效返回 inferSize）。
            let result = layoutInferSize(by: bounds.size)
            guard result != inferSize else {
                #if DEBUG
                DTB.console.log("[BaseSelfSizing][\(debugTag)]    → inferSize 未变化，不 invalidate")
                #endif
                return
            }
            inferSize = result

            if !translatesAutoresizingMaskIntoConstraints {
                #if DEBUG
                DTB.console.log("[BaseSelfSizing][\(debugTag)]    → inferSize 变为 \(result)，invalidateIntrinsicContentSize")
                #endif
                invalidateIntrinsicContentSize()
            } else {
                #if DEBUG
                DTB.console.log("[BaseSelfSizing][\(debugTag)]    → inferSize 变为 \(result)，TAMIC=true 不 invalidate")
                #endif
            }
        }

        open override var intrinsicContentSize: CGSize {
            #if DEBUG
            intrinsicContentSizeCallCount += 1
            DTB.console.log("[BaseSelfSizing][\(debugTag)] intrinsicContentSize #\(intrinsicContentSizeCallCount) = \(inferSize)")
            #endif
            return inferSize
        }

        open override func sizeThatFits(_ size: CGSize) -> CGSize {
            #if DEBUG
            sizeThatFitsCallCount += 1
            DTB.console.log("[BaseSelfSizing][\(debugTag)] sizeThatFits #\(sizeThatFitsCallCount) size=\(size)")
            #endif
            return layoutInferSize(by: size)
        }
    }
}
