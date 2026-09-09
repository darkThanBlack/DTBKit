//
//  AlertViewController.swift
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

    /// alert 转场容器父类。
    ///
    /// - 核心特性：
    ///   - 仿系统，居中的缩放弹出效果
    ///   - card 叠加在 scrim 上层并中心对齐，宽高由子类控制
    ///   - 灰色背景由转场层提供
    ///   - 点击关闭由本身提供（盖一个透明 view）
    ///
    /// 子类负责：对齐方式之外的「背景 / 圆角 / 内容排版」。
    @objc(DTBAlertViewController)
    open class AlertViewController: UIViewController {

        /// 业务容器（透明，中心对齐；宽高由子类约束）
        public lazy var contentView = {
            let v = UIView()
            v.backgroundColor = .clear
            return v
        }()

        /// 透明遮罩（铺满，卡片叠加其上）
        public lazy var maskTapView: UIView = {
            let v = UIView()
            v.backgroundColor = .clear
            let tap = UITapGestureRecognizer(target: self, action: #selector(maskTapped))
            v.addGestureRecognizer(tap)
            return v
        }()

        /// 遮罩点击事件
        ///
        /// 默认不响应；子类可以重写来拦截
        public lazy var maskTapEventHandler: (() -> ())? = nil

        private let transitionHandler = AlertTransitioningHandler()

        public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nil, bundle: nil)
            modalPresentationStyle = .custom
            transitioningDelegate = transitionHandler
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public override func viewDidLoad() {
            super.viewDidLoad()

            loadSubviews(in: view)
        }

        private func loadSubviews(in box: UIView) {
            box.backgroundColor = .clear

            box.addSubview(maskTapView)
            box.addSubview(contentView)

            maskTapView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            contentView.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
        }

        @objc private func maskTapped() {
            maskTapEventHandler?()
        }

    }

}
