//
//  HomeCell.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/28.
//  Copyright © 2023 darkThanBlack. All rights reserved.
//

import DTBKit

protocol HomeCellDataSource {
    
    var title: String? { get }
    
    var detail: String? { get }
}

///
class HomeCell: UITableViewCell {
    
    func configCell(_ data: HomeCellDataSource) {
        titleLabel.dtb.text(data.title).hiddenWhenEmpty()
        detailLabel.dtb.text(data.detail).hiddenWhenEmpty()
    }
    
    //MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        loadViews(in: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(titleLabel)
        box.addSubview(rightStack)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(box.snp.left).offset(16.0)
            make.centerY.equalTo(box)
        }
        rightStack.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(16.0)
            make.right.equalTo(box.snp.right).offset(-16.0)
            make.centerY.equalTo(box)
        }
    }
    
    //MARK: Event
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        label.textColor = .dtb.create("text_title")
        label.text = " "
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .dtb.create("text_title")
        label.text = " "
        label.textAlignment = .right
        return label
    }()
    
    private lazy var rightStack: UIStackView = {
        let stacks = UIStackView(arrangedSubviews: [detailLabel, rightArrow, selectIcon])
        stacks.axis = .horizontal
        stacks.alignment = .center
        stacks.distribution = .equalSpacing
        stacks.spacing = 8.0
        return stacks
    }()
    
    private lazy var rightArrow: UIImageView = {
        let view = UIImageView()
        view.tintColor = .dtb.create("text_title")
        if #available(iOS 13.0, *) {
            view.image = UIImage(systemName: "chevron.right")
        } else {
            view.image = UIImage(named: "arrow_right")
        }
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var selectIcon: UIImageView = {
        let view = UIImageView()
        view.tintColor = .dtb.create("theme")
        if #available(iOS 13.0, *) {
            view.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            view.image = UIImage(named: "check_box_select")
        }
        view.contentMode = .scaleAspectFit
        return view
    }()

}

