//
//  EdgeLabel.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/30
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

/// Simply custom label edge
public class EdgeLabel: UILabel {
    
    ///
    public var edgeInsets: UIEdgeInsets? {
        didSet {
            sizeToFit()
        }
    }
    
    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = edgeInsets ?? .zero
        var rect = super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets ?? .zero))
    }
}
