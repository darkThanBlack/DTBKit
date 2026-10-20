//
//  Crumb1.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/25
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {
    
    /// ``Crumb1`` 的数据源
    ///
    /// 业务手上的 model 实现它即可（`update(_:)` 一把传入）；
    /// 嫌麻烦就直接用 `update(title:detail:rightImage:)` 传参。
    protocol Crumb1DataSource {
        
        /// 主标题
        var title: String? { get }
        
        /// 副标题
        var detail: String? { get }
        
        /// 右侧图片；nil = 该槽位不显示
        ///
        /// 箭头 / 勾选 / 自定义图标都走它（``Crumb2`` 已并入本类，故不再单设「是否选中」这类业务字段）
        var rightImage: UIImage? { get }
    }
    
    /// 行：左侧「标题 + 描述」竖排，右侧尾部图片
    ///
    /// - 结构：`H[ V[Title, Detail] | spacer | RightImage ]`
    ///
    /// 设计为**被复制**的模板：内部只用原生 API（SnapKit 除外），业务拷走后按需改名 / 微调。
    ///
    /// - Note: 原 ``Crumb2``（右侧为勾选）与本体结构完全相同，已合并；差异只是一个 `rightImage`。
    final class Crumb1: UIView {
        
        // MARK: - Update
        
        /// 数据源入口
        func update(_ dataSource: Crumb1DataSource?) {
            update(
                title: dataSource?.title,
                detail: dataSource?.detail,
                rightImage: dataSource?.rightImage
            )
        }
        
        /// 直接传参：每个参数都有默认值，只传关心的
        func update(title: String? = nil, detail: String? = nil, rightImage: UIImage? = nil) {
            titleLabel.text = title
            titleLabel.isHidden = (title?.isEmpty ?? true)
            
            detailLabel.text = detail
            detailLabel.isHidden = (detail?.isEmpty ?? true)
            
            rightImageView.image = rightImage
            rightImageView.isHidden = (rightImage == nil)
        }
        
        // MARK: - View
        
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
        
        private lazy var leftStack: UIStackView = {
            let stacks = UIStackView(arrangedSubviews: [
                titleLabel, detailLabel
            ])
            stacks.axis = .vertical
            stacks.alignment = .center
            stacks.distribution = .equalSpacing
            stacks.spacing = 4.0
            return stacks
        }()
        
        /// 对应 `text_style.json` 的 `dtb.h3`
        private lazy var titleLabel: UILabel = {
            let lb = UILabel()
            lb.numberOfLines = 0
            lb.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
            lb.textColor = UIColor.dtb.create("dtb.text")
            return lb
        }()
        
        /// 对应 `text_style.json` 的 `dtb.b6`
        private lazy var detailLabel: UILabel = {
            let lb = UILabel()
            lb.numberOfLines = 0
            lb.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            lb.textColor = UIColor.dtb.create("dtb.text2")
            return lb
        }()
        
        private lazy var rightImageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            /// 内容由调用方传入，这里只给主题里的「尾部指示色」作默认
            iv.tintColor = UIColor.dtb.create("dtb.arrow")
            return iv
        }()
    }
}
