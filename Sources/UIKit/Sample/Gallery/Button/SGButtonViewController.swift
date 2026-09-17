//
//  SGButtonViewController.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/10
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {

    /// 叶子 item VC：展示 `DTB.Button`。
    ///
    /// 分两部分：
    /// - 布局展示：参数完全一致、约束不同下的视觉表现（同 `SGLabelViewController`）；
    /// - 业务能力展示：纯文本 / 纯图片 / 自定义间距 / image 相对文字的方向 / image 主轴高度对比。
    final class SGButtonViewController: DTB.BaseViewController {

        /// 示例文字：所有 button 一致、长短适中。
        private let demoText = "这是一段用于演示折行与压缩省略的示例文字"

        private lazy var demoImage: UIImage? = UIImage.dtb.local("checkmark.circle.fill")

        override func viewDidLoad() {
            super.viewDidLoad()

            loadViews(in: view)
        }

        // MARK: - Item (布局 case)

        /// 统一参数的 demo button（纯文本 + 圆角背景）。
        private func makeDemoButton() -> DTB.Button {
            return makeButtonDemo(title: demoText)
        }

        /// 通用 demo button 工厂。
        private func makeButtonDemo(
            title: String? = nil,
            image: UIImage? = nil,
            imageSize: CGSize? = nil,
            imageDirection: DTB.FourDirection = .left,
            contentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        ) -> DTB.Button {
            let b = DTB.Button()
            b.setConfig(DTB.ButtonStyle(
                backgroundColor: DTB.SampleDepends.button3Color(),
                contentEdgeInsets: contentEdgeInsets,
                title: title,
                textColor: DTB.SampleDepends.textColor(),
                font: UIFont.systemFont(ofSize: 13, weight: .regular),
                image: image,
                tintColor: DTB.SampleDepends.themeColor(),
                imageSize: imageSize,
                imageDirection: imageDirection,
                shape: DTB.ShapeStyle(corners: [.allCorners], radius: .fixed(8.0))
            ), for: .normal)
            return b
        }

        /// 布局 case box：标题 + demo button（`layout` 里定 button 的不同约束）。
        private func makeCaseBox(
            title: String,
            fixedHeight: CGFloat?,
            _ layout: (DTB.Button, UILabel) -> Void
        ) -> UIView {
            let box = UIView()
            box.backgroundColor = DTB.SampleDepends.bg2Color()
            box.layer.cornerRadius = 8
            box.clipsToBounds = true

            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            titleLabel.textColor = DTB.SampleDepends.text3Color()

            let demoButton = makeDemoButton()

            box.addSubview(titleLabel)
            box.addSubview(demoButton)

            titleLabel.snp.makeConstraints { make in
                make.leading.top.equalToSuperview().inset(10)
            }

            layout(demoButton, titleLabel)

            if let height = fixedHeight {
                box.snp.makeConstraints { make in
                    make.height.equalTo(height)
                }
            }
            return box
        }

        /// 业务能力 box：标题 + 水平 button 行（顶部对齐）。
        private func makeAbilityBox(title: String, buttons: [UIView]) -> UIView {
            let box = UIView()
            box.backgroundColor = DTB.SampleDepends.bg2Color()
            box.layer.cornerRadius = 8

            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            titleLabel.textColor = DTB.SampleDepends.text3Color()

            let row = UIStackView(arrangedSubviews: buttons)
            row.axis = .horizontal
            row.alignment = .top
            row.distribution = .fill
            row.spacing = 8

            box.addSubview(titleLabel)
            box.addSubview(row)

            titleLabel.snp.makeConstraints { make in
                make.leading.top.equalToSuperview().inset(10)
            }
            row.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(10)
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.bottom.equalToSuperview().inset(10)
            }
            return box
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

            contentStack.addArrangedSubview(makeTopIntroLabel("Button：尺寸由 title + image + contentEdgeInsets 推算；支持 image 方向与偏移"))
            contentStack.addArrangedSubview(makeIntroLabel("布局展示：参数完全一致，仅约束不同"))

            contentStack.addArrangedSubview(makeCaseBox(title: "1. 只约束位置（无尺寸约束，靠 intrinsic 撑开）", fixedHeight: 100) { button, title in
                button.snp.makeConstraints { make in
                    make.leading.equalToSuperview().inset(10)
                    make.top.equalTo(title.snp.bottom).offset(8)
                }
            })

            contentStack.addArrangedSubview(makeCaseBox(title: "2. 靠内容大小撑开其他控件（父容器高度由内容决定）", fixedHeight: nil) { button, title in
                button.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(10)
                    make.top.equalTo(title.snp.bottom).offset(8)
                    make.bottom.equalToSuperview().inset(10)
                }
            })

            contentStack.addArrangedSubview(makeCaseBox(title: "3. 约束过小（宽度不足，内容被压缩折行）", fixedHeight: 150) { button, title in
                button.snp.makeConstraints { make in
                    make.leading.equalToSuperview().inset(10)
                    make.top.equalTo(title.snp.bottom).offset(8)
                    make.width.equalTo(150)
                }
            })

            contentStack.addArrangedSubview(makeCaseBox(title: "4. 约束过大（本身被拉长，内容按对齐方式排列）", fixedHeight: 150) { button, title in
                button.snp.makeConstraints { make in
                    make.leading.equalToSuperview().inset(10)
                    make.top.equalTo(title.snp.bottom).offset(8)
                    make.width.equalTo(280)
                    make.height.equalTo(64)
                }
            })

            contentStack.addArrangedSubview(makeIntroLabel("业务能力展示"))

            contentStack.addArrangedSubview(makeAbilityBox(
                title: "纯文本 / 纯图片 / 自定义间距",
                buttons: [
                    makeButtonDemo(title: "纯文本"),
                    makeButtonDemo(image: demoImage, imageSize: CGSize(width: 20, height: 20)),
                    makeButtonDemo(title: "自定义间距", contentEdgeInsets: UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24))
                ]
            ))

            contentStack.addArrangedSubview(makeAbilityBox(
                title: "image 相对文字的 4 个方向（左 / 右 / 上 / 下）",
                buttons: [
                    makeButtonDemo(title: "左", image: demoImage, imageSize: CGSize(width: 16, height: 16), imageDirection: .left),
                    makeButtonDemo(title: "右", image: demoImage, imageSize: CGSize(width: 16, height: 16), imageDirection: .right),
                    makeButtonDemo(title: "上", image: demoImage, imageSize: CGSize(width: 16, height: 16), imageDirection: .top),
                    makeButtonDemo(title: "下", image: demoImage, imageSize: CGSize(width: 16, height: 16), imageDirection: .bottom)
                ]
            ))

            contentStack.addArrangedSubview(makeAbilityBox(
                title: "image 主轴方向高度 大于 / 小于 文字（折行）",
                buttons: [
                    makeButtonDemo(title: "确定", image: demoImage, imageSize: CGSize(width: 24, height: 24), imageDirection: .left),
                    makeButtonDemo(title: "这是一段会折行成多行的较长文字", image: demoImage, imageSize: CGSize(width: 14, height: 14), imageDirection: .left)
                ]
            ))
        }

        // MARK: - View (lazy)

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
            s.spacing = 16
            return s
        }()

        private func makeIntroLabel(_ text: String) -> UILabel {
            let lb = UILabel()
            lb.text = text
            lb.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.text3Color()
            lb.textAlignment = .left
            lb.numberOfLines = 0
            return lb
        }

        private func makeTopIntroLabel(_ text: String) -> UILabel {
            let lb = UILabel()
            lb.text = text
            lb.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
            lb.textColor = DTB.SampleDepends.textColor()
            lb.textAlignment = .left
            lb.numberOfLines = 0
            return lb
        }
    }
}
