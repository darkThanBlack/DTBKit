//
//  LabsArrowRow.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/24
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {
    
    /// Labs 的行：左侧「标题 + 描述」竖排，右侧尾部箭头。
    ///
    /// 由 ``Crumb1``（`tdi_arrow_1`）复制而来——Labs 作为独立展示模块自带一份，
    /// 不依赖 `Crumb*` / `CrumbsView` / `CrumbsType` / `CrumbsTableViewCell` 那条链路。
    ///
    /// 本视图只负责「内容」，卡片视觉由外层 ``Container`` 提供：
    /// ```swift
    /// let row = DTB.LabsArrowRow()
    /// row.update(title: "标题", detail: "描述", showArrow: true)
    /// let card = DTB.Container(child: row, style: .style("dtb.card"))
    /// ```
    final class LabsArrowRow: UIView {
        
        /// 内容
        ///
        /// - Note: `titleAttr` 优先。UILabel 赋 `text` 会清掉富文本，故两者只取其一，不再像
        ///   `Crumb1` 那样两个都塞（`attributedText` 后接 `text` 会把富文本冲掉）。
        func update(
            title: String?,
            titleAttr: NSAttributedString? = nil,
            detail: String?,
            showArrow: Bool
        ) {
            if let titleAttr = titleAttr {
                titleLabel.attributedText = titleAttr
            } else {
                titleLabel.text = title
            }
            titleLabel.dtb.hiddenWithEmptyText()
            
            detailLabel.text = detail
            detailLabel.dtb.hiddenWithEmptyText()
            
            rightImageView.isHidden = (showArrow == false)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            loadViews(in: self)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadViews(in box: UIView) {
            leftStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            rightImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            
            box.addSubview(stacks)
            stacks.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            // 让 textAlgin 控制
            leftStack.arrangedSubviews.forEach({
                $0.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                }
            })
        }
        
        private lazy var stacks: UIStackView = {
            let stacks = UIStackView(arrangedSubviews: [
                leftStack,
                DTB.layout.spacer(),
                rightImageView
            ])
            stacks.axis = .horizontal
            stacks.alignment = .center
            stacks.distribution = .equalSpacing
            stacks.spacing = 8.0
            return stacks
        }()
        
        private lazy var leftStack = UIStackView(arrangedSubviews: [
            titleLabel, detailLabel
        ]).dtb
            .axis(.vertical)
            .alignment(.center)
            .distribution(.equalSpacing)
            .spacing(4.0)
            .value
        
        private lazy var titleLabel = UILabel().dtb.textStyle("dtb.h3").value
        
        private lazy var detailLabel = UILabel().dtb.textStyle("dtb.b6").value
        
        private lazy var rightImageView = UIImageView().dtb
            .tintColor(.dtb.create("dtb.arrow"))
            .image(.dtb.local("chevron.right"))
            .contentMode(.scaleAspectFit)
            .value
    }
}
