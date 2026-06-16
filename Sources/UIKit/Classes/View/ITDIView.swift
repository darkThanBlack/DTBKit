//
//  ITDIView.swift
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
    
    public protocol ITDIArrowData: TDIArrowData {
        
        var leftImage: DTB.ImageData? { get }
    }
}

extension DTB.ITDIView {
    
    public static func arrow() -> DTB.ITDIView {
        let view = DTB.ITDIView()
        view.rightImageView.dtb
            .tintColor(.dtb.create("arrow"))
            .image(.dtb.local("chevron.right"))
        return view
    }
    
    public func updateArrowData(_ data: DTB.ITDIArrowData?) {
        leftImageView.dtb
            .setImageData(data?.leftImage)
            .hiddenWithEmptyImage()
        
        titleLabel.dtb
            .text(data?.title)
            .hiddenWithEmptyText()
        
        detailLabel.dtb
            .text(data?.detail)
            .hiddenWithEmptyText()
        
        rightImageView.dtb
            .isHidden((data?.showArrow == true) ? false : true)
    }
}


extension DTB {
    
    
    /// image + title + detail + image, 整体左右分布排列
    ///
    /// - 左侧: img + title, 左右排列
    /// - 右侧: detail + img, 左右排列
    @objc(DTBITDIView)
    public final class ITDIView: UIView {
        
        public lazy var leftImageView = UIImageView().dtb.contentMode(.scaleAspectFit).value
        
        public lazy var titleLabel = UILabel().dtb.textStyle("h3").value
        
        public lazy var detailLabel = UILabel().dtb.textStyle("c2").value
        
        public lazy var rightImageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            loadViews(in: self)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadViews(in box: UIView) {
            box.addSubview(stacks)
            stacks.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
            }
        }
        
        private lazy var stacks: UIStackView = {
            let stacks = UIStackView(arrangedSubviews: [
                leftImageView,
                titleLabel,
                DTB.layout.spacer(),
                detailLabel,
                rightImageView
            ])
            stacks.axis = .horizontal
            stacks.alignment = .center
            stacks.distribution = .fill
            stacks.spacing = 4.0
            return stacks
        }()
        
    }
    
}
