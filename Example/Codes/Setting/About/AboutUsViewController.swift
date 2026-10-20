//
//  AboutUsViewController.swift
//  XMSport
//
//  Created by moonShadow on 2024/2/18
//  Copyright © 2024 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

/// 关于我们
class AboutUsViewController: DTB.BaseViewController {
    
    private let items: [ArrowRow.Item] = [
        ArrowRow.Item(key: "dtb.app.update", title: .dtb.create("dtb.app.update")),
        ArrowRow.Item(key: "dtb.policy.ts", title: .dtb.create("dtb.policy.ts")),
        ArrowRow.Item(key: "dtb.policy.pp", title: .dtb.create("dtb.policy.pp")),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigatonBar(with: .init(title: .dtb.create("dtb.setting.about")))
        loadViews(in: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.update(items: items)
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(0)
            make.left.right.bottom.equalTo(box.safeAreaLayoutGuide)
        }
    }
    
    private lazy var contentView: AboutUsView = {
        let view = AboutUsView()
        view.delegate = self
        return view
    }()
}

extension AboutUsViewController: AboutUsViewDelegate {
    
    func listItemEvent(_ index: Int) {
        guard let item = items.dtb[index] else { return }
        
        switch item.key {
        case "dtb.app.update":
            // XMVersions.shared.showUserCheckUpdateAlert()
            break
        case "dtb.policy.ts":
            break
        case "dtb.policy.pp":
            break
        default:
            DTB.console.error(item.key)
        }
        
        // TODO: link
        
        //        firstly {
        //            switch primaryKey {
        //            case "policy.ts":
        //                return DTB.network.getWebUrl(.serviceAgreement)
        //            case "policy.pp":
        //                return DTB.network.getWebUrl(.privacyPolicy)
        //            default:
        //                return Guarantee.value("")
        //            }
        //        }.done { url in
        //            guard url.isEmpty == false else { return }
        //
        //            let webVC = SportWebViewController()
        //            let config = WebViewConfigs(navigationStyle: .backOnly, autoTitle: true)
        //            webVC.config = config
        //            webVC.loadURL(url)
        //            self.navigationController?.pushViewController(webVC, animated: true)
        //        }
    }
    
}
