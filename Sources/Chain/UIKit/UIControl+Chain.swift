//
//  UIControl+Chain.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/4
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension Wrapper where Base: UIControl {
    
    @discardableResult
    public func isEnabled(_ value: Bool) -> Self {
        me.isEnabled = value
        return self
    }
    
    @discardableResult
    public func isSelected(_ value: Bool) -> Self {
        me.isSelected = value
        return self
    }
    
    @discardableResult
    public func isHighlighted(_ value: Bool) -> Self {
        me.isHighlighted = value
        return self
    }
    
    @discardableResult
    public func contentVerticalAlignment(_ value: UIControl.ContentVerticalAlignment) -> Self {
        me.contentVerticalAlignment = value
        return self
    }
    
    @discardableResult
    public func contentHorizontalAlignment(_ value: UIControl.ContentHorizontalAlignment) -> Self {
        me.contentHorizontalAlignment = value
        return self
    }
    
    @discardableResult
    public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) -> Self {
        me.addTarget(target, action: action, for: controlEvents)
        return self
    }
    
    @discardableResult
    public func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControl.Event) -> Self {
        me.removeTarget(target, action: action, for: controlEvents)
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func addAction(_ action: UIAction, for controlEvents: UIControl.Event) -> Self {
        me.addAction(action, for: controlEvents)
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func removeAction(_ action: UIAction, for controlEvents: UIControl.Event) -> Self {
        me.removeAction(action, for: controlEvents)
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func removeAction(identifiedBy actionIdentifier: UIAction.Identifier, for controlEvents: UIControl.Event) -> Self {
        me.removeAction(identifiedBy: actionIdentifier, for: controlEvents)
        return self
    }
    
    @available(iOS 17.4, *)
    @discardableResult
    public func performPrimaryAction() -> Self {
        me.performPrimaryAction()
        return self
    }
    
    @discardableResult
    public func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) -> Self {
        me.sendAction(action, to: target, for: event)
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func sendAction(_ action: UIAction) -> Self {
        me.sendAction(action)
        return self
    }
    
    @discardableResult
    public func sendActions(for controlEvents: UIControl.Event) -> Self {
        me.sendActions(for: controlEvents)
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func isContextMenuInteractionEnabled(_ value: Bool) -> Self {
        me.isContextMenuInteractionEnabled = value
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func showsMenuAsPrimaryAction(_ value: Bool) -> Self {
        me.showsMenuAsPrimaryAction = value
        return self
    }
    
    @available(iOS 15.0, *)
    @discardableResult
    public func toolTip(_ value: String?) -> Self {
        me.toolTip = value
        return self
    }
    
    @available(iOS 17.0, *)
    @discardableResult
    public func isSymbolAnimationEnabled(_ value: Bool) -> Self {
        me.isSymbolAnimationEnabled = value
        return self
    }
}
