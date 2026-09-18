//
//  SGBaseSelfSizingViewController.swift
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

    /// BaseSelfSizingView 展示页：观察收敛模式下 layoutSubviews / intrinsicContentSize / layoutInferSize 的调用次数（看控制台 DTB__LOG）。
    ///
    /// 三部分：
    /// 1. 无给定轴（单行、内容自算）：inferSize 与给定轴无关，一次 invalidate 即稳定；
    /// 2. 依赖给定轴（换行、撑高依赖宽）：inferSize.height 依赖 bounds.width，多次 invalidate 收敛；
    /// 3. tableview cell 自动算高（预期失败）：系统量高走 systemLayoutSizeFitting，不触发 layoutSubviews，inferSize 恒为 stale。
    final class SGBaseSelfSizingViewController: DTB.BaseViewController {

        /// 单行示例：少量 chip，一行放得下。
        fileprivate static let singleLineChipTexts = ["短", "中等", "稍长一点"]

        /// 换行示例：足够多、长度不一的 chip，逼出多行。
        fileprivate static let wrapChipTexts = [
            "一", "二十二", "三百三十三", "四千四百四十四", "五万五千五百五十五",
            "六", "七十", "八百八十八", "九千九百九十九", "十万"
        ]

        override func viewDidLoad() {
            super.viewDidLoad()
            loadViews(in: view)
        }

        // MARK: - Chip factory

        fileprivate func makeChips(_ texts: [String]) -> [UIView] {
            texts.map { SelfSizingDemoChip(text: $0) }
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

            contentStack.addArrangedSubview(makeTopIntroLabel("BaseSelfSizingView 收敛模式：观察控制台 DTB__LOG 里三个方法的调用次数"))

            contentStack.addArrangedSubview(makeTitle("1. 无给定轴（单行、内容自算，一次收敛）"))
            contentStack.addArrangedSubview(singleLineDemo)

            contentStack.addArrangedSubview(makeTitle("2. 依赖给定轴（换行、撑高依赖宽，多次收敛）"))
            contentStack.addArrangedSubview(wrapDemo)

            contentStack.addArrangedSubview(makeTitle("3. tableview cell 自动算高（预期失败：量高不触发 layoutSubviews）"))
            contentStack.addArrangedSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.height.equalTo(240)
            }
        }

        // MARK: - Demo views

        private lazy var singleLineDemo: SelfSizingDemoView = {
            let v = SelfSizingDemoView()
            v.debugTag = "singleLine"
            v.wrap = false
            v.update(chips: makeChips(Self.singleLineChipTexts))
            return v
        }()

        private lazy var wrapDemo: SelfSizingDemoView = {
            let v = SelfSizingDemoView()
            v.debugTag = "wrap"
            v.wrap = true
            v.update(chips: makeChips(Self.wrapChipTexts))
            return v
        }()

        // MARK: - Table

        private lazy var tableView: UITableView = {
            let tv = UITableView.dtb.plain(self, cells: [DTB.BaseSelfSizingDemoCell.self])
            tv.backgroundColor = .clear
            tv.isScrollEnabled = false
            return tv
        }()

        // MARK: - Labels

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

// MARK: - 表格数据源 / 委托

extension DTB.SGBaseSelfSizingViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DTB.BaseSelfSizingDemoCell = tableView.dtb.dequeueReusableCellEnsured(indexPath)
        cell.config(chips: makeChips(DTB.SGBaseSelfSizingViewController.wrapChipTexts), tag: "cell")
        return cell
    }
}

// MARK: - 示例 chip

extension DTB {

    /// 换行示例用的小 chip：frame 布局，重写 sizeThatFits 自报尺寸。
    final class SelfSizingDemoChip: UIView {

        private static let hPadding: CGFloat = 12.0
        private static let vPadding: CGFloat = 6.0

        init(text: String) {
            super.init(frame: .zero)

            backgroundColor = DTB.SampleDepends.bg3Color()
            layer.cornerRadius = 10.0
            layer.masksToBounds = true

            label.text = text
            addSubview(label)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func sizeThatFits(_ size: CGSize) -> CGSize {
            let s = label.sizeThatFits(size)
            return CGSize(width: s.width + Self.hPadding * 2.0, height: s.height + Self.vPadding * 2.0)
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            guard bounds != .zero else { return }
            let s = label.sizeThatFits(bounds.size)
            label.frame = CGRect(x: Self.hPadding, y: (bounds.height - s.height) / 2.0, width: s.width, height: s.height)
        }

        private lazy var label: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.textColor()
            lb.numberOfLines = 1
            return lb
        }()
    }
}

// MARK: - 示例 self-sizing 视图（BaseSelfSizingView 子类）

extension DTB {

    /// BaseSelfSizingView 的示例子类：验证「无给定轴（单行）/ 依赖给定轴（换行）」两种收敛形态。
    final class SelfSizingDemoView: BaseSelfSizingView {

        /// true = 换行（撑高依赖宽）；false = 单行（内容自算、忽略给定轴）。
        var wrap: Bool = false

        var itemSpacing: CGFloat = 8.0
        var lineSpacing: CGFloat = 8.0

        private var chips: [UIView] = []

        func update(chips: [UIView]) {
            self.chips.forEach { $0.removeFromSuperview() }
            self.chips = chips
            chips.forEach { addSubview($0) }
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }

        override func layoutInferSize(by size: CGSize) -> CGSize {
            if !wrap {
                return layoutSingleLine(by: size)
            }
            // 依赖给定轴：宽度无效（尚未确定）时本次不算，返回 inferSize 表示不收敛。
            guard size.width > 0 else {
                DTB.console.log("[BaseSelfSizing][\(debugTag)] layoutInferSize(by:\(size)) 依赖轴无效 → 返回 inferSize=\(inferSize)")
                return inferSize
            }
            return layoutWrap(by: size)
        }

        /// 无给定轴：忽略 size，宽高都由内容自算，一次即稳定。
        private func layoutSingleLine(by size: CGSize) -> CGSize {
            var x: CGFloat = 0
            var maxH: CGFloat = 0
            for chip in chips {
                let s = chip.sizeThatFits(.zero)
                chip.frame = CGRect(x: x, y: 0, width: s.width, height: s.height)
                x += s.width + itemSpacing
                maxH = max(maxH, s.height)
            }
            let result = CGSize(width: max(0, x - itemSpacing), height: maxH)
            DTB.console.log("[BaseSelfSizing][\(debugTag)] layoutInferSize(singleLine by:\(size)) chips=\(chips.count) → \(result)")
            return result
        }

        /// 依赖给定轴：按 size.width 换行，高度由行数决定。
        private func layoutWrap(by size: CGSize) -> CGSize {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineH: CGFloat = 0
            for chip in chips {
                let s = chip.sizeThatFits(.zero)
                if x > 0 && x + s.width > size.width {
                    x = 0
                    y += lineH + lineSpacing
                    lineH = 0
                }
                chip.frame = CGRect(x: x, y: y, width: s.width, height: s.height)
                x += s.width + itemSpacing
                lineH = max(lineH, s.height)
            }
            let result = CGSize(width: size.width, height: y + lineH)
            DTB.console.log("[BaseSelfSizing][\(debugTag)] layoutInferSize(wrap by:\(size)) chips=\(chips.count) → \(result)")
            return result
        }
    }
}

// MARK: - 示例 cell（验证「自身尺寸撑开 cell 高度」，预期失败）

extension DTB {

    final class BaseSelfSizingDemoCell: BaseTableViewCell {

        func config(chips: [UIView], tag: String) {
            demo.debugTag = tag
            demo.wrap = true
            demo.update(chips: chips)
        }

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.addSubview(demo)
            demo.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.leading.trailing.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().offset(-12)
            }
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private lazy var demo = SelfSizingDemoView()
    }
}
