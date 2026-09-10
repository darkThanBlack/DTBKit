//
//  SGColorCell.swift
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

    /// 颜色 cell：key + light / dark / auto_dark 三色块。
    ///
    /// 三列固定宽度，与 `SGColorViewController` 的表头对齐。
    final class SGColorCell: DTB.BaseTableViewCell {

        static let columnWidth: CGFloat = 64

        static let swatchSize: CGFloat = 32

        func config(key: String, light: UIColor, dark: UIColor?, autoDark: UIColor) {
            keyLabel.text = key
            lightSwatch.backgroundColor = light
            darkSwatch.backgroundColor = dark ?? .clear
            // 无显式 dark 时给个描边，示意「未配置」
            darkSwatch.layer.borderColor = (dark == nil)
                ? UIColor.dtb.create("dtb.border").cgColor
                : UIColor.clear.cgColor
            autoDarkSwatch.backgroundColor = autoDark
        }

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            loadViews(in: contentView)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func loadViews(in box: UIView) {
            box.addSubview(keyLabel)
            box.addSubview(swatchStack)

            keyLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
            }
            swatchStack.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
                make.top.bottom.equalToSuperview().inset(12)
                make.width.equalTo(Self.columnWidth * 3)
            }
        }

        private lazy var keyLabel: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            lb.textColor = .dtb.create("dtb.text")
            return lb
        }()

        private lazy var swatchStack = UIStackView(arrangedSubviews: [
            wrap(lightSwatch), wrap(darkSwatch), wrap(autoDarkSwatch)
        ]).dtb.axis(.horizontal).distribution(.fillEqually).alignment(.center).value

        private func wrap(_ swatch: UIView) -> UIView {
            let box = UIView()
            box.addSubview(swatch)
            swatch.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(Self.swatchSize)
            }
            return box
        }

        private let lightSwatch = makeSwatch()

        private let darkSwatch = makeSwatch()

        private let autoDarkSwatch = makeSwatch()

        private static func makeSwatch() -> UIView {
            let v = UIView()
            v.layer.cornerRadius = 8
            v.clipsToBounds = true
            v.layer.borderWidth = 1
            v.layer.borderColor = UIColor.clear.cgColor
            return v
        }
    }
}
