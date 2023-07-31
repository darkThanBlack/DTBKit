//
//  GuideGroupView.swift
//  XMWorkArea
//
//  Created by 徐一丁 on 2022/5/6.
//

import UIKit

///
protocol GuideGroupViewDelegate: AnyObject {
    /// 选中
    func guideGroupViewDidSelect(at index: Int)
}

/// 任务列表 - 组头
class GuideGroupView: UIView {
    
    ///
    weak var delegate: GuideGroupViewDelegate?
    
    ///
    private var items: [GuideGroupItemDataSource] = []
    
    ///
    func setupItems(with datas: [GuideGroupItemDataSource]) {
        self.items = datas
        collectionView.reloadData()
    }
    
    //MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        let normalSize = layout.normalSize
//        let selectedSize = layout.selectedSize
        
        collectionView.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width,
            height: bounds.height + 1.0
        )
    }
    
    ///
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        // refer: https://www.jianshu.com/p/d17bcf7a973f
        layout.estimatedItemSize = CGSize(width: 30.0, height: 30.0)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        layout.minimumLineSpacing = 24.0
        layout.minimumInteritemSpacing = 24.0
        return layout
    }()
    ///
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(GuideGroupCell.self, forCellWithReuseIdentifier: String(describing: GuideGroupCell.self))
        return collectionView
    }()
}

extension GuideGroupView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.guideGroupViewDidSelect(at: indexPath.row)
    }
}

extension GuideGroupView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as? GuideGroupCell else {
            return .zero
        }
        return cell.sizeThatFits(bounds.size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GuideGroupCell.self), for: indexPath) as? GuideGroupCell else {
            return UICollectionViewCell()
        }
        if indexPath.row < items.count {
            cell.config(data: items[indexPath.row])
        }
        return cell
    }
}
