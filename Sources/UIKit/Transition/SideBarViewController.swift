//
//  SideBarViewController.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/8
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {

    /// 侧边栏抽屉容器父类。
    ///
    /// - 核心特性：
    ///   - 仿抽屉，从左侧滑入的 present 效果
    ///   - 抽屉宽度由 `widthRatio` 控制（相对容器宽度，默认 0.85）
    ///   - 灰色背景 + 点击遮罩关闭由转场层提供
    ///
    /// 子类负责：抽屉内部「背景 / 圆角 / 内容排版」。
    @objc(DTBSideBarViewController)
    open class SideBarViewController: UIViewController {

        /// 业务容器（铺满 presented 视图）
        public lazy var contentView = {
            let v = UIView()
            v.backgroundColor = .clear
            return v
        }()

        /// 抽屉宽度占比（相对容器宽度），创建后不可变，默认 0.85。
        public let widthRatio: CGFloat

        private let transitionHandler: SideBarTransitioningHandler

        public init(widthRatio: CGFloat = 0.85) {
            self.widthRatio = widthRatio
            self.transitionHandler = SideBarTransitioningHandler(widthRatio: widthRatio)
            super.init(nibName: nil, bundle: nil)
            modalPresentationStyle = .custom
            transitioningDelegate = transitionHandler
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        open override func viewDidLoad() {
            super.viewDidLoad()

            loadSubviews(in: view)
        }

        private func loadSubviews(in box: UIView) {
            box.backgroundColor = .clear

            box.addSubview(contentView)
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

    }

}
