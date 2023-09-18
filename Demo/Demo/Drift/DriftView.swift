//
//  DriftView.swift
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
class DriftView: UIView {
    
    //MARK: Interface
    
    ///
    func fireAbsorb() {
        let father = superview?.bounds ?? UIScreen.main.bounds
        var barrier = father
        if #available(iOS 11.0, *) {
            barrier = father.inset(by: superview?.safeAreaInsets ?? .zero)
        }
        let newFrame = absorbHorizonal(frame, barrier: barrier)
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.frame = newFrame
        } completion: { _ in
            Drift.defaults(set: ["x": newFrame.origin.x, "y": newFrame.origin.y], forKey: .driftedFrame)
        }
    }
    
    ///
    func fireFade(_ isFade: Bool) {
        guard canFade else { return }
        
        contentView.fireFade(isFade, params: [
            "type": "absorb",
            "direct": (self.center.x > (superview?.bounds.midX ?? 0)) ? "right" : "left"
        ])
        
        if isFade == false {
            fadeTimerReStart()
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
    
    private lazy var contentView: GuideDriftView = {
        let contentView = GuideDriftView()
        return contentView
    }()
    
    //MARK: - fade
    
    /// 显隐效果
    private let canFade: Bool = true
    /// 自动隐藏效果
    private let canDelay: Bool = false
    ///
    private var fadeTimer: Timer?
    ///
    private var fadeCounts: Int = 0
    
    private let fadeDelayTime: Int = 6
    
    ///
    private func fadeTimerReStart() {
        fadeCounts = fadeDelayTime
        
        guard fadeTimer == nil, canDelay == true else { return }
        fadeTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
            self?.fadeTimerEvent(timer)
        })
    }
    
    /// https://juejin.cn/post/6844903925011709959
    private func fadeTimerEnd() {
        fadeCounts = 0
        fadeTimer?.invalidate()
        fadeTimer = nil
        
        fireFade(true)
    }
    
    private func fadeTimerEvent(_ timer: Timer?) {
        guard isMoving == false else { return }
        fadeCounts -= 1
        
        guard fadeCounts <= 0 else { return }
        fadeTimerEnd()
    }
    
    //MARK: - touches
    
    ///
    private var isMoving: Bool = false
    ///
    private var op: CGPoint = .zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else {
            return
        }
        op = p
        isMoving = true
        
        fireFade(false)
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
        isMoving = false
        
        fireAbsorb()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMoving = false
        
        fireAbsorb()
    }
    
    /// 越界
    private func frameInside(value: CGRect, barrier: CGRect) -> CGRect {
        var newFrame = value
        
        if newFrame.origin.x < barrier.minX {
            newFrame.origin.x = barrier.minX
        }
        
        if newFrame.origin.x > (barrier.maxX - newFrame.size.width) {
            newFrame.origin.x = barrier.maxX - newFrame.size.width
        }
        
        if newFrame.origin.y < barrier.minY {
            newFrame.origin.y = barrier.minY
        }
        
        if newFrame.origin.y > (barrier.maxY - newFrame.size.height) {
            newFrame.origin.y = barrier.maxY - newFrame.size.height
        }
        
        return newFrame
    }
    
    /// 横向吸附
    private func absorbHorizonal(_ value: CGRect, barrier: CGRect) -> CGRect {
        var newFrame = frameInside(value: value, barrier: barrier)
        
        if newFrame.midX > barrier.midX {
            newFrame.origin.x = barrier.maxX - newFrame.size.width
        } else {
            newFrame.origin.x = barrier.minX
        }
        
        return newFrame
    }
}
