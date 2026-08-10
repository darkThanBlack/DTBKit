//
//  DiskUsageViewController.swift
//  XMSport
//
//  Created by moonShadow on 2025/6/27
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// 存储空间
    public final class DiskUsageViewController: DTB.BaseViewController {
        
        private lazy var viewModel = {
            let model = DiskUsageViewModel()
            model.delegate = self
            return model
        }()
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            setupNavigatonBar(with: .init(theme: .clear, title: .dtb.create("deep.disk")))
            view.backgroundColor = DTB.DiskUsageDepends.backgroundColor()
            loadViews(in: view)
            
            reload()
        }
        
        private func reload() {
            viewModel.reloadData {
                self.contentView.reloadUsage(by: self.viewModel.usage)
                self.contentView.reloadCaches(by: self.viewModel.caches)
            }
        }
        
        //MARK: View
        
        private func loadViews(in box: UIView) {
            box.addSubview(contentView)
            contentView.snp.makeConstraints { make in
                make.top.equalTo(customNavigationBar.snp.bottom).offset(0)
                make.left.right.bottom.equalTo(box.safeAreaLayoutGuide)
            }
        }
        
        private lazy var contentView = {
            let view = DiskUsageView()
            view.delegate = self
            return view
        }()
    }
    
}

extension DTB.DiskUsageViewController: DTB.DiskUsageViewModelDelegate {
    
    func needUpdateLoadingUIState(_ isLoading: Bool) {
        self.contentView.reloadUsage(by: self.viewModel.usage)
    }
}

extension DTB.DiskUsageViewController: DTB.DiskCacheEventsDelegate {
    
    func diskCacheRefreshButtonEvent() {
        reload()
    }
    
    func diskCacheHintViewButtonEvent(_ key: String) {
        guard key == DTB.DiskCacheModel.key else {
            return DTB.console.error()
        }
        DTB.DiskCacheManager.shared.clearDisks { _ in
            self.view.dtb.toast(DTB.DiskUsageDepends.cleanSuccessText())
            self.reload()
        }
    }
}
