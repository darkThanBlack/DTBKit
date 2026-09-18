//
//  SGZoomViewController.swift
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

    /// 缩放对比展示页：同一页展示三种缩放方式，item 用「折行长文字」凸显差异。
    ///
    /// 每个区域有**两个中心红点**：容器中心（固定 overlay，12pt）与内容中心（随内容动，8pt）。
    /// 缩放时若两点重合=中心保持；若分离=中心漂移。
    ///
    /// 1. 纯系统 scrollView zoom：原生 transform，文字位图拉伸、变大变模糊。
    /// 2. `ZoomScrollView` transform：自实现，中心点与系统 zoom 视觉不同。
    /// 3. `ZoomScrollView` frame：reflow，文字变多、不变大。
    final class SGZoomViewController: DTB.BaseViewController {

        private static let longText = "这是一段用于演示缩放差异的长文字。用 transform 缩放时，整段文字被当作位图拉伸，文字本身变大、边缘变模糊，但不会重新排版；用 frame 重排时，文字容器变大，文字会重新折行、展示更多内容，而不是让字体变大。你可以分别捏合三个区域，观察文字在「变模糊」和「变多」之间的差别。"

        private let baseContentSize = CGSize(width: 300, height: 170)

        private var systemContent: DTB.ZoomTextContentView?
        private var transformContent: DTB.ZoomTextContentView?

        override func viewDidLoad() {
            super.viewDidLoad()

            loadViews(in: view)
            buildSections()
        }

        private func buildSections() {
            contentStack.addArrangedSubview(makeTitle("1. 纯系统 scrollView zoom（原生 transform，文字位图拉伸、变模糊）"))
            contentStack.addArrangedSubview(wrapWithCenterDot(systemZoomArea))

            contentStack.addArrangedSubview(makeTitle("2. ZoomScrollView · transform（自实现，中心点与系统 zoom 视觉不同）"))
            contentStack.addArrangedSubview(wrapWithCenterDot(transformZoomArea))

            contentStack.addArrangedSubview(makeTitle("3. ZoomScrollView · frame（reflow：文字变多、不变大）"))
            contentStack.addArrangedSubview(wrapWithCenterDot(frameZoomArea))
        }

        // MARK: - 三个缩放区域

        private lazy var systemZoomArea: UIScrollView = {
            let sv = UIScrollView()
            sv.delegate = self
            sv.minimumZoomScale = 0.5
            sv.maximumZoomScale = 3.0
            sv.backgroundColor = DTB.SampleDepends.bgColor()
            sv.layer.borderWidth = 0.5
            sv.layer.borderColor = DTB.SampleDepends.borderColor().cgColor

            let content = makeTextContent()
            systemContent = content
            sv.addSubview(content)
            sv.contentSize = baseContentSize

            sv.snp.makeConstraints { make in make.height.equalTo(200) }
            return sv
        }()

        private lazy var transformZoomArea: DTB.ZoomScrollView = {
            let sv = DTB.ZoomScrollView()
            sv.update(config: DTB.ZoomConfig(mechanism: .transform))
            sv.zoomDelegate = self
            sv.backgroundColor = DTB.SampleDepends.bgColor()
            sv.layer.borderWidth = 0.5
            sv.layer.borderColor = DTB.SampleDepends.borderColor().cgColor

            let content = makeTextContent()
            transformContent = content
            sv.addSubview(content)
            sv.contentSize = baseContentSize

            sv.snp.makeConstraints { make in make.height.equalTo(200) }
            return sv
        }()

        private lazy var frameContent: DTB.ZoomTextContentView = makeTextContent()

        private lazy var frameZoomArea: DTB.ZoomScrollView = {
            let sv = DTB.ZoomScrollView()
            sv.update(config: DTB.ZoomConfig(mechanism: .frame))
            sv.zoomDelegate = self
            sv.backgroundColor = DTB.SampleDepends.bgColor()
            sv.layer.borderWidth = 0.5
            sv.layer.borderColor = DTB.SampleDepends.borderColor().cgColor

            sv.addSubview(frameContent)
            sv.contentSize = baseContentSize

            sv.snp.makeConstraints { make in make.height.equalTo(200) }
            return sv
        }()

        // MARK: - 内容 / 中心点

        private func makeTextContent() -> DTB.ZoomTextContentView {
            let v = DTB.ZoomTextContentView()
            v.frame = CGRect(origin: .zero, size: baseContentSize)
            v.text = Self.longText
            return v
        }

        /// 给缩放区域包一层，并在「容器中心」放一个固定红点（12pt），标记锚点位置。
        private func wrapWithCenterDot(_ zoomView: UIView) -> UIView {
            let wrapper = UIView()
            wrapper.addSubview(zoomView)
            zoomView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            let dot = makeCenterDot(size: 12)
            wrapper.addSubview(dot)
            dot.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(12)
            }
            return wrapper
        }

        private func makeCenterDot(size: CGFloat) -> UIView {
            let v = UIView()
            v.backgroundColor = DTB.SampleDepends.dangerColor()
            v.layer.cornerRadius = size / 2
            v.layer.masksToBounds = true
            v.layer.borderWidth = 1.0
            v.layer.borderColor = DTB.SampleDepends.text4Color().cgColor
            v.isUserInteractionEnabled = false
            return v
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

            contentStack.addArrangedSubview(makeTopIntroLabel("三种缩放方式：系统 zoom / transform（模糊）/ frame（reflow）。红点重合=中心保持，分离=中心漂移"))
        }

        private func makeTitle(_ text: String) -> UILabel {
            let lb = UILabel()
            lb.text = text
            lb.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.text3Color()
            lb.numberOfLines = 0
            return lb
        }

        private func makeTopIntroLabel(_ text: String) -> UILabel {
            let lb = UILabel()
            lb.text = text
            lb.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.textColor()
            lb.numberOfLines = 0
            return lb
        }

        private lazy var scrollView: UIScrollView = {
            let sv = UIScrollView()
            sv.alwaysBounceVertical = true
            sv.showsVerticalScrollIndicator = false
            return sv
        }()

        private lazy var contentStack: UIStackView = {
            let s = UIStackView()
            s.axis = .vertical
            s.alignment = .fill
            s.distribution = .fill
            s.spacing = 16.0
            return s
        }()
    }
}

// MARK: - 系统 zoom 的 delegate（只对系统 scrollView 生效）

extension DTB.SGZoomViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return systemContent
    }
}

// MARK: - ZoomScrollView 的 delegate（transform / frame 两套自实现缩放）

extension DTB.SGZoomViewController: DTB.ZoomScrollViewDelegate {

    /// transform 机制：返回要缩放的内容视图（类比原生 `viewForZooming`，参数类型是 `DTB.ZoomScrollView` 故与上面不冲突）。
    func viewForZooming(in zoomScrollView: DTB.ZoomScrollView) -> UIView? {
        return transformContent
    }

    /// frame 机制：scale 变化时重排 frameContent + 更新 contentSize（字体不变，文字折行变多）。
    func zoomScrollViewDidChangeScale(_ zoomScrollView: DTB.ZoomScrollView) {
        let s = zoomScrollView.scale
        let w = baseContentSize.width * s
        let h = baseContentSize.height * s
        frameContent.frame = CGRect(x: 0, y: 0, width: w, height: h)
        frameZoomArea.contentSize = CGSize(width: w, height: h)
    }
}

// MARK: - 折行文字内容（含内容中心红点）

extension DTB {

    /// 折行文字内容：含长文字 label + 内容中心红点（8pt）。label 与红点都在 `layoutSubviews` 里随 bounds 重排。
    final class ZoomTextContentView: UIView {

        var text: String = "" {
            didSet { label.text = text }
        }

        private let label = UILabel()
        private let centerDot = UIView()

        override init(frame: CGRect) {
            super.init(frame: frame)

            backgroundColor = DTB.SampleDepends.bg2Color()
            layer.borderWidth = 0.5
            layer.borderColor = DTB.SampleDepends.borderColor().cgColor
            clipsToBounds = true

            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            label.textColor = DTB.SampleDepends.textColor()
            addSubview(label)

            centerDot.backgroundColor = DTB.SampleDepends.dangerColor()
            centerDot.layer.cornerRadius = 4
            centerDot.layer.masksToBounds = true
            centerDot.isUserInteractionEnabled = false
            addSubview(centerDot)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            label.frame = bounds.insetBy(dx: 12, dy: 12)
            centerDot.frame = CGRect(x: bounds.midX - 4, y: bounds.midY - 4, width: 8, height: 8)
        }
    }
}
