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
        
        /// [DEBUG] 调用过程很难直观看出，可以通过 renderLog = [] 然后 print 来观察
        public var renderLog: [String]? = nil
        
        /// 子类实现：根据给定 size 布局子视图，返回自身应有的尺寸（inferSize）。
        ///
        /// - Parameter size: 当前 bounds.size。
        /// - Returns: inferSize；依赖轴无效时返回 `inferSize`（本次不算、不收敛）。
        ///
        /// - size 是非法值(width || height <= 0):
        ///  - 如果能求解出固定大小就返回
        ///  - 如果在某个方向上是要依赖于 size 的，比如 label 折行，就直接返回 size 本身
        ///
        /// - 副作用：设置子视图 frame。
        @discardableResult
        open func layoutInferSize(by size: CGSize) -> CGSize {
            fatalError("Wrong method call, subview must override it!")
        }
        
        open override func layoutSubviews() {
            super.layoutSubviews()
            
            // 不判 bounds.isEmpty：依赖给定轴的子类，副轴（如高度）在第一轮收敛前本来就是 0，
            // 若在此提前 return 会卡死。是否「可算」由子类在 layoutInferSize 内自行判断（依赖轴无效返回 inferSize）。
            let result = layoutInferSize(by: bounds.size)
#if DEBUG
            renderLog?.append("layoutSubviews: bounds.size=\(bounds.size), oldInferSize=\(inferSize), newInferSize=\(result)")
#endif
            guard result != inferSize else {
                return
            }
            inferSize = result
            
            if !translatesAutoresizingMaskIntoConstraints {
#if DEBUG
                renderLog?.append("invalidateIntrinsicContentSize: trigged")
#endif
                invalidateIntrinsicContentSize()
            }
        }
        
        open override var intrinsicContentSize: CGSize {
#if DEBUG
            renderLog?.append("intrinsicContentSize: trigged, inferSize=\(inferSize)")
#endif
            return inferSize
        }
        
        open override func sizeThatFits(_ size: CGSize) -> CGSize {
            let result = layoutInferSize(by: size)
#if DEBUG
            renderLog?.append("sizeThatFits: size=\(size) result=\(result)")
#endif
            return result
        }
    }
}
