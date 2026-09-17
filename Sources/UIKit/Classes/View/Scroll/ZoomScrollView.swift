//
//  ZoomScrollView.swift
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

    /// 缩放机制。
    public enum ZoomMechanism {
        /// 位图缩放：对 `zoomTarget` 施加 transform，O(1)、模糊、不 reflow。适合「色块/边框/矢量」这类无文字内容。
        case transform
        /// 重排缩放：回调 `onScaleChanged`，业务重排 frame + 更新 contentSize，清晰、支持 reflow。适合「文字/位图需随尺寸重排」的内容。
        case frame
    }

    /// 缩放锚点。
    public enum ZoomAnchor {
        /// 屏幕中心。
        case center
        /// 两指中点。
        case finger
    }
}

extension DTB {

    /// 可缩放滚动容器基类（未来 `ReusableScrollView` 的父类）。
    ///
    /// 只做三件事，其余交给业务：
    /// 1. **覆盖缩放手势**：自定义 pinch（禁用原生 zoom / `viewForZooming`），提供 `scale` 替代 `zoomScale`；
    /// 2. **两套缩放机制**：`transform`（位图）/ `frame`（重排），由 `zoomMechanism` 开关切换；
    /// 3. **锚点补偿**：`center` / `finger`，缩放后重设 offset 保持锚点不变。
    ///
    /// 「是否每帧重排、重排干什么」是业务的事：`frame` 机制里业务在 `onScaleChanged` 里重排 frame、更新 `contentSize`，
    /// 锚点 offset 由本类统一算（不归业务）。
    open class ZoomScrollView: UIScrollView {

        // MARK: - 配置

        /// 缩放因子（替代 `zoomScale`），只读；由 pinch 或 `setScale(_:)` 驱动。
        public private(set) var scale: CGFloat = 1.0

        /// 缩放范围（clamp 上下界）。
        public var minimumScale: CGFloat = 0.5
        public var maximumScale: CGFloat = 3.0

        /// 缩放机制开关。
        public var zoomMechanism: ZoomMechanism = .frame

        /// 缩放锚点。
        public var zoomAnchor: ZoomAnchor = .center

        /// `transform` 机制的缩放目标（contentView）。进入 transform 机制时会被设 `anchorPoint = .zero`。
        public weak var zoomTarget: UIView?

        /// `frame` 机制的回调：`scale` 变化时调用，业务在此重排 frame、更新 `contentSize`。
        public var onScaleChanged: ((CGFloat) -> Void)?

        // MARK: - 内部状态

        private var gestureStartScale: CGFloat = 1.0
        private var fingerAnchorPoint: CGPoint = .zero

        public override init(frame: CGRect) {
            super.init(frame: frame)
            addGestureRecognizer(pinchGesture)
        }

        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            addGestureRecognizer(pinchGesture)
        }

        // MARK: - 手势

        @objc private func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
            switch recognizer.state {
            case .began:
                gestureStartScale = scale
                fingerAnchorPoint = recognizer.location(in: self)
            case .changed:
                fingerAnchorPoint = recognizer.location(in: self)
                let newScale = min(max(gestureStartScale * recognizer.scale, minimumScale), maximumScale)
                guard abs(newScale - scale) > 0.0005 else { return }
                applyScale(newScale)
            default:
                break
            }
        }

        /// 程序化设置 scale（走同一套机制 + 锚点补偿）。
        public func setScale(_ newScale: CGFloat) {
            let clamped = min(max(newScale, minimumScale), maximumScale)
            guard abs(clamped - scale) > 0.0005 else { return }
            applyScale(clamped)
        }

        // MARK: - 缩放执行

        private func applyScale(_ newScale: CGFloat) {
            let oldContentSize = contentSize
            let oldOffset = contentOffset
            scale = newScale

            switch zoomMechanism {
            case .transform:
                applyTransform(newScale)
            case .frame:
                onScaleChanged?(newScale)   // 业务重排 frame + 更新 contentSize
            }

            // 锚点补偿（两种机制共用）：把锚点对应的内容点拉回锚点位置
            let anchor: CGPoint
            switch zoomAnchor {
            case .center:
                anchor = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
            case .finger:
                anchor = fingerAnchorPoint
            }
            contentOffset = DTB.ZoomAnchorCompensation.contentOffset(
                anchor: anchor,
                viewportSize: bounds.size,
                oldContentSize: oldContentSize,
                newContentSize: contentSize,
                oldOffset: oldOffset
            )
        }

        private func applyTransform(_ s: CGFloat) {
            guard let target = zoomTarget else { return }
            // 以「内容原点」为锚（anchorPoint = .zero），使视觉内容对齐 contentSize 模型。
            // 注意：改 anchorPoint 会 shift frame（保持 position 不变），须回设 frame；bounds 不受 transform 影响，用它作 base size。
            let baseSize = target.bounds.size
            if target.layer.anchorPoint != .zero {
                target.layer.anchorPoint = .zero
                target.frame = CGRect(origin: .zero, size: baseSize)
            }
            target.transform = CGAffineTransform(scaleX: s, y: s)
            contentSize = CGSize(width: baseSize.width * s, height: baseSize.height * s)
        }

        private lazy var pinchGesture: UIPinchGestureRecognizer = {
            return UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        }()
    }
}
