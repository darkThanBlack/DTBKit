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
public class GuideDriftView: UIView {
    
    //MARK: Interface
    
    ///
    public func fireAbsorb() {
        let newFrame = absorbHorizonal(frame, barrier: superview?.bounds ?? UIScreen.main.bounds)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut) {
            self.frame = newFrame
        } completion: { _ in
            // do nth.
        }
    }
    
    ///
    public func fireFade(_ isFade: Bool) {
        UIView.animate(withDuration: isFade ? 0.5 : 0.0, delay: 0.0, options: .curveEaseInOut) {
            self.contentView.alpha = isFade ? 0.4 : 1.0
        } completion: { _ in
            // do nth.
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
    
    public override var intrinsicContentSize: CGSize {
        return contentView.intrinsicContentSize
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return contentView.sizeThatFits(size)
    }
    
    public override func layoutSubviews() {
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
    
    //MARK: - fade
    
    ///
    private let canFade: Bool = true
    ///
    private var fadeTimer: Timer?
    ///
    private var fadeCounts: Int = 0
    
    private let fadeDelayTime: Int = 5
    
    ///
    private func fadeTimerReStart() {
        guard canFade, fadeTimer == nil else {
            return
        }
        fireFade(false)
        
        fadeCounts = fadeDelayTime
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
        fadeCounts -= 1
        guard fadeCounts <= 0 else {
            return
        }
        fadeTimerEnd()
    }
    
    //MARK: - touches
    
    ///
    private var op: CGPoint = .zero
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else {
            return
        }
        op = p
        
        fadeTimerReStart()
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else {
            return
        }
        var tmp = frame
        tmp.origin.x += (p.x - op.x)
        tmp.origin.y += (p.y - op.y)
        frame = tmp
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireAbsorb()
        fadeTimerReStart()
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
