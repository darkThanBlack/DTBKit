//
//  MineHeaderView.swift
//  Ring
//
//  Created by moonShadow on 2026/5/26
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

struct MineHeaderViewModel {
    
    var avatar: DTB.ImageModel?
    
    var name: String?
    
    var roles: [String]?
    
    var device: String?
}

protocol MineHeaderViewDelegate: AnyObject {
    
    func mineHeaderViewAvatarEvent()
    
    func mineHeaderViewDeviceEvent()
}

/// 我的 - 头部信息视图
class MineHeaderView: UIView {
    
    weak var delegate: MineHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(_ data: MineHeaderViewModel) {
        if let avatar = data.avatar {
            // FIXME: setup image for button
        } else if let name = data.name, name.isEmpty == false {
            avatarButton.setTitle(name.dtb.last()?.value, for: .normal)
            avatarButton.setImage(nil, for: .normal)
        }
        nicknameLabel.text = data.name
        updateRoles(data.roles ?? [])
    }
    
    func updateRoles(_ roles: [String]?) {
        roleStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
        roles?.forEach({ role in
            let label = DTB.EdgeLabel()
            label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            label.textColor = .dtb.create("text3")
            label.text = role
            label.numberOfLines = 1
            label.textAlignment = .center
            label.edgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
            label.backgroundColor = .dtb.create("bg3")
            roleStackView.addArrangedSubview(label)
        })
    }
    
    // MARK: - Events
    
    @objc private func avatarButtonEvent(_ sender: UIButton) {
        delegate?.mineHeaderViewAvatarEvent()
    }
    
    // MARK: - UI Setup
    
    private func setupSubviews() {
        addSubview(containerView)
        addSubview(avatarButton)
        containerView.addSubview(nicknameLabel)
        containerView.addSubview(roleStackView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.0)
            make.left.equalToSuperview().offset(12.0)
            make.right.equalToSuperview().offset(-12.0)
            make.bottom.equalToSuperview()
        }
        roleStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.bottom.equalToSuperview().offset(-16.0)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.left.equalTo(roleStackView.snp.left)
            make.bottom.equalTo(roleStackView.snp.top).offset(-10.0)
            make.right.lessThanOrEqualToSuperview().offset(-16.0)
        }
        avatarButton.snp.makeConstraints { make in
            make.size.equalTo(80.0)
            make.top.equalToSuperview()
            make.left.equalTo(containerView.snp.left).offset(16.0)
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var avatarButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32.0)
        button.setTitleColor(UIColor.dtb.create("text2"), for: .normal)
        button.backgroundColor = UIColor.dtb.create("bg3")
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.dtb.create("bg2").cgColor
        button.layer.cornerRadius = 40.0
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(avatarButtonEvent), for: .touchUpInside)
        return button
    }()
    
    private lazy var containerView = UIView().dtb
        .backgroundColor(UIColor.dtb.create("bg2"))
        .layer({
            $0.cornerRadius(12.0).masksToBounds(true)
        })
        .value
    
    private lazy var nicknameLabel = UILabel().dtb
        .font(.dtb.create(23.0, weight: .medium))
        .textColor(.dtb.create("text"))
        .numberOfLines(1)
        .value
    
    private func createRoleLabel() -> UILabel {
        return UILabel().dtb.textStyle("detail01")
            .layer({ $0.cornerRadius(11.0) })
            .backgroundColor(.dtb.create("border"))
            .value
    }
    
    private lazy var roleStackView = UIStackView().dtb
        .axis(.horizontal)
        .spacing(10.0)
        .distribution(.equalSpacing)
        .alignment(.center)
        .value
    
}
