//
//  CustomTabBar.swift
//  Example
//
//  Created by moonShadow on 2025/10/23
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {
    
    ///
    @objc(DTBSimpleTabBarItem)
    public class SimpleTabBarItem: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        var isSelected: Bool = false {
            didSet {
                updateAppearance()
            }
        }
        
        private var title: String? = nil
        private var unselectColor: UIColor? = nil
        private var selectedColor: UIColor? = nil
        private var unSelectImage: UIImage? = nil
        private var selectedImage: UIImage? = nil
        
        func update(
            title: String? = nil,
            unselectColor: UIColor? = nil,
            selectedColor: UIColor? = nil,
            unSelectImage: UIImage? = nil,
            selectedImage: UIImage? = nil
        ) {
            self.title = title
            self.unselectColor = unselectColor
            self.selectedColor = selectedColor
            self.unSelectImage = unSelectImage
            self.selectedImage = selectedImage
            
            self.updateAppearance()
        }
        
        private func setupUI() {
            addSubview(stacks)
            stacks.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(10.0)
                make.bottom.equalToSuperview()
                make.width.height.lessThanOrEqualToSuperview()
            }
            [selectImageView, unSelectImageView].forEach({
                $0.snp.makeConstraints { make in
                    make.width.height.equalTo(22.0)
                }
            })
        }
        
        private func updateAppearance() {
            titleLabel.textColor = (isSelected ? self.selectedColor : self.unselectColor) ?? .clear
            selectImageView.image = selectedImage
            unSelectImageView.image = unSelectImage
            
            if let str = self.title, str.isEmpty == false {
                titleLabel.text = str
                titleLabel.isHidden = false
            } else {
                titleLabel.isHidden = true
            }
            unSelectImageView.isHidden = isSelected ? true : false
            selectImageView.isHidden = isSelected ? false : true
        }
        
        private lazy var stacks: UIStackView = {
            let stacks = UIStackView(arrangedSubviews: [selectImageView, unSelectImageView, titleLabel])
            stacks.axis = .vertical
            stacks.alignment = .center
            stacks.distribution = .equalSpacing
            stacks.spacing = 4.0
            return stacks
        }()
        
        private lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 11.0, weight: .regular)
            label.textAlignment = .center
            return label
        }()
        
        private lazy var unSelectImageView: UIImageView = {
            let view = UIImageView()
            view.contentMode = .scaleAspectFit
            return view
        }()
        
        private lazy var selectImageView: UIImageView = {
            let view = UIImageView()
            view.contentMode = .scaleAspectFit
            return view
        }()
    }
    
    ///
    @objc(DTBSimpleTabBar)
    open class SimpleTabBar: UIView, CustomTabBarProvider {
        
        public func setupWhenViewDidLoad(_ controller: DTB.CustomTabBarController) {
            controller.view.addSubview(self)
            self.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
            }
        }
        
        public func setCustomTabBarHidden(_ controller: DTB.CustomTabBarController, isHidden: Bool, animated: Bool) {
            self.isHidden = isHidden
        }
        
        public func setSelectItem(at index: Int) {
            self.selectedIndex = index
            
            updateAppearance()
        }
        
        public func userDidSelectItem(_ handler: ((_ index: Int) -> ())?) {
            self.selectedHandler = handler
            
            updateAppearance()
        }
        
        public func updateConfig(_ data: DTB.TabBarData) {
            self.barData = data
            
            updateAppearance()
        }
        
        public func updateItems(_ items: [DTB.TabBarItemData]) {
            self.barItems = items
            
            // create item view if needed
            if items.count != stackView.arrangedSubviews.count {
                stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
                for (index, _) in items.enumerated() {
                    let view = SimpleTabBarItem()
                    
                    view.tag = index
                    view.isUserInteractionEnabled = true
                    let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapEvent(gesture:)))
                    singleTap.numberOfTapsRequired = 1
                    singleTap.numberOfTouchesRequired = 1
                    view.addGestureRecognizer(singleTap)
                    
                    stackView.addArrangedSubview(view)
                }
            }
            
            updateAppearance()
        }
        
        private var selectedIndex: Int = 0
        private var selectedHandler: ((_ index: Int) -> ())?
        
        private var barData: TabBarData? = nil
        private var barItems: [DTB.TabBarItemData] = []
        
        private func updateAppearance() {
            self.backgroundColor = barData?.backgroundColor
            for (index, view) in stackView.arrangedSubviews.compactMap({ $0 as? SimpleTabBarItem }).enumerated() {
                guard index < barItems.count else { continue }
                let item = barItems[index]
                view.update(
                    title: item.title,
                    unselectColor: barData?.unSelectTintColor,
                    selectedColor: barData?.selectedTintColor,
                    unSelectImage: item.image,
                    selectedImage: item.selectedImage
                )
                view.isSelected = index == self.selectedIndex
            }
        }
        
        @objc private func singleTapEvent(gesture: UITapGestureRecognizer) {
            guard let tag = gesture.view?.tag, tag < stackView.arrangedSubviews.count else {
                DTB.console.assert()
                return
            }
            selectedHandler?(tag)
        }
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            
            loadViews(in: self)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadViews(in box: UIView) {
            box.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.top.left.right.equalTo(box)
                 make.height.greaterThanOrEqualTo(49.0)
                if #available(iOS 12.0, *) {
                    make.bottom.equalTo(box.safeAreaLayoutGuide.snp.bottom).offset(-0)
                } else {
                    make.bottom.equalTo(box.snp.bottom).offset(-0)
                }
            }
        }
        
        private lazy var stackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            stack.alignment = .fill
            return stack
        }()
    }
    
}
