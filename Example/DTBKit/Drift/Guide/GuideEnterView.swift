//
//  GuideEnterView.swift
//  XMBundleLN
//
//  Created by moonShadow on 2023/8/21
//  Copyright © 2023 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// 新手引导 - 首页入口
public protocol GuideEnterViewDelegate: AnyObject {
    ///
    func guideEnterEvent()
    ///
    func guideCloseEvent()
}

/// 新手引导 - 首页入口
public class GuideEnterView: UIView {
    
    public weak var delegate: GuideEnterViewDelegate?
    
    public var closeable: Bool = false {
        didSet {
            let name = closeable ? "guide_enter_close" : "guide_enter_arrow"
            self.rightButton.setImage(DriftAdapter.imageNamed(name), for: .normal)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    @objc private func guideEnterViewEvent(gesture: UITapGestureRecognizer) {
        delegate?.guideEnterEvent()
    }
    
    ///
    @objc private func rightButtonEvent(button: UIButton) {
        if closeable == true {
            delegate?.guideCloseEvent()
        } else {
            delegate?.guideEnterEvent()
        }
    }
    
    //MARK: View
    
    public override var intrinsicContentSize: CGSize {
        return sizeThatFits(UIScreen.main.bounds.size)
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let totalWidth = size.width - (16.0 + 16.0)
        let bgHeight = totalWidth * (80.0 / 686.0)
        let totalHeight = bgHeight + 10.0 + (8.0 + 8.0)
        
        return CGSize(width: size.width, height: totalHeight)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let totalWidth = bounds.size.width - (16.0 + 16.0)
        let totalHeight = bounds.size.height - (8.0 + 8.0)
        let bgHeight = totalWidth * (80.0 / 686.0)
        
        bgImageView.frame = CGRect(
            x: 16.0,
            y: 8.0 + (totalHeight - bgHeight),
            width: totalWidth,
            height: bgHeight
        )
        robotImageView.frame = CGRect(
            x: 16.0,
            y: 8.0,
            width: totalHeight * (120.0 / 90.0),
            height: totalHeight
        )
        rightButton.bounds = CGRect(x: 0, y: 0, width: 24.0, height: 24.0)
        rightButton.center = CGPoint(
            x: bgImageView.frame.maxX - 24.0 - 8.0,
            y: bgImageView.center.y
        )
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(bgImageView)
        box.addSubview(robotImageView)
        box.addSubview(rightButton)
    }
    
    ///
    private lazy var bgImageView: UIImageView = {
        
        let imageView = UIImageView(image: DriftAdapter.imageNamed("guide_enter_bg"))
        imageView.contentMode = .scaleAspectFit
        
        imageView.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(guideEnterViewEvent(gesture:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(singleTap)
        
        return imageView
    }()
    
    private lazy var robotImageView: UIImageView = {
        let imageView = UIImageView(image: DriftAdapter.imageNamed("guide_enter_robot"))
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    ///
    private lazy var rightButton: UIButton = {
        let rightButton = UIButton(type: .custom)
        rightButton.backgroundColor = .clear
        rightButton.addTarget(self, action: #selector(rightButtonEvent(button:)), for: .touchUpInside)
        return rightButton
    }()
}

