//
//  UIButton+Chain.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/4
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// Custom
extension Wrapper where Base: UIButton {
    
    @inline(__always)
    @discardableResult
    public func setImage(
        _ normal: UIImage?,
        highlighted: UIImage? = nil,
        disabled: UIImage? = nil,
        selected: UIImage? = nil
    ) -> Self {
        me.setImage(normal, for: .normal)
        me.setImage(highlighted, for: .highlighted)
        me.setImage(disabled, for: .disabled)
        me.setImage(selected, for: .selected)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func setTitle(
        _ normal: String?,
        highlighted: String? = nil,
        disabled: String? = nil,
        selected: String? = nil
    ) -> Self {
        me.setTitle(normal, for: .normal)
        me.setTitle(highlighted, for: .highlighted)
        me.setTitle(disabled, for: .disabled)
        me.setTitle(selected, for: .selected)
        return self
    }
}

/// System
extension Wrapper where Base: UIButton {
    
    @available(iOS 15.0, *)
    @inline(__always)
    @discardableResult
    public func configuration(_ value: UIButton.Configuration?) -> Self {
        me.configuration = value
        return self
    }
    
    @available(iOS 15.0, *)
    @inline(__always)
    @discardableResult
    public func setNeedsUpdateConfiguration() -> Self {
        me.setNeedsUpdateConfiguration()
        return self
    }
    
    @available(iOS 15.0, *)
    @inline(__always)
    @discardableResult
    public func updateConfiguration() -> Self {
        me.updateConfiguration()
        return self
    }

    @available(iOS 15.0, *)
    @inline(__always)
    @discardableResult
    public func configurationUpdateHandler(_ value: UIButton.ConfigurationUpdateHandler?) -> Self {
        me.configurationUpdateHandler = value
        return self
    }
    
    @available(iOS 15.0, *)
    @inline(__always)
    @discardableResult
    public func automaticallyUpdatesConfiguration(_ value: Bool) -> Self {
        me.automaticallyUpdatesConfiguration = value
        return self
    }
    
    @available(iOS 5.0, *)
    @inline(__always)
    @discardableResult
    public func tintColor(_ value: UIColor) -> Self {
        me.tintColor = value
        return self
    }
    
    @available(iOS 14.0, *)
    @inline(__always)
    @discardableResult
    public func role(_ value: UIButton.Role) -> Self {
        me.role = value
        return self
    }
    
    @available(iOS 13.4, *)
    @inline(__always)
    @discardableResult
    public func isPointerInteractionEnabled(_ value: Bool) -> Self {
        me.isPointerInteractionEnabled = value
        return self
    }
    
    @available(iOS 14.0, *)
    @inline(__always)
    @discardableResult
    public func menu(_ value: UIMenu?) -> Self {
        me.menu = value
        return self
    }
    
    @available(iOS 16.0, *)
    @inline(__always)
    @discardableResult
    public func preferredMenuElementOrder(_ value: UIContextMenuConfiguration.ElementOrder) -> Self {
        me.preferredMenuElementOrder = value
        return self
    }
    
    @available(iOS 15.0, *)
    @inline(__always)
    @discardableResult
    public func changesSelectionAsPrimaryAction(_ value: Bool) -> Self {
        me.changesSelectionAsPrimaryAction = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func setTitle(_ title: String?, for state: UIControl.State) -> Self {
        me.setTitle(title, for: state)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func setTitleColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        me.setTitleColor(color, for: state)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func setTitleShadowColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        me.setTitleShadowColor(color, for: state)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func setImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        me.setImage(image, for: state)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func setBackgroundImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        me.setBackgroundImage(image, for: state)
        return self
    }
    
    @available(iOS 13.0, *)
    @inline(__always)
    @discardableResult
    public func setPreferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration?, forImageIn state: UIControl.State) -> Self {
        me.setPreferredSymbolConfiguration(configuration, forImageIn: state)
        return self
    }
    
    @available(iOS 6.0, *)
    @inline(__always)
    @discardableResult
    public func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) -> Self {
        me.setAttributedTitle(title, for: state)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func titleLabel(_ handler: ((Wrapper<UILabel>) -> Void)?) -> Self {
        if let value = me.titleLabel {
            handler?(value.dtb)
        }
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func imageView(_ handler: ((Wrapper<UIImageView>) -> Void)?) -> Self {
        if let value = me.imageView {
            handler?(value.dtb)
        }
        return self
    }
    
    @available(iOS 15.0, *)
    @inline(__always)
    @discardableResult
    public func subtitleLabel(_ handler: ((Wrapper<UILabel>) -> Void)?) -> Self {
        if let value = me.subtitleLabel {
            handler?(value.dtb)
        }
        return self
    }
    
    @available(iOS, introduced: 2.0, deprecated: 15.0, message: "This property is ignored when using UIButtonConfiguration")
    @inline(__always)
    @discardableResult
    public func contentEdgeInsets(_ value: UIEdgeInsets) -> Self {
        me.contentEdgeInsets = value
        return self
    }
    
    @available(iOS, introduced: 2.0, deprecated: 15.0, message: "This property is ignored when using UIButtonConfiguration")
    @inline(__always)
    @discardableResult
    public func titleEdgeInsets(_ value: UIEdgeInsets) -> Self {
        me.titleEdgeInsets = value
        return self
    }
    
    @available(iOS, introduced: 2.0, deprecated: 15.0, message: "This property is ignored when using UIButtonConfiguration")
    @inline(__always)
    @discardableResult
    public func imageEdgeInsets(_ value: UIEdgeInsets) -> Self {
        me.imageEdgeInsets = value
        return self
    }
    
    @available(iOS, introduced: 2.0, deprecated: 15.0, message: "This property is ignored when using UIButtonConfiguration, you may customize to replicate this behavior via a configurationUpdateHandler")
    @inline(__always)
    @discardableResult
    public func reversesTitleShadowWhenHighlighted(_ value: Bool) -> Self {
        me.reversesTitleShadowWhenHighlighted = value
        return self
    }
    
    @available(iOS, introduced: 2.0, deprecated: 15.0, message: "This property is ignored when using UIButtonConfiguration, you may customize to replicate this behavior via a configurationUpdateHandler")
    @inline(__always)
    @discardableResult
    public func adjustsImageWhenHighlighted(_ value: Bool) -> Self {
        me.adjustsImageWhenHighlighted = value
        return self
    }
    
    @available(iOS, introduced: 2.0, deprecated: 15.0, message: "This property is ignored when using UIButtonConfiguration, you may customize to replicate this behavior via a configurationUpdateHandler")
    @inline(__always)
    @discardableResult
    public func adjustsImageWhenDisabled(_ value: Bool) -> Self {
        me.adjustsImageWhenDisabled = value
        return self
    }
    
    @available(iOS, introduced: 2.0, deprecated: 15.0, message: "This property is ignored when using UIButtonConfiguration")
    @inline(__always)
    @discardableResult
    public func showsTouchWhenHighlighted(_ value: Bool) -> Self {
        me.showsTouchWhenHighlighted = value
        return self
    }
}
