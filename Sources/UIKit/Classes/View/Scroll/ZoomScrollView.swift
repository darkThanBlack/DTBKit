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
        /// 位图缩放：对 `viewForZooming` 返回的内容施加 transform，O(1)、模糊、不 reflow。适合「色块/边框/矢量」这类无文字内容。
        case transform
        /// 重排缩放：回调代理 `zoomScrollViewDidChangeScale`，业务重排 frame + 更新 contentSize，清晰、支持 reflow。适合「文字/位图需随尺寸重排」的内容。
        case frame
    }

    /// 缩放配置：静态参数收拢，外层 `update(config:)` 一次刷入。
    public struct ZoomConfig {
        /// 缩放机制。
        public var mechanism: ZoomMechanism = .frame
        /// 缩放下限。
        public var minimumScale: CGFloat = 0.5
        /// 缩放上限。
        public var maximumScale: CGFloat = 3.0

        public init(mechanism: ZoomMechanism = .frame,
                    minimumScale: CGFloat = 0.5,
                    maximumScale: CGFloat = 3.0) {
            self.mechanism = mechanism
            self.minimumScale = minimumScale
            self.maximumScale = maximumScale
        }
    }

    /// 缩放代理：仿原生 `UIScrollViewDelegate` 的 zoom 相关方法。
    /// 独立于 `UIScrollView.delegate`（后者留给外层做多滚动联动等），故用 `zoomDelegate` 挂载。
    public protocol ZoomScrollViewDelegate: AnyObject {

        /// transform 机制：返回要缩放的内容视图（类比原生 `viewForZooming(in:)`）。仅 `.transform` 机制下查询。
        func viewForZooming(in zoomScrollView: ZoomScrollView) -> UIView?

        /// scale 变化后回调（类比原生 `scrollViewDidZoom(_:)`）。
        /// `.frame` 机制下业务在此读 `zoomScrollView.scale` 重排 frame、更新 contentSize。
        func zoomScrollViewDidChangeScale(_ zoomScrollView: ZoomScrollView)
    }

}

public extension DTB.ZoomScrollViewDelegate {
    func viewForZooming(in zoomScrollView: DTB.ZoomScrollView) -> UIView? { nil }
    func zoomScrollViewDidChangeScale(_ zoomScrollView: DTB.ZoomScrollView) {}
}

extension DTB {

    /// 可缩放滚动容器基类（未来 `ReusableScrollView` 的父类）。
    ///
    /// 只做三件事，其余交给业务：
    /// 1. **覆盖缩放手势**：自定义 pinch（禁用原生 zoom / `viewForZooming`），提供 `scale` 替代 `zoomScale`；
    /// 2. **两套缩放机制**：`transform`（位图）/ `frame`（重排），由 `config.mechanism` 开关切换；
    /// 3. **中心点补偿**：缩放后重设 offset 保持视觉中心不变。
    ///
    /// 「是否每帧重排、重排干什么」是业务的事：`frame` 机制里业务在 `zoomScrollViewDidChangeScale` 里重排 frame、更新 `contentSize`，
    /// 中心点 offset 由本类统一算（不归业务）。
    open class ZoomScrollView: UIScrollView {

        // MARK: - 配置

        /// 缩放配置（静态参数唯一入口，通过 `update(config:)` 刷入）。
        public private(set) var config: ZoomConfig = ZoomConfig()

        /// 缩放因子（替代 `zoomScale`），只读；由 pinch 或 `setScale(_:)` 驱动。
        public private(set) var scale: CGFloat = 1.0

        /// 缩放代理（仿 `UIScrollViewDelegate`，与 `delegate` 互不干扰）。
        public weak var zoomDelegate: ZoomScrollViewDelegate?

        // MARK: - 内部状态

        private var gestureStartScale: CGFloat = 1.0

        public override init(frame: CGRect) {
            super.init(frame: frame)
            addGestureRecognizer(pinchGesture)
        }

        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            addGestureRecognizer(pinchGesture)
        }

        /// 一次刷入缩放配置；若当前 scale 超出新范围，收束并重算一次。
        public func update(config: ZoomConfig) {
            self.config = config
            let clamped = min(max(scale, config.minimumScale), config.maximumScale)
            guard abs(clamped - scale) > 0.0005 else { return }
            applyScale(clamped)
        }

        // MARK: - 手势

        @objc private func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
            switch recognizer.state {
            case .began:
                gestureStartScale = scale
            case .changed:
                let newScale = min(max(gestureStartScale * recognizer.scale, config.minimumScale), config.maximumScale)
                guard abs(newScale - scale) > 0.0005 else { return }
                applyScale(newScale)
            default:
                break
            }
        }

        /// 程序化设置 scale（走同一套机制 + 中心点补偿）。
        public func setScale(_ newScale: CGFloat) {
            let clamped = min(max(newScale, config.minimumScale), config.maximumScale)
            guard abs(clamped - scale) > 0.0005 else { return }
            applyScale(clamped)
        }

        // MARK: - 缩放执行

        private func applyScale(_ newScale: CGFloat) {
            let oldContentSize = contentSize
            let oldOffset = contentOffset
            scale = newScale

            switch config.mechanism {
            case .transform:
                applyTransform(newScale)
            case .frame:
                zoomDelegate?.zoomScrollViewDidChangeScale(self)   // 业务重排 frame + 更新 contentSize
            }

            // 中心点补偿（两种机制共用）：把视口中心对应的内容点拉回中心位置
            contentOffset = DTB.ZoomAnchorCompensation.centerOffset(
                viewportSize: bounds.size,
                oldContentSize: oldContentSize,
                newContentSize: contentSize,
                oldOffset: oldOffset
            )
        }

        private func applyTransform(_ s: CGFloat) {
            guard let target = zoomDelegate?.viewForZooming(in: self) else { return }
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
