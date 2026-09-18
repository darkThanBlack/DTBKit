//
//  FlowDemoConstraintItem.swift
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

    /// 约束 item 的示例：内部用 Auto Layout 自报尺寸。
    ///
    /// 与 ``FlowDemoItem``（frame 布局、重写 `sizeThatFits`）互补——本 item 不重写 `sizeThatFits`，
    /// 尺寸由「titleLabel 钉边约束 + label 固有尺寸」经 `systemLayoutSizeFitting` 求解得出，
    /// 这正是 ``SelfSizingFlowView`` 测量路径（`systemLayoutSizeFitting(layoutFittingCompressedSize)`）真正支持的形态。
    ///
    /// 关键点：item 自身保持 `translatesAutoresizingMaskIntoConstraints = true`（可被容器按 frame 定位），
    /// 只有子视图 titleLabel 进入约束系统（SnapKit 自动置 false）。
    public final class FlowDemoConstraintItem: UIView {

        private static let hPadding: CGFloat = 14.0
        private static let vPadding: CGFloat = 7.0

        public func config(title: String?, fontSize: CGFloat = 13.0) {
            titleLabel.text = title
            titleLabel.font = .systemFont(ofSize: fontSize)
        }

        public override init(frame: CGRect) {
            super.init(frame: frame)

            backgroundColor = DTB.SampleDepends.bg3Color()
            layer.masksToBounds = true
            layer.cornerRadius = 10.0

            loadViews(in: self)
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func loadViews(in box: UIView) {
            box.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(Self.vPadding)
                make.bottom.equalToSuperview().offset(-Self.vPadding)
                make.leading.equalToSuperview().offset(Self.hPadding)
                make.trailing.equalToSuperview().offset(-Self.hPadding)
            }
        }

        private lazy var titleLabel: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.text2Color()
            lb.numberOfLines = 1
            return lb
        }()
    }
}
