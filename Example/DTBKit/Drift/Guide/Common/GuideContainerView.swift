//
//  GuideContainerView.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/27
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// 新手引导 - 渐变头部背景 + 右上按钮
class GuideContainerView: UIView {
    
    var title: String? {
        didSet {
            titleLabel.text = (title?.isEmpty == false) ? title : " "  // def height layout
            titleLabel.isHidden = (title?.isEmpty == false) ? false : true
        }
    }
    
    var closeEventHandler: (()->())?
    
    /// 业务页面放在里面
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.isUserInteractionEnabled = true
        return contentView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeButtonEvent(button: UIButton) {
        closeEventHandler?()
    }
    
    //MARK: View
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(
                width: 10.0,
                height: 10.0
            )
        )
        shape.path = path.cgPath
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(gradientImageView)
        box.addSubview(titleLabel)
        box.addSubview(closeImageView)
        box.addSubview(closeButton)
        box.addSubview(contentView)
        
        self.layer.mask = shape
        
        gradientImageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(box)
            make.height.equalTo(gradientImageView.snp.width).multipliedBy(208.0/735.0)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(box.snp.top).offset(12.0)
            make.left.equalTo(box.snp.left).offset(12.0)
        }
        closeImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalTo(box.snp.right).offset(-16.0)
            make.width.height.equalTo(10.0)
        }
        closeButton.snp.makeConstraints { make in
            make.centerX.equalTo(closeImageView.snp.centerX)
            make.centerY.equalTo(closeImageView.snp.centerY)
            make.width.equalTo(50.0)
            make.height.equalTo(50.0)
        }
        contentView.snp.makeConstraints { make in
            make.top.equalTo(closeImageView.snp.bottom).offset(16.0)
            make.left.right.bottom.equalTo(box)
        }
    }
    
    private lazy var shape: CAShapeLayer = {
        let shape = CAShapeLayer()
        return shape
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        titleLabel.textColor = DriftAdapter.color_333333()
        titleLabel.text = " "
        return titleLabel
    }()
    
    private lazy var closeImageView: UIImageView = {
        let closeImageView = UIImageView(image: DriftAdapter.imageNamed("ic_arrow_list_common_down"))
        closeImageView.contentMode = .scaleAspectFit
        return closeImageView
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .custom)
        closeButton.backgroundColor = .clear
        closeButton.addTarget(self, action: #selector(closeButtonEvent(button:)), for: .touchUpInside)
        return closeButton
    }()
    
    private lazy var gradientImageView: UIImageView = {
        let gradientImageView = UIImageView()
        gradientImageView.layer.masksToBounds = true
        gradientImageView.contentMode = .scaleAspectFill
        gradientImageView.image = DriftAdapter.imageNamed("guide_header_bg")
        return gradientImageView
    }()
}
