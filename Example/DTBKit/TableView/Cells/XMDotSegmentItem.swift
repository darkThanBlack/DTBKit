//
//  XMDotSegmentItem.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/31
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// 橘色圆圈 + 标题
public class XMDotSegmentItem: UIView {
    
    ///
    public enum States {
        /// 选中
        case selected
        /// 未选中
        case unSelect
        /// 禁用
        case disable
        
        var iconName: String {
            switch self {
            case .selected:  return "ic_the_selected"
            case .unSelect:  return "ic_unselected"
            case .disable:   return "ic_unselected_disabled"
            }
        }
    }
    
    /// 唯一标识, 用于代替 `tag`
    public var primaryKey: String?
    
    /// 状态
    public var state: States = .unSelect {
        didSet {
            dotImageView.image = UIImage(named: state.iconName)
        }
    }
    
    /// 标题
    public var title: String? = nil {
        didSet {
            titleLabel.text = title
        }
    }
    
    /// 单击事件
    /// 即使 ``disable`` 状态也会触发, 便于实现 ``toast`` 等业务
    public var eventHandler: ((XMDotSegmentItem)->())?
    
    public init(
        key: String? = nil,
        title: String? = nil,
        state: States? = .unSelect,
        eventHandler: ((XMDotSegmentItem)->())? = nil
    ) {
        super.init(frame: .zero)
        
        self.primaryKey = key
        self.title = title
        self.state = state ?? .unSelect
        self.eventHandler = eventHandler
        
        loadViews(in: self)
        
        self.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapEvent(gesture:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(singleTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func singleTapEvent(gesture: UITapGestureRecognizer) {
        eventHandler?(self)
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(dotImageView)
        box.addSubview(titleLabel)
        
        dotImageView.snp.makeConstraints { make in
            make.left.centerY.equalTo(box)
            make.width.height.equalTo(18.0)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalTo(box)
            make.left.equalTo(dotImageView.snp.right).offset(8.0)
            make.height.greaterThanOrEqualTo(18.0)
        }
    }
    
    private lazy var dotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        titleLabel.textColor = XMVisual.Color.Gray.A
        titleLabel.text = " "
        return titleLabel
    }()
}
