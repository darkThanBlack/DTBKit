//
//  DefaultSegmentHeader.swift
//  Ring
//
//  Created by moonShadow on 2026/6/22
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {

    @objc(DTBDefaultSegmentHeaderView)
    public final class DefaultSegmentHeader: SegmentHeaderView {

        private var isScrollMode: Bool = false
        private let stackSpacing: CGFloat = 0

        // MARK: - LayoutItems

        public override func layoutItems(_ items: [DTB.SegmentItem]) {
            isScrollMode = false
            items.forEach { stack.addArrangedSubview($0) }
            setNeedsLayout()
        }

        // MARK: - Layout

        public override func layoutSubviews() {
            super.layoutSubviews()

            guard bounds.width > 0, !itemViews.isEmpty else { return }

            let spacing = stackSpacing * CGFloat(max(itemViews.count - 1, 0))
            let totalContent = itemViews.reduce(CGFloat(0)) { sum, item in
                sum + item.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
            } + spacing

            let needsScroll = totalContent > bounds.width
            if needsScroll != isScrollMode {
                isScrollMode = needsScroll
                applyModeConstraints()
            }
        }

        private func applyModeConstraints() {
            stack.removeFromSuperview()

            if isScrollMode {
                scrollView.addSubview(stack)
                scrollView.isScrollEnabled = true
                stack.snp.remakeConstraints { make in
                    make.edges.equalToSuperview()
                    make.height.equalToSuperview()
                }
                stack.distribution = .fill
            } else {
                addSubview(stack)
                scrollView.isScrollEnabled = false
                stack.snp.remakeConstraints { make in
                    make.edges.equalToSuperview()
                }
                stack.distribution = .fillEqually
            }
        }

        // MARK: - Init

        public override init(frame: CGRect) {
            super.init(frame: frame)
            loadViews(in: self)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - View

        private func loadViews(in box: UIView) {
            box.addSubview(scrollView)
            box.addSubview(stack)

            scrollView.snp.makeConstraints { make in make.edges.equalToSuperview() }
            stack.snp.makeConstraints { make in make.edges.equalToSuperview() }
        }

        private lazy var scrollView: UIScrollView = {
            let sv = UIScrollView()
            sv.showsHorizontalScrollIndicator = false
            sv.showsVerticalScrollIndicator = false
            sv.bounces = false
            return sv
        }()

        private lazy var stack = UIStackView(arrangedSubviews: []).dtb
            .axis(.horizontal)
            .alignment(.center)
            .distribution(.fillEqually)
            .value
    }
}
