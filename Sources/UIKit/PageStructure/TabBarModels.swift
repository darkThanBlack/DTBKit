//
//  TabBarDatass.swift
//  Ring
//
//  Created by moonShadow on 2026/5/18
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    public protocol TabBarDatas {
        
        var backgroundColor: UIColor { get }
        
        var unSelectTintColor: UIColor { get }
        
        var selectedTintColor: UIColor { get }
    }
    
    public protocol TabBarItemDatas {
        
        var rootViewController: UIViewController { get }
        
        var title: String? { get }
        
        var image: UIImage?  { get }
        
        var selectedImage: UIImage?  { get }
        
        var font: UIFont?  { get }
    }
    
    public class TabBarModel: TabBarDatas {
        
        public var backgroundColor: UIColor
        
        public var unSelectTintColor: UIColor
        
        public var selectedTintColor: UIColor
        
        public init(backgroundColor: UIColor, unSelectTintColor: UIColor, selectedTintColor: UIColor) {
            self.backgroundColor = backgroundColor
            self.unSelectTintColor = unSelectTintColor
            self.selectedTintColor = selectedTintColor
        }
    }
    
    public class TabBarItemModel: TabBarItemDatas {
        
        public var rootViewController: UIViewController
        
        public var title: String?
        
        public var image: UIImage?
        
        public var selectedImage: UIImage?
        
        public var font: UIFont?
        
        public init(rootViewController: UIViewController, title: String? = nil, image: UIImage? = nil, selectedImage: UIImage? = nil, font: UIFont? = nil) {
            self.rootViewController = rootViewController
            self.title = title
            self.image = image
            self.selectedImage = selectedImage
            self.font = font
        }
    }
}
