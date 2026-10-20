//
//  Crumb3.swift
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
    
    /// ``Crumb3`` 的数据源
    ///
    /// 业务手上的 model 实现它即可（`update(_:)` 一把传入）；
    /// 嫌麻烦就直接用 `update(leftImage:title:detail:showRightImage:)` 传参。
    protocol Crumb3DataSource {
        
        /// 左侧图片；nil = 该槽位不显示
        var leftImage: UIImage? { get }
        
        /// 主标题
        var title: String? { get }
        
        /// 副标题
        var detail: String? { get }
        
        /// 是否显示右侧图片
        var showRightImage: Bool { get }
    }
    
    /// 行：前置图 + 标题在左，副标题 + 尾部图片在右
    ///
    /// - 结构：`H[LeftImage, Title, spacer, Detail, RightImage]`
    ///
    /// 设计为**被复制**的模板：内部只用原生 API（SnapKit 除外），业务拷走后按需改名 / 微调。
    final class Crumb3: UIView {
        
        // MARK: - Update
        
        /// 数据源入口
        func update(_ dataSource: Crumb3DataSource?) {
            update(
                leftImage: dataSource?.leftImage,
                title: dataSource?.title,
                detail: dataSource?.detail,
                showRightImage: dataSource?.showRightImage ?? false
            )
        }
        
        /// 直接传参：每个参数都有默认值，只传关心的
        func update(
            leftImage: UIImage? = nil,
            title: String? = nil,
            detail: String? = nil,
            showRightImage: Bool = false
        ) {
            leftImageView.image = leftImage
            leftImageView.isHidden = (leftImage == nil)
            
            titleLabel.text = title
            titleLabel.isHidden = (title?.isEmpty ?? true)
            
            detailLabel.text = detail
            detailLabel.isHidden = (detail?.isEmpty ?? true)
            
            rightImageView.isHidden = (showRightImage == false)
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
            box.addSubview(stacks)
            stacks.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        private lazy var stacks: UIStackView = {
            let stacks = UIStackView(arrangedSubviews: [
                leftImageView,
                titleLabel,
                DTB.layout.spacer(),
                detailLabel,
                rightImageView
            ])
            stacks.axis = .horizontal
            stacks.alignment = .center
            stacks.distribution = .fill
            stacks.spacing = 4.0
            return stacks
        }()
        
        private lazy var leftImageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            return iv
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
            iv.tintColor = UIColor.dtb.create("dtb.arrow")
            iv.image = UIImage.dtb.local("chevron.right")
            return iv
        }()
    }
}
