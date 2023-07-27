//
//  GuideDriftView.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/21
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// 新手引导 - 浮窗
public class GuideDriftView: UIView {
    
    ///
    private var isFading = false
    ///
    private var fadeParam: [String: Any]? = nil
    
    ///
    public func fireFade(_ isFade: Bool, params: [String: Any]? = nil) {
        guard self.isFading != isFade else {
            return
        }
        self.isFading = isFade
        self.fadeParam = params
        
        let oldFrame = self.frame
        // Step 1.  根据左右吸边，做一个整体偏移
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) {
            var direct = "left"
            if let aniType = self.fadeParam?["type"] as? String, aniType == "absorb",
               let value = self.fadeParam?["direct"] as? String {
                direct = value
            }
            switch direct {
            case "left":
                self.frame.origin.x = oldFrame.origin.x - 8.0
            case "right":
                self.frame.origin.x = oldFrame.origin.x + 8.0
            default:
                break
            }
            // Step 2.  改变自身展示形态
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
                self.alpha = self.isFading ? 0.8 : 1.0
                self.setNeedsLayout()
                self.layoutIfNeeded()
            } completion: { _ in
                // Step 3.  复原整体偏移，营造弹动效果
                UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
                    self.frame = oldFrame
                } completion: { _ in
                    // do nth.
                }
            }
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
    
    //MARK: - Event
    
    @objc private func closeButtonEvent(button: UIButton) {
        let alert = UIAlertController(title: "提示", message: "浮窗将被关闭，您可以在【首页 - 启动任务】重新开启", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .default))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            Drift.shared.stop()
        }))
        Drift.shared.topMost()?.present(alert, animated: true)
    }
    
    @objc private func titleLabelEvent(gesture: UITapGestureRecognizer) {
        let listVC = GuideListViewController()
        let nav = GuideNavigationController(rootViewController: listVC)
        Drift.shared.topMost()?.present(nav, animated: true)
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
            DriftAdapter.color_FFAB1A().cgColor,
            DriftAdapter.color_FF8534().cgColor
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
