//
//  HomeCell.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/28.
//  Copyright © 2023 darkThanBlack. All rights reserved.
//

import DTBKit

protocol HomeCellData {
    
    var title: String? { get }
    
    var detail: String? { get }
    
    var desc: String? { get }
    
    var jumpable: Bool? { get }
    
    var isSelected: Bool? { get }
}

///
class HomeCell: UITableViewCell {
    
    func update(_ data: HomeCellData?) {
        titleLabel.dtb.text(data?.title).hiddenWhenEmpty()
        descLabel.dtb.text(data?.desc).hiddenWhenEmpty()
        detailLabel.dtb.text(data?.detail).hiddenWhenEmpty()
        rightArrow.isHidden = data?.jumpable == true ? false : true
        selectIcon.isHidden = data?.isSelected == true ? false : true
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
        stacks.backgroundColor = .white
        
        DTB.layout.setPriorityLow(detailLabel, .horizontal)
        
        box.addSubview(stacks)
        stacks.snp.makeConstraints { make in
            make.edges.equalTo(box).inset(UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0))
        }
    }
    
    private lazy var stacks: UIStackView = {
        let stacks = UIStackView(arrangedSubviews: [titleStack, descLabel])
        stacks.axis = .vertical
        stacks.alignment = .fill
        stacks.distribution = .fill
        stacks.spacing = 12.0
        return stacks
    }()
    
    private lazy var titleStack: UIStackView = {
        let stacks = UIStackView(
            arrangedSubviews: [
                titleLabel,
                DTB.layout.getSpacer(.horizontal),
                detailLabel,
                rightArrow,
                selectIcon
            ]
        )
        stacks.axis = .horizontal
        stacks.alignment = .center
        stacks.distribution = .equalSpacing
        stacks.spacing = 8.0
        return stacks
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        label.textColor = .dtb.create("text_title")
        label.text = " "
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11.0, weight: .regular)
        label.minimumScaleFactor = 0.5
        label.textColor = .dtb.create("text_subtitle")
        label.text = " "
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .dtb.create("text_detail")
        label.text = " "
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
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

