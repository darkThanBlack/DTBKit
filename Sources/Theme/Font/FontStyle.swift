//
//  FontStyle.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/10
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    public struct FontStyle {
        
        public var size: CGFloat?
        
        public var weight: UIFont.Weight?
        
        public var name: String?
        
        public init(size: CGFloat? = nil, weight: UIFont.Weight? = nil, name: String? = nil) {
            self.size = size
            self.weight = weight
            self.name = name
        }
        
        public init?(dict: [String: Any]?) {
            guard let size = dict?["size"] as? CGFloat else {
                return nil
            }
            let weight: UIFont.Weight = {
                if let w = dict?["weight"] as? UIFont.Weight {
                    return w
                }
                if let w = UIFont.Weight.dtb.create(dict?["weight"]) {
                    return w
                }
                return .regular
            }()
            
            self.size = size
            self.weight = weight
            self.name = dict?["name"] as? String
        }
        
        public func getFont() -> UIFont? {
            guard let size = self.size, let weight = self.weight else {
                return nil
            }
            guard let name = self.name, name.isEmpty == false else {
                return UIFont.systemFont(ofSize: size, weight: weight)
            }
            if let font = UIFont(name: "\(name)-\(weight.dtb.variant())", size: size) {
                return font
            }
            if let font = UIFont(name: name, size: size) {
                return font
            }
            console.error("font: missing font name, tired for \(name)-\(weight.dtb.variant()) and \(name)")
            return nil
        }
    }
}
