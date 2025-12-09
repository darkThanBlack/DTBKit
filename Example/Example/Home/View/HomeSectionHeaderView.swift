//
//  HomeSectionHeaderView.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/28.
//  Copyright © 2023 darkThanBlack. All rights reserved.
//

import DTBKit

protocol HomeSectionHeaderData {
    
    var title: String? { get }
    
    var detail: String? { get }
}

/// 标准的可复用 Demo Section Header View，支持标题和详细描述
class HomeSectionHeaderView: UITableViewHeaderFooterView {
    
    func update(_ data: HomeSectionHeaderData?) {
        titleLabel.dtb.text(data?.title).hiddenWhenEmpty()
        detailLabel.dtb.text(data?.detail).hiddenWhenEmpty()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupSubviews(in: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        titleLabel.text = nil
//        detailLabel.text = nil
//        detailLabel.isHidden = false
//    }
    
    private func setupSubviews(in box: UIView) {
        backgroundView = nil
        backgroundColor = nil
        
        box.addSubview(stacks)
        stacks.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(box)
        }
    }
    
    private lazy var stacks: UIStackView = {
        let stacks = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        stacks.axis = .vertical
        stacks.alignment = .leading
        stacks.distribution = .equalSpacing
        stacks.spacing = 2.0
        return stacks
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
    
}
