//
//  GuideListCell.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/1
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

protocol GuideListCellDelegate: AnyObject {
    ///
    func cellRightButtonEvent(with cell: UITableViewCell)
}

///
protocol GuideListCellDataSource {
    
    var primaryKey: String? { get }
    
    var title: String? { get }
    
    var detail: String? { get }
    
    var roles: String? { get }
    
    var inferTime: String? { get }
    
    var bizType: GuideListCell.BizTypes { get }
}

/// 新手引导 - 任务列表 Cell
class GuideListCell: UITableViewCell {
    
    /// 仅控制右侧视图展示
    enum BizTypes: CaseIterable {
        ///
        case unknown
        /// web 独占
        case webOnly
        /// 未解锁
        case locked
        /// 需手动确认
        case manually
        /// 去完成
        case pushable
        /// 审核中
        case approve
        /// 已完成
        case finish
        
        var stateIconName: String? {
            switch self {
            case .locked:   return "guide_lock_big"
            case .approve:  return "guide_approve_big"
            case .finish:   return "guide_success_big"
            default: return nil
            }
        }
        
        var stateText: String? {
            switch self {
            case .locked:   return "未解锁"
            case .approve:  return "审核中"
            case .finish:   return "已完成"
            default: return nil
            }
        }
    }
    
    weak var delegate: GuideListCellDelegate?
    
    func config(with model: GuideListCellDataSource?) {
        titleLabel.text = model?.title
        detailLabel.text = model?.detail
        roleLabel.text = model?.roles
        timeLabel.text = model?.inferTime
        
        reload(type: model?.bizType ?? .unknown)
    }
    
    private func reload(type: BizTypes) {
        rightView.subviews.forEach({ $0.isHidden = true })
        timeLabel.isHidden = false
        switch type {
        case .unknown, .webOnly:
            // 文字
            rightHintLabel.isHidden = false
            rightHintLabel.text = type == .webOnly ? "请前往 Web 端完成该任务" : "-"
        case .locked, .approve, .finish:
            // icon + 文字
            rightStateIcon.isHidden = false
            rightStateLabel.isHidden = false
            
            if let name = type.stateIconName {
                rightStateIcon.image = DriftAdapter.imageNamed(name)
            }
            rightStateLabel.text = type.stateText
        case .manually, .pushable:
            // 按钮
            rightButton.isHidden = false
            
            if type == .manually {
                rightButton.setTitle("确认完成", for: .normal)
            }
            if type == .pushable {
                rightButton.setTitle("去完成", for: .normal)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        contentView.addSubview(cardBox)
        contentView.backgroundColor = DriftAdapter.color_FAFAFA()
        cardBox.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.bottom.equalToSuperview().offset(-16.0)
        }
        loadViews(in: cardBox)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func rightButtonEvent(button: UIButton) {
        delegate?.cellRightButtonEvent(with: self)
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(titleLabel)
        box.addSubview(detailLabel)
        box.addSubview(roleIcon)
        box.addSubview(roleLabel)
        box.addSubview(rightView)
        
        loadRightSubViews(in: rightView)
        rightView.subviews.forEach({ $0.isHidden = true })
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(box.snp.top).offset(16.0)
            make.left.equalTo(box.snp.left).offset(16.0)
            make.right.equalTo(rightView.snp.left).offset(-16.0)
        }
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            make.left.equalTo(titleLabel.snp.left)
            make.width.lessThanOrEqualTo(titleLabel.snp.width)
        }
        roleIcon.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(detailLabel.snp.bottom).offset(16.0)
            make.left.equalTo(titleLabel.snp.left)
            make.bottom.equalTo(box.snp.bottom).offset(-18.0)
            make.width.height.equalTo(14.0)
        }
        roleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(roleIcon.snp.centerY)
            make.left.equalTo(roleIcon.snp.right).offset(4.0)
            make.right.lessThanOrEqualTo(titleLabel.snp.right).offset(-0)
        }
        rightView.snp.makeConstraints { make in
            make.top.equalTo(box.snp.top).offset(16.0)
            make.right.equalTo(box.snp.right).offset(-0)
            make.bottom.equalTo(box.snp.bottom).offset(-16.0)
            make.width.equalTo(110.0)
        }
    }
    
    /// 右侧布局
    private func loadRightSubViews(in box: UIView) {
        box.addSubview(rightHintLabel)
        box.addSubview(rightButton)
        box.addSubview(rightStateIcon)
        box.addSubview(rightStateLabel)
        
        box.addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.bottom.equalTo(box.snp.bottom).offset(0.0)
            make.width.lessThanOrEqualTo(box.snp.width).offset(-24.0)
        }
        
        rightHintLabel.snp.makeConstraints { make in
            make.top.equalTo(box.snp.top).offset(8.0)
            make.left.equalTo(box.snp.left).offset(12.0)
            make.right.equalTo(box.snp.right).offset(-12.0)
            
            make.bottom.lessThanOrEqualTo(timeLabel.snp.top).offset(-8.0)
        }
        rightButton.snp.makeConstraints { make in
            make.top.equalTo(box.snp.top).offset(12.0)
            make.centerX.equalTo(box.snp.centerX)
            make.width.lessThanOrEqualTo(box.snp.width)
            
            make.bottom.lessThanOrEqualTo(timeLabel.snp.top).offset(-8.0)
        }
        rightStateIcon.snp.makeConstraints { make in
            make.top.centerX.equalTo(box)
            make.width.height.equalTo(32.0)
        }
        rightStateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(rightStateIcon.snp.centerX)
            make.top.equalTo(rightStateIcon.snp.bottom).offset(4.0)
            
            make.bottom.lessThanOrEqualTo(timeLabel.snp.top).offset(-8.0)
        }
    }
    
    /// 圆角卡片背景
    private lazy var cardBox: UIView = {
        let cardBox = UIView()
        cardBox.backgroundColor = .white
        cardBox.layer.masksToBounds = true
        cardBox.layer.cornerRadius = 5.0
        return cardBox
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        titleLabel.textColor = DriftAdapter.color_333333()
        return titleLabel
    }()
    
    private lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        detailLabel.textColor = DriftAdapter.color_666666()
        detailLabel.numberOfLines = 0
        return detailLabel
    }()
    
    private lazy var roleIcon: UIImageView = {
        let roleIcon = UIImageView()
        roleIcon.image = DriftAdapter.imageNamed("guide_role")
        roleIcon.contentMode = .scaleAspectFit
        return roleIcon
    }()
    
    private lazy var roleLabel: UILabel = {
        let roleLabel = UILabel()
        roleLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        roleLabel.textColor = DriftAdapter.color_999999()
        return roleLabel
    }()
    
    /// 耗时
    private lazy var timeLabel: XMEdgeLabel = {
        let timeLabel = XMEdgeLabel()
        timeLabel.backgroundColor = DriftAdapter.color_FAFAFA()
        timeLabel.font = UIFont.systemFont(ofSize: 11.0, weight: .regular)
        timeLabel.textColor = DriftAdapter.color_999999()
        timeLabel.numberOfLines = 0
        timeLabel.textAlignment = .center
        
        timeLabel.edgeInsets = UIEdgeInsets(top: 2.0, left: 4.0, bottom: 2.0, right: 4.0)
        timeLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = 2.0
        return timeLabel
    }()
    
    /// 右侧容器
    private lazy var rightView: UIView = {
        let rightView = UIView()
        return rightView
    }()
    
    /// 仅文字
    private lazy var rightHintLabel: UILabel = {
        let rightHintLabel = UILabel()
        rightHintLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        rightHintLabel.textColor = DriftAdapter.color_999999()
        rightHintLabel.numberOfLines = 0
        rightHintLabel.textAlignment = .center
        return rightHintLabel
    }()
    
    /// 仅按钮
    private lazy var rightButton: UIButton = {
        let rightButton = UIButton(type: .custom)
        rightButton.contentEdgeInsets = UIEdgeInsets(top: 6.0, left: 16.0, bottom: 6.0, right: 16.0)
        rightButton.backgroundColor = DriftAdapter.color_FFAB1A()
        rightButton.setTitleColor(.white, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        rightButton.layer.masksToBounds = true
        rightButton.layer.cornerRadius = 4.0
        rightButton.addTarget(self, action: #selector(rightButtonEvent(button:)), for: .touchUpInside)
        return rightButton
    }()
    
    /// 状态 icon
    private lazy var rightStateIcon: UIImageView = {
        let rightStateIcon = UIImageView()
        rightStateIcon.contentMode = .scaleAspectFit
        return rightStateIcon
    }()
    
    /// 状态文字
    private lazy var rightStateLabel: UILabel = {
        let rightStateLabel = UILabel()
        rightStateLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        rightStateLabel.textColor = DriftAdapter.color_666666()
        rightStateLabel.textAlignment = .center
        return rightStateLabel
    }()
}

