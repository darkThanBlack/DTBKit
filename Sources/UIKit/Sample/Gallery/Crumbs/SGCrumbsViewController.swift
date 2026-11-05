//
//  SGCrumbsViewController.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/28
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {
    
    /// Crumbs 展示页：每种 crumb 一张场景矩阵
    ///
    /// crumb 是「列表行模板」，设计为被业务拷走，所以这里只用 scroll + stack 静态展示，不做列表。
    /// 场景按「**内容变化会影响约束**」设计：逐个控件覆盖 正常 / 过长 / 缺失（隐藏）。
    final class SGCrumbsViewController: DTB.BaseViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            loadViews(in: view)
        }
        
        // MARK: - View
        
        private func loadViews(in box: UIView) {
            box.addSubview(scrollView)
            scrollView.addSubview(contentStack)
            
            scrollView.snp.makeConstraints { make in
                make.edges.equalTo(box.safeAreaLayoutGuide)
            }
            /// 卡片左右留白由 card style 的 margin 提供，stack 不再 inset
            contentStack.snp.makeConstraints { make in
                make.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
                make.width.equalTo(scrollView.snp.width)
            }
            
            contentStack.addArrangedSubview(makeHeader("Crumbs：列表行模板，业务拷走后按需改名 / 微调。每张卡是一个场景", isTop: true))
            
            /// 每组只常驻「最完全」的那张（数组第 0 项），其余折叠，点开关行再展开
            appendSceneMatrix(
                "Crumb1　H[ V[Title, Detail] | spacer | RightImage ]",
                scenes: crumb1Scenes(),
                make: { DTB.Crumb1() }
            )
            
            appendSceneMatrix(
                "Crumb3　H[LeftImage, Title, spacer, Detail, RightImage]",
                scenes: crumb3Scenes(),
                make: { DTB.Crumb3() }
            )
        }
        
        // MARK: - 场景矩阵
        
        /// Crumb1：控件 = 标题 / 描述 / 右侧图片（图片内容本身也是变量）
        private func crumb1Scenes() -> [(String, (DTB.Crumb1) -> Void)] {
            let arrow = UIImage.dtb.local("chevron.right")
            let check = UIImage.dtb.local("checkmark.circle.fill")
            
            return [
                ("正常（尾部箭头）", { $0.update(title: "标题", detail: "描述文本", rightImage: arrow) }),
                ("正常（尾部勾选）", { $0.update(title: "标题", detail: "描述文本", rightImage: check) }),
                ("标题过长（折行）", { $0.update(title: "标题标题标题标题标题标题标题标题标题标题标题标题", detail: "描述文本", rightImage: arrow) }),
                ("描述过长（折行）", { $0.update(title: "标题", detail: "描述文本描述文本描述文本描述文本描述文本描述文本描述文本描述文本", rightImage: arrow) }),
                ("标题 + 描述均过长", { $0.update(title: "标题标题标题标题标题标题标题标题标题标题标题标题", detail: "描述文本描述文本描述文本描述文本描述文本描述文本描述文本描述文本", rightImage: arrow) }),
                ("无标题（描述顶上来）", { $0.update(detail: "描述文本", rightImage: arrow) }),
                ("无描述（仅标题）", { $0.update(title: "标题", rightImage: arrow) }),
                ("无文字（仅右图，左列塌陷）", { $0.update(rightImage: arrow) }),
                ("无右图（文字占满）", { $0.update(title: "标题", detail: "描述文本") }),
                ("全空（无文字无右图）", { $0.update() })
            ]
        }
        
        /// Crumb3：控件 = 左图 / 标题 / 描述 / 右图
        private func crumb3Scenes() -> [(String, (DTB.Crumb3) -> Void)] {
            let image = UIImage.dtb.local("moonphase.waxing.crescent")
            
            return [
                ("正常（左图 + 标题 + 描述 + 右图）", { $0.update(leftImage: image, title: "标题", detail: "描述", showRightImage: true) }),
                ("无左图（标题回退到最左）", { $0.update(title: "标题", detail: "描述", showRightImage: true) }),
                ("无描述（标题与右图贴紧）", { $0.update(leftImage: image, title: "标题", showRightImage: true) }),
                ("无右图", { $0.update(leftImage: image, title: "标题", detail: "描述") }),
                ("标题过长（挤压右侧）", { $0.update(leftImage: image, title: "标题标题标题标题标题标题标题标题标题标题标题标题", detail: "描述", showRightImage: true) }),
                ("描述过长（挤压左侧）", { $0.update(leftImage: image, title: "标题", detail: "描述描述描述描述描述描述描述描述描述描述描述描述", showRightImage: true) }),
                ("无文字（仅左右图）", { $0.update(leftImage: image, showRightImage: true) }),
                ("全空（仅右图）", { $0.update(showRightImage: true) })
            ]
        }
        
        // MARK: - 场景矩阵装配
        
        /// 一组场景：常驻「最完全」的第 1 张，其余收进折叠区，由开关行控制
        ///
        /// - Note: 折叠区一开始就建好（18 张卡片本来就是一次性创建，成本可忽略），展开 / 收起只切
        ///   `isHidden` —— UIStackView 会让隐藏的 arranged subview 高度归零并自动重排，不需要增删视图。
        private func appendSceneMatrix<T: UIView>(
            _ title: String,
            scenes: [(String, (T) -> Void)],
            make: () -> T
        ) {
            guard let primary = scenes.first else { return }
            
            contentStack.addArrangedSubview(makeHeader(title))
            
            let (caption, apply) = primary
            let primaryView = make()
            apply(primaryView)
            contentStack.addArrangedSubview(makeCard(caption, primaryView))
            
            guard scenes.count > 1 else { return }
            
            let restStack = UIStackView()
            restStack.axis = .vertical
            restStack.alignment = .fill
            restStack.distribution = .fill
            restStack.spacing = 0.0
            restStack.isHidden = true
            
            for (caption, apply) in scenes.dropFirst() {
                let crumb = make()
                apply(crumb)
                restStack.addArrangedSubview(makeCard(caption, crumb))
            }
            
            contentStack.addArrangedSubview(restStack)
            contentStack.addArrangedSubview(
                SceneToggleRow(restStack: restStack, collapsedCount: scenes.count - 1)
            )
        }
        
        // MARK: - 工具
        
        /// 卡片 = 场景说明 + crumb 本体（视觉走 container_style 的 `dtb.card`）
        private func makeCard(_ caption: String, _ crumb: UIView) -> UIView {
            let captionLabel = UILabel()
            captionLabel.text = caption
            captionLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            captionLabel.textColor = DTB.SampleDepends.text2Color()
            captionLabel.numberOfLines = 0
            
            let stack = UIStackView(arrangedSubviews: [captionLabel, crumb])
            stack.axis = .vertical
            stack.alignment = .fill
            stack.spacing = 8.0
            
            return DTB.Container(child: stack, style: .style("dtb.card"))
        }
        
        /// 分组标题：整宽 + 内部 16pt 留白（不留白的话会和卡片 margin 叠加）
        private func makeHeader(_ text: String, isTop: Bool = false) -> UIView {
            let box = UIView()
            
            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: isTop ? 15.0 : 13.0, weight: .regular)
            label.textColor = isTop ? DTB.SampleDepends.textColor() : DTB.SampleDepends.text3Color()
            label.numberOfLines = 0
            
            box.addSubview(label)
            label.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(
                    UIEdgeInsets(top: isTop ? 16.0 : 24.0, left: 16.0, bottom: 8.0, right: 16.0)
                )
            }
            return box
        }
        
        // MARK: - 懒加载
        
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
            s.spacing = 0.0
            return s
        }()
    }
    
    /// 场景组的「展开 / 收起」开关行（自带状态，只认自己那一组折叠区）
    private final class SceneToggleRow: UIControl {
        
        private weak var restStack: UIStackView?
        
        private let collapsedCount: Int
        
        private let titleLabel: UILabel = {
            let view = UILabel()
            view.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            view.textColor = DTB.SampleDepends.text2Color()
            return view
        }()
        
        private let arrowView: UIImageView = {
            let view = UIImageView(image: UIImage.dtb.local("chevron.down"))
            view.contentMode = .scaleAspectFit
            view.tintColor = DTB.SampleDepends.textDisabledColor()
            return view
        }()
        
        init(restStack: UIStackView, collapsedCount: Int) {
            self.restStack = restStack
            self.collapsedCount = collapsedCount
            super.init(frame: .zero)
            
            titleLabel.setContentHuggingPriority(.required, for: .horizontal)
            
            /// 中间塞一个空 UIView 当弹簧，标题贴左、箭头贴右
            let stack = UIStackView(arrangedSubviews: [titleLabel, UIView(), arrowView])
            stack.axis = .horizontal
            stack.alignment = .center
            stack.distribution = .fill
            stack.spacing = 4.0
            stack.isUserInteractionEnabled = false
            
            addSubview(stack)
            stack.snp.makeConstraints { make in
                /// 左右 32 = 卡片 margin(16) + padding(16)，文字与卡片正文对齐
                make.edges.equalToSuperview().inset(
                    UIEdgeInsets(top: 10.0, left: 32.0, bottom: 10.0, right: 32.0)
                )
            }
            arrowView.snp.makeConstraints { make in
                make.width.height.equalTo(12.0)
            }
            
            addTarget(self, action: #selector(handleTap), for: .touchUpInside)
            
            refresh()

        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc private func handleTap() {
            guard let restStack = restStack else { return }
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseInOut], animations: {
                restStack.isHidden.toggle()
                self.refresh()
                /// 让滚动视图的内容尺寸跟着一起变（被展开 / 收起的卡片也一起动）
                self.window?.layoutIfNeeded()
            })
        }
        
        private func refresh() {
            let isExpanded: Bool = (restStack?.isHidden == false)
            
            titleLabel.text = isExpanded ? "收起" : "展开其余 \(collapsedCount) 个场景"
            arrowView.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
    }
}
