//
//  TabBarItemModel.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/25
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    public struct TabBarItemModel: TabBarItemData {
        
        public var rootViewController: UIViewController
        
        public var title: String?
        
        public var image: UIImage?
        
        public var selectedImage: UIImage?
        
        public var font: UIFont?
        
        public var unSelectTintColor: UIColor?
        
        public var selectedTintColor: UIColor?
        
        public init(
            rootViewController: UIViewController,
            title: String? = nil,
            image: UIImage? = nil,
            selectedImage: UIImage? = nil,
            font: UIFont? = nil,
            unSelectTintColor: UIColor? = nil,
            selectedTintColor: UIColor? = nil
        ) {
            self.rootViewController = rootViewController
            self.title = title
            self.image = image
            self.selectedImage = selectedImage
            self.font = font
            self.unSelectTintColor = unSelectTintColor
            self.selectedTintColor = selectedTintColor
        }
    }
}
