//
//  PathBarView.swift
//  DTBKit
//
//  Created by moonShadow on 2026/10/8
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {

    /// 路径条的**问**（有几项 / 第 i 项是什么）
    public protocol PathBarViewDataSource: AnyObject {

        /// 路径深度（含根）
        func pathBarItemNumbers(_ bar: DTB.PathBarView) -> Int

        /// 第 index 层的路径项（0 = 根）；只读它的 `nodeName`
        func pathBar(_ bar: DTB.PathBarView, itemFor index: Int) -> any DTB.PathNode
    }

    /// 路径条的**报**（点了第几项）
    public protocol PathBarViewDelegate: AnyObject {

        /// 返回 false 阻止这次点击（不上报）
        func pathBar(_ bar: DTB.PathBarView, canSelectAt index: Int) -> Bool

        /// 已经点了某一层（当前层不会触发回调）
        func pathBar(_ bar: DTB.PathBarView, didSelectAt index: Int)
    }

    /// 文件路径条
    ///
    /// - 从左到右，可以滚动和点击，边缘有渐隐遮罩和内间距
    /// - 就是 ``SegmentHeaderView`` 的简化版：只认「有几项 / 第 i 项是什么 / 点了第几项」，
    ///   **自己一个数据字段都不存**（`itemViews` 只是它自己造出来的展示视图）。
    ///   于是「现在在哪几层」始终只有业务那一份账（它的路径栈），没有第二份可以对不上。
    @objc(DTBPathBarView)
    public final class PathBarView: UIView {

        public weak var dataSource: (any DTB.PathBarViewDataSource)?

        public weak var delegate: (any DTB.PathBarViewDelegate)?

        /// 当前展示的第 i 项（下标与 dataSource 对齐；分隔符不在其中）
        public private(set) var itemViews: [UILabel] = []

        /// 重新问一遍数据源，并对齐到当前层（最右）
        ///
        /// - Note: 「上游重排」本身就意味着数据刷新过，所以每次刷都对齐到末端，不做「数据没变就别动」的判断。
        public func reloadData() {
            reload()

            scrollToTail()
        }

        public override init(frame: CGRect) {
            super.init(frame: frame)

            loadViews(in: self)
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc private func handleTap(gesture: UITapGestureRecognizer) {
            guard let ds = dataSource else { return }

            /// 命中判定只看自己造出来的 item（分隔符 / 间距不在里面，点了自然没反应）
            guard let index = itemViews.firstIndex(where: { $0.bounds.contains(gesture.location(in: $0)) }) else { return }

            /// 当前层（末项）点了也是原地不动，不回调
            guard index != ds.pathBarItemNumbers(self) - 1 else { return }

            guard (delegate?.pathBar(self, canSelectAt: index) ?? true) else { return }

            delegate?.pathBar(self, didSelectAt: index)
        }

        // MARK: - Views

        /// 首尾留白
        private let contentInset: CGFloat = 16.0

        private func loadViews(in box: UIView) {
            box.backgroundColor = DTB.FileBrowserDepends.backgroundColor()

            box.addSubview(scrollView)
            box.addSubview(leftFade)
            box.addSubview(rightFade)

            scrollView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            leftFade.snp.makeConstraints { make in
                make.top.bottom.left.equalToSuperview()
                make.width.equalTo(contentInset)
            }
            rightFade.snp.makeConstraints { make in
                make.top.bottom.right.equalToSuperview()
                make.width.equalTo(contentInset)
            }
            
            scrollView.addSubview(stack)
            stack.snp.makeConstraints { make in
                make.top.equalTo(scrollView.contentLayoutGuide)
                make.left.equalTo(scrollView.contentLayoutGuide).offset(contentInset)
                make.right.equalTo(scrollView.contentLayoutGuide).offset(-contentInset)
                make.bottom.equalTo(scrollView.contentLayoutGuide)
                make.height.equalTo(scrollView.frameLayoutGuide.snp.height)

                make.height.greaterThanOrEqualTo(36.0)
            }

            /// 条高只由内容决定（见 ``intrinsicContentSize``）：把垂直 hugging 抬到默认 250 之上，
            /// 免得同层的兄弟视图（如 ``FileBrowserView`` 里铺满剩余空间的内容区）把整条拉长。
            setContentHuggingPriority(.defaultHigh, for: .vertical)

            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:))))
        }

        /// 条高由内容决定（`36` 兜底），宽度交给外部
        ///
        /// - Note: 高度**必须自带固有尺寸**，不能只靠 ``stack`` 的 `>= 36` 兜底：
        ///   `UIStackView` 的 `intrinsicContentSize` 是 `(-1, -1)`，而这里又是 `.center` 对齐，
        ///   内容高度压根不会回传到 ``stack`` / `self` 上 —— 「条该多高」于是变成外部约束系统的
        ///   歧义解。兄弟视图一旦有确定的固有高度（如 ``FileBrowserView`` 列表为空、只剩一句
        ///   状态文案时），它就会被拉去占满剩余空间。
        public override var intrinsicContentSize: CGSize {
            return CGSize(width: UIView.noIntrinsicMetric, height: max(36.0, contentHeight()))
        }

        /// 内容的自然高度：取分隔符 / 文字里最高的那个
        private func contentHeight() -> CGFloat {
            var height: CGFloat = 0.0
            for view in stack.arrangedSubviews {
                height = max(height, view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height)
            }
            return height
        }

        /// 滚动到末尾
        ///
        /// - Note: 内容宽用 `systemLayoutSizeFitting` 现算，不读 `scrollView.contentSize`
        ///   （后者只在 scrollView 自己的布局回调里结算，加子视图也不会标脏，实测会读到「少了一项」的旧值）。
        private func scrollToTail() {
            let viewport: CGFloat = bounds.width
            guard viewport > 0.0 else { return }

            let contentWidth: CGFloat = stack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
            + contentInset * 2.0
            guard contentWidth > viewport else { return }

            scrollView.setContentOffset(CGPoint(x: contentWidth - viewport, y: 0.0), animated: false)
        }

        /// 每次重建：视图是框架自己造的展示层，数据一律现问数据源
        private func reload() {
            stack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
            itemViews.removeAll()

            defer { invalidateIntrinsicContentSize() }

            guard let ds = dataSource else { return }

            let numbers: Int = ds.pathBarItemNumbers(self)

            for index in 0..<numbers {
                if index > 0 {
                    let sep = makeSeparator()
                    stack.addArrangedSubview(sep)
                    sep.snp.makeConstraints { make in
                        make.width.equalTo(9.0)
                        make.height.equalTo(12.0)
                    }
                }

                let label = makeItem(node: ds.pathBar(self, itemFor: index), isCurrent: index == numbers - 1)
                stack.addArrangedSubview(label)
                label.setContentHuggingPriority(.required, for: .horizontal)
                label.snp.makeConstraints { make in
                    make.width.lessThanOrEqualTo(200.0)
                }
                itemViews.append(label)
            }
        }

        private func makeItem(node: any DTB.PathNode, isCurrent: Bool) -> UILabel {
            let label = UILabel()
            // 给默认值，用来确保 label.width > 0, 不会出现空节点
            label.text = {
                if let n = node.nodeName, n.isEmpty == false {
                    return n
                }
                return " - "
            }()
            label.numberOfLines = 1
            label.lineBreakMode = .byTruncatingMiddle  // 中间截断
            label.font = isCurrent ? DTB.FileBrowserDepends.pathCurrentFont() : DTB.FileBrowserDepends.pathFont()
            label.textColor = isCurrent ? DTB.FileBrowserDepends.themeColor() : DTB.FileBrowserDepends.lightTextColor()
            return label
        }

        private func makeSeparator() -> UIImageView {
            let view = UIImageView(image: DTB.FileBrowserDepends.arrowImage())
            view.contentMode = .scaleAspectFit
            view.tintColor = DTB.FileBrowserDepends.disabledTextColor()
            view.isUserInteractionEnabled = false
            return view
        }

        private lazy var scrollView: UIScrollView = {
            let view = UIScrollView()
            view.showsHorizontalScrollIndicator = false
            view.showsVerticalScrollIndicator = false
            view.bounces = false
            view.contentInsetAdjustmentBehavior = .never
            view.backgroundColor = .clear
            return view
        }()

        private lazy var stack = UIStackView(arrangedSubviews: []).dtb
            .axis(.horizontal)
            .alignment(.center)
            .distribution(.fill)
            .spacing(6.0)
            .value

        /// 左侧渐隐：贴住视野左边缘，从「背景色」淡到透明
        private lazy var leftFade = FadeView(
            background: DTB.FileBrowserDepends.backgroundColor(),
            reversed: false
        )

        /// 右侧渐隐
        private lazy var rightFade = FadeView(
            background: DTB.FileBrowserDepends.backgroundColor(),
            reversed: true
        )

    }

}

extension DTB.PathBarViewDelegate {

    /// 默认放行
    public func pathBar(_ bar: DTB.PathBarView, canSelectAt index: Int) -> Bool {
        return true
    }
}

extension DTB.PathBarView {

    /// 渐隐遮罩
    @objc(DTBPathBarViewFadeView)
    private final class FadeView: UIView {

        override class var layerClass: AnyClass {
            return CAGradientLayer.self
        }

        init(background: UIColor, reversed: Bool) {
            super.init(frame: .zero)

            isUserInteractionEnabled = false

            let clear: UIColor = background.withAlphaComponent(0.0)
            let gradient = layer as? CAGradientLayer
            gradient?.colors = (reversed ? [clear, background] : [background, clear]).map({ $0.cgColor })
            gradient?.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient?.endPoint = CGPoint(x: 1.0, y: 0.5)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
