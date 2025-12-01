//
//  MineSimpleItemView.swift
//  tarot
//
//  Created by moonShadow on 2025/11/19
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit
import DTBKit
import SnapKit

protocol MineSimpleItemDelegate {
    
    var key: String? { get }
    
    var title: String? { get }
    
    var detail: String? { get }
    
    var showRightArrow: Bool? { get }
    
    var isSelected: Bool? { get }
}

///
class MineSimpleItemView: UIView {
    
    func update(_ model: MineSimpleItemDelegate?) {
        titleLabel.text = model?.title
        detailLabel.text = model?.detail
        rightArrow.isHidden = (model?.showRightArrow ?? false) ? false : true
        selectIcon.isHidden = (model?.isSelected ?? false) ? false : true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
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
    
    private lazy var rightStack: UIStackView = {
        let stacks = UIStackView(arrangedSubviews: [detailLabel, rightArrow, selectIcon])
        stacks.axis = .horizontal
        stacks.alignment = .center
        stacks.distribution = .equalSpacing
        stacks.spacing = 8.0
        return stacks
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

