//
//  GuideDriftContentView.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/21
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
public class GuideDriftContentView: UIView {
    
    ///
    private var isFading = false
    ///
    private var fadeParam: [String: Any]? = nil
    
    ///
    public func fireFade(_ isFade: Bool, params: [String: Any]? = nil) {
        self.isFading = isFade
        self.fadeParam = params
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut) {
            self.alpha = self.isFading ? 0.8 : 1.0
            self.setNeedsLayout()
            self.layoutIfNeeded()
        } completion: { _ in
            // do nth.
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeButtonEvent(button: UIButton) {
        let alert = UIAlertController(title: "提示", message: "浮窗将被关闭，您可以在【首页 - 启动任务】重新开启", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .default))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            Drift.shared.stop()
        }))
        Drift.shared.topMost()?.present(alert, animated: true)
    }
    
    @objc private func titleLabelEvent(gesture: UITapGestureRecognizer) {
        // todo: open drift menu...
    }
    
    //MARK: View
    
    private let titleSize = CGSize(width: 32.0, height: 104.0)
    
    private let closeSize = CGSize(width: 12.0, height: 12.0)
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(
            width: titleSize.width + 8.0,
            height: 8.0 + closeSize.height + 8.0 + titleSize.height
        )
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(
            width: titleSize.width + 8.0,
            height: 8.0 + closeSize.height + 8.0 + titleSize.height
        )
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.isFading {
            [closeImageView, closeButton, titleLabel].forEach({ $0.isHidden = true })
            
            var direct = "left"
            if let aniType = fadeParam?["type"] as? String, aniType == "absorb",
               let value = fadeParam?["direct"] as? String {
                direct = value
            }
            
            switch direct {
            case "left":
                gradient.frame = CGRect(
                    x: 0,
                    y: titleLabel.frame.origin.y,
                    width: 8.0,
                    height: titleLabel.frame.size.height
                )
                let path = UIBezierPath(
                    roundedRect: gradient.bounds,
                    byRoundingCorners: [.topRight, .bottomRight],
                    cornerRadii: CGSize(
                        width: 4.0,
                        height: 4.0
                    )
                )
                shape.path = path.cgPath
            case "right":
                gradient.frame = CGRect(
                    x: bounds.width - 8.0,
                    y: titleLabel.frame.origin.y,
                    width: 8.0,
                    height: titleLabel.frame.size.height
                )
                let path = UIBezierPath(
                    roundedRect: gradient.bounds,
                    byRoundingCorners: [.topLeft, .bottomLeft],
                    cornerRadii: CGSize(
                        width: 4.0,
                        height: 4.0
                    )
                )
                shape.path = path.cgPath
            default:
                break
            }
        } else {
            [closeImageView, closeButton, titleLabel].forEach({ $0.isHidden = false })
            
            closeImageView.bounds = CGRect(origin: .zero, size: closeSize)
            closeImageView.center = CGPoint(
                x: bounds.midX,
                y: 8.0 + (closeSize.height / 2.0)
            )
            
            closeButton.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
            closeButton.center = closeImageView.center
            
            titleLabel.bounds = CGRect(origin: .zero, size: titleSize)
            titleLabel.center = CGPoint(
                x: bounds.midX,
                y: closeImageView.frame.maxY + 8.0 + (titleSize.height / 2.0)
            )
            
            gradient.frame = titleLabel.frame
            let path = UIBezierPath(roundedRect: titleLabel.bounds, cornerRadius: titleSize.width / 2.0)
            shape.path = path.cgPath
        }
    }
    
    private func loadViews(in box: UIView) {
        box.layer.addSublayer(gradient)
        gradient.mask = shape
        
        box.addSubview(titleLabel)
        box.addSubview(closeImageView)
        box.addSubview(closeButton)
    }
    
    private lazy var shape: CAShapeLayer = {
        let shape = CAShapeLayer()
        return shape
    }()
    
    /// https://juejin.cn/post/6847902222466940936
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            Color.XM.Orange.B.cgColor,
            Color.XM.Orange.A.cgColor
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
        
        titleLabel.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(titleLabelEvent(gesture:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        titleLabel.addGestureRecognizer(singleTap)
        
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
