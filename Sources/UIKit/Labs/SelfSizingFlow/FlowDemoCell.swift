//
//  FlowDemoCell.swift
//  DTBKit
//
//  Created by moonShadow on 2026/8/20
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {
    
    /// Flow 展示 cell：内嵌 SelfSizingFlowView，验证「自身尺寸撑开 cell 高度」。
    final class FlowDemoCell: DTB.BaseTableViewCell {
        
        func config(titles: [(String, CGFloat)], flowConfig: DTB.SelfSizingFlowConfig) {
            flow.update(config: flowConfig)
            flow.update(items: titles.map { item -> DTB.FlowCell1 in
                let cell = DTB.FlowCell1(frame: .zero)
                cell.config(title: item.0, fontSize: item.1)
                return cell
            })
        }
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            loadViews(in: contentView)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadViews(in box: UIView) {
            box.addSubview(flow)
            
            /// 宽由 leading/trailing 钉死，高靠 intrinsic（cachedHeight）撑，bottom 锚定 cell 高度
            flow.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.leading.trailing.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().offset(-12)
            }
        }
        
        private lazy var flow = DTB.SelfSizingFlowView()
    }
}
