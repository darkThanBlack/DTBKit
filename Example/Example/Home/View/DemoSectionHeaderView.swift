//
//  DemoSectionHeaderView.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/28.
//  Copyright © 2023 darkThanBlack. All rights reserved.
//

import DTBKit

/// 标准的可复用 Demo Section Header View，支持标题和详细描述
class DemoSectionHeaderView: UITableViewHeaderFooterView {

    static let identifier = String(describing: DemoSectionHeaderView.self)

    // MARK: - Public Methods

    func configure(with model: DemoDescribable) {
        titleLabel.text = model.title
        detailLabel.text = model.detail

        // 根据详细信息是否存在调整布局
        if model.detail?.isEmpty != false {
            detailLabel.isHidden = true
            bottomConstraint.isActive = false
            titleBottomConstraint.isActive = true
        } else {
            detailLabel.isHidden = false
            titleBottomConstraint.isActive = false
            bottomConstraint.isActive = true
        }
    }

    // MARK: - Initialization

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        detailLabel.text = nil
        detailLabel.isHidden = false
    }

    // MARK: - Private Properties

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.dtb.hex(0xF8F8F8)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        label.textColor = UIColor.dtb.hex(0x333333)
        label.numberOfLines = 0
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        label.textColor = UIColor.dtb.hex(0x999999)
        label.numberOfLines = 0
        return label
    }()

    private var bottomConstraint: NSLayoutConstraint!
    private var titleBottomConstraint: NSLayoutConstraint!

    // MARK: - Private Methods

    private func setupViews() {
        backgroundView = UIView()
        backgroundView?.backgroundColor = .white

        setupSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        contentView.addSubview(containerView)
        [titleLabel, detailLabel].forEach { subview in
            containerView.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        // Container View 约束
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        // Title Label 约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12.0),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0)
        ])

        // Detail Label 约束
        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])

        // 动态底部约束
        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 12.0)
        titleBottomConstraint = containerView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.0)

        bottomConstraint.isActive = true
    }
}
