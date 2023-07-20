//
//  GuideDriftView.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/19
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
class GuideDriftView: UIView {
    
    //MARK: Interface
    
    func fireAbsorb() {
        let newFrame = absorbHorizonal(frame, barrier: superview?.bounds ?? UIScreen.main.bounds)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut) {
            self.frame = newFrame
        } completion: { _ in
            // delay?
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View
    
    override var intrinsicContentSize: CGSize {
        return contentView.intrinsicContentSize
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return contentView.sizeThatFits(size)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(contentView)
    }
    
    private lazy var contentView: GuideDriftContentView = {
        let contentView = GuideDriftContentView()
        return contentView
    }()
    
    //MARK: - touches
    
    ///
    private var op: CGPoint = .zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else {
            return
        }
        op = p
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else {
            return
        }
        var tmp = frame
        tmp.origin.x += (p.x - op.x)
        tmp.origin.y += (p.y - op.y)
        frame = tmp
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireAbsorb()
    }
    
    /// 越界
    private func frameInside(value: CGRect, barrier: CGRect) -> CGRect {
        var newFrame = value
        
        if newFrame.origin.x < 0 {
            newFrame.origin.x = 0
        }
        
        if newFrame.origin.x > (barrier.size.width - newFrame.size.width) {
            newFrame.origin.x = barrier.size.width - newFrame.size.width
        }
        
        if newFrame.origin.y < 0 {
            newFrame.origin.y = 0
        }
        
        if newFrame.origin.y > (barrier.size.height - newFrame.size.height) {
            newFrame.origin.y = barrier.size.height - newFrame.size.height
        }
        
        return newFrame
    }
    
    /// 横向吸附
    private func absorbHorizonal(_ value: CGRect, barrier: CGRect) -> CGRect {
        var newFrame = frameInside(value: value, barrier: barrier)
        
        if newFrame.midX > barrier.width / 2.0 {
            newFrame.origin.x = barrier.width - newFrame.size.width
        } else {
            newFrame.origin.x = 0
        }
        
        return newFrame
    }
}

//MARK: -

///
class GuideDriftContentView: UIView {
    
    //MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeButtonEvent(button: UIButton) {
        Drift.shared.stop()
    }
    
    //MARK: View
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 32.0, height: 22 + 8 + 104)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 32.0, height: 22 + 8 + 104)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleWidth: CGFloat = 32.0
        let closeSide: CGFloat = 11.0
        
        closeImageView.bounds = CGRect(x: 0, y: 0, width: closeSide, height: closeSide)
        closeImageView.center = CGPoint(x: titleWidth / 2.0, y: closeSide / 2.0)
        
        closeButton.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        closeButton.center = closeImageView.center
        
        let titleSize = titleLabel.sizeThatFits(CGSize(width: titleWidth, height: CGFLOAT_MAX))
        titleLabel.frame = CGRect(
            x: 0,
            y: closeImageView.frame.maxY + 8.0,
            width: titleSize.width,
            height: titleSize.height
        )
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = (titleWidth / 2.0)
        
        gradient.frame = titleLabel.bounds
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(titleLabel)
        titleLabel.layer.insertSublayer(gradient, at: 0)
        
        box.addSubview(closeImageView)
        box.addSubview(closeButton)
    }
    
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.white.cgColor,
            UIColor.black.cgColor
        ]
        gradient.startPoint = CGPointMake(0.0, 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradient
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.text = "启\n动\n任\n务"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var closeImageView: UIImageView = {
        let closeImageView = UIImageView()
        closeImageView.dtb.setImage(named: "ic_close", bundleName: "DTBKit-UIKit", frameworkName: "DTBKit")
        closeImageView.contentMode = .scaleAspectFit
        return closeImageView
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .custom)
        closeButton.backgroundColor = .clear
        closeButton.addTarget(self, action: #selector(closeButtonEvent(button:)), for: .touchUpInside)
        return closeButton
    }()
}
