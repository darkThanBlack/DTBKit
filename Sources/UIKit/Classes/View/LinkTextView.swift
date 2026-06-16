//
//  LinkTextView.swift
//  XMKit
//
//  Created by moonShadow on 2024/2/6
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension Wrapper where Base: DTB.LinkTextView {
    
    /// 如果 value 为空则尝试用 key 本地创建
    @discardableResult
    public func addLink(_ key: String, value: String? = nil) -> Self {
        me.multiLinks[key] = value ?? .dtb.create(key)
        return self
    }
    
    @discardableResult
    public func textAttr(_ value: [NSAttributedString.Key: Any]) -> Self {
        me.textAttr = value
        return self
    }
    
    @discardableResult
    public func linkAttr(_ value: [NSAttributedString.Key: Any]) -> Self {
        me.linkAttr = value
        return self
    }
    
    @discardableResult
    public func linkConfigsFinished() -> Self {
        me.linkConfigsFinished()
        return self
    }
    
    @discardableResult
    public func tapDelegate(_ value: DTB.LinkTextViewDelegate?) -> Self {
        me.tapDelegate = value
        return self
    }
}

// MARK: -


extension DTB {
    
    /// 用于支持可点击的富文本
    public protocol LinkTextViewDelegate: AnyObject {
        
        /// 链接点击事件
        func linkTextView(_ view: DTB.LinkTextView, shouldInteract linkKey: String)
    }
    
    /// 用于支持可点击的富文本
    public class LinkTextView: UITextView {
        
        /// key: 唯一标识
        /// value: 对应文字
        public var multiLinks: [String: String] = [:]
        
        /// (默认)普通文本样式
        public var textAttr: [NSAttributedString.Key: Any] = .dtb.create
            .font(.systemFont(ofSize: 13.0))
            .foregroundColor(.dtb.create("text"))
            .paragraphStyle(
                NSMutableParagraphStyle().dtb
                    .lineBreakMode(.byCharWrapping)
                    .alignment(.left)
                    .lineSpacing(5.0)
                    .value
            )
            .value
        
        /// (默认)链接文本样式
        public var linkAttr: [NSAttributedString.Key: Any] = .dtb.create
            .foregroundColor(.dtb.create("theme"))
            .value
        
        /// 使当前配置生效
        public func linkConfigsFinished() {
            self.linkTextAttributes = linkAttr
            
            guard text.isEmpty == false, multiLinks.isEmpty == false else {
                return
            }
            let nsText = NSString(string: text)
            let attr = NSMutableAttributedString(string: text, attributes: textAttr)
            multiLinks.forEach { (key, value) in
                guard value.count > 0 else {
                    return
                }
                let range = nsText.range(of: value)
                guard range.location != NSNotFound else {
                    return
                }
                attr.addAttribute(.link, value: key, range: range)
            }
            attributedText = attr
        }
        
        /// 必须实现
        public weak var tapDelegate: LinkTextViewDelegate?
        
        // 禁用选中范围
        public override var selectedTextRange: UITextRange? {
            get { return nil }
            set { /* 禁止设置 */ }
        }
        
        public override init(frame: CGRect, textContainer: NSTextContainer?) {
            super.init(frame: frame, textContainer: textContainer)
            
            // 去除除单击之外的手势(长按/双击选择，重按放大，菜单等)
            gestureRecognizers?.filter({ gesture in
                let typeStr = "\(type(of: gesture))"
                guard (gesture is UITapGestureRecognizer) == false else {
                    return false
                }
                guard typeStr != "UITextTapRecognizer" else {
                    return false
                }
                guard typeStr != "UITapAndAHalfRecognizer" else {
                    return false
                }
                return true
            }).forEach({ gesture in
                removeGestureRecognizer(gesture)
            })
            
            isEditable = false
            isScrollEnabled = false
            showsVerticalScrollIndicator = false
            showsHorizontalScrollIndicator = false
            backgroundColor = nil
            dataDetectorTypes = .link
            delegate = defHolder
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private lazy var defHolder = LinkTextViewHolder()
        
        public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            if let tap = gestureRecognizer as? UITapGestureRecognizer {
                return tap.numberOfTapsRequired == 1
            }
            return false
        }
        
        public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            return false
        }
    }

}

///
private class LinkTextViewHolder: NSObject, UITextViewDelegate {
    
    ///
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        guard let view = textView as? DTB.LinkTextView else {
            return false
        }
        if view.multiLinks.contains(where: { $0.key == URL.absoluteString }) {
            view.tapDelegate?.linkTextView(view, shouldInteract: URL.absoluteString)
        }
        return false
    }
}
