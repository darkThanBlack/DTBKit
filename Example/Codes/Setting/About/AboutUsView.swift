//
//  AboutUsView.swift
//  XMSport
//
//  Created by moonShadow on 2024/4/23
//  Copyright © 2024 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


protocol AboutUsViewDelegate: AnyObject {
    
    func listItemEvent(_ index: Int)
}

///
class AboutUsView: UIView {
    
    weak var delegate: AboutUsViewDelegate?
    
    private var items: [ArrowRow.Item] = []
    
    /// 更新条目
    ///
    /// 列表很短（个位数），每次直接重建，不做 diff。
    func update(items: [ArrowRow.Item]) {
        self.items = items
        
        contentStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        for (index, item) in items.enumerated() {
            contentStack.addArrangedSubview(
                ArrowRow.card(
                    title: item.title,
                    index: index,
                    count: items.count,
                    target: self,
                    action: #selector(listItemEvent(_:))
                )
            )
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
        
        // logo.kf.setImage(with: URL(string: "https://image.xiaomaiketang.com/xm/internal/4eKBnm5M5C.png"))
        
        self.backgroundColor = .dtb.create("dtb.bg")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(logo)
        box.addSubview(nameLabel)
        box.addSubview(versionLabel)
        box.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        box.addSubview(buildLabel)
        
        logo.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.top.equalTo(box.snp.top).offset(24.0)
            make.width.height.equalTo(80.0.dtb.hf())
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.top.equalTo(logo.snp.bottom).offset(16.0)
        }
        versionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.top.equalTo(nameLabel.snp.bottom).offset(4.0)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(versionLabel.snp.bottom).offset(24.0)
            make.left.equalTo(box.snp.left).offset(0)
            make.right.equalTo(box.snp.right).offset(-0)
            make.bottom.equalTo(box.safeAreaLayoutGuide.snp.bottom).offset(-8.0)
        }
        /// 左右留白由 card style 的 margin 自带，stack 不再 inset
        contentStack.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
        buildLabel.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.bottom.equalTo(box.snp.bottom).offset(-16.0)
        }
    }
    
    //MARK: 事件
    
    @objc private func listItemEvent(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag, items.dtb[index] != nil else {
            return
        }
        delegate?.listItemEvent(index)
    }
    
    //MARK: 懒加载
    
    private lazy var logo: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.layer.masksToBounds = true
        logo.layer.cornerRadius = 10.0
        return logo
    }()
    
    private lazy var nameLabel = UILabel().dtb.textStyle("dtb.h2").text(DTB.app.displayName).value
    
    private lazy var versionLabel = UILabel().dtb.textStyle("dtb.b6").text(DTB.app.version).value
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private lazy var contentStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.alignment = .fill
        s.distribution = .fill
        s.spacing = 0.0
        return s
    }()
    
    private lazy var buildLabel = UILabel().dtb.textStyle("dtb.b6").text(DTB.app.build).value
}
