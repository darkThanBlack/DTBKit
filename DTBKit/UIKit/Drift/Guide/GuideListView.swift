//
//  GuideListView.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/24
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit
import SnapKit

///
class GuideListView: UIView {
    
    //MARK: Interface
    
    //MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeButtonEvent(button: UIButton) {
        Drift.shared.topMost()?.dismiss(animated: true)
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
        layer.mask = shape
        box.addSubview(gradientImageView)
        box.addSubview(closeImageView)
        box.addSubview(closeButton)
        
        loadConstraints(in: box)
    }
    
    private func loadConstraints(in box: UIView) {
        gradientImageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(box)
            make.height.equalTo(gradientImageView.snp.width).multipliedBy(208.0/735.0)
        }
        closeImageView.snp.makeConstraints { make in
            make.top.equalTo(box.snp.top).offset(16.0)
            make.right.equalTo(box.snp.right).offset(-16.0)
        }
        closeButton.snp.makeConstraints { make in
            make.centerX.equalTo(closeImageView.snp.centerX)
            make.centerY.equalTo(closeImageView.snp.centerY)
            make.width.equalTo(50.0)
            make.height.equalTo(50.0)
        }
        
    }
    
    private lazy var shape: CAShapeLayer = {
        let shape = CAShapeLayer()
        return shape
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
        gradientImageView.contentMode = .scaleAspectFill
        gradientImageView.image = DriftAdapter.imageNamed("guide_header_bg")
        return gradientImageView
    }()
}
