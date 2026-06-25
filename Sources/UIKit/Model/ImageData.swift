//
//  ImageData.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/26
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    public struct ImageData {
        
        public var image: UIImage?
        
        public var localName: String?
        
        public var remoteUrl: String?
        
        public init(image: UIImage? = nil, localName: String? = nil, remoteUrl: String? = nil) {
            self.image = image
            self.localName = localName
            self.remoteUrl = remoteUrl
        }
    }
}
