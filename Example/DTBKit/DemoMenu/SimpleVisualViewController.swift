//
//  SimpleVisualViewController.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/30
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
class SimpleVisualViewController: UIViewController {
    
    private var navigationable: Bool
    
    private var creator: (()->(UIView?))?
    
    private var framer: ((_ son: UIView, _ father: UIView)->())?
    
    private var layouter: ((_ son: UIView, _ father: UIView)->())?
    
    private weak var son: UIView?
    
    ///
    static func show(
        in creator: (()->(UIView?))?,
        framer: ((_ son: UIView, _ father: UIView)->())? = nil,
        layouter: ((_ son: UIView, _ father: UIView)->())? = nil,
        navigationable: Bool = true
    ) {
        let simpleVC = SimpleVisualViewController(
            navigationable: navigationable,
            creator: creator,
            framer: framer,
            layouter: layouter
        )
        Navigate.topMost()?.navigationController?.pushViewController(simpleVC, animated: true)
    }
    
    init(
        navigationable: Bool,
        creator: (()->(UIView?))? = nil,
        framer: ((_ son: UIView, _ father: UIView)->())?,
        layouter: ((_ son: UIView, _ father: UIView)->())? = nil
    ) {
        self.navigationable = navigationable
        self.creator = creator
        self.layouter = layouter
        self.framer = framer
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        guard framer != nil else {
            return
        }
        
        var topInset = 0.0
        var bottomInset = 0.0
        if #available(iOS 11.0, *) {
            topInset = view.safeAreaInsets.top
            bottomInset = view.safeAreaInsets.bottom
        }
        if navigationable {
            customNavBar.frame = CGRect(x: 0, y: topInset, width: view.bounds.maxX, height: 44.0)
        } else {
            customNavBar.frame = CGRect(x: 0, y: topInset, width: view.bounds.maxX, height: 0.0)
        }
        contentView.frame = CGRect(
            x: 0,
            y: customNavBar.frame.maxY,
            width: view.bounds.maxX,
            height: view.bounds.maxY - customNavBar.frame.maxY - bottomInset
        )
        
        if let son = self.son {
            framer?(son, view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
        
        loadViews(in: view)
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(customNavBar)
        box.addSubview(contentView)
        guard let son = creator?() else {
            return
        }
        self.son = son
        box.addSubview(son)
        loadConstraints(in: box)
    }
    
    private func loadConstraints(in box: UIView) {
        guard layouter != nil else {
            return
        }
        
        [customNavBar, contentView].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        if #available(iOS 11.0, *) {
            customNavBar.topAnchor.constraint(equalTo: box.safeAreaLayoutGuide.topAnchor, constant: 0.0).isActive = true
        } else {
            customNavBar.topAnchor.constraint(equalTo: box.topAnchor, constant: 0.0).isActive = true
        }
        NSLayoutConstraint.activate([
            customNavBar.leftAnchor.constraint(equalTo: box.leftAnchor),
            customNavBar.rightAnchor.constraint(equalTo: box.rightAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 44.0)
        ])
        
        if #available(iOS 11.0, *) {
            contentView.bottomAnchor.constraint(equalTo: box.safeAreaLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
        } else {
            contentView.bottomAnchor.constraint(equalTo: box.bottomAnchor, constant: 0.0).isActive = true
        }
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: box.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: box.rightAnchor),
        ])
        
        if let son = self.son {
            layouter?(son, box)
        }
    }
    
    private lazy var customNavBar: DemoNavigationView = {
        let customNavBar = DemoNavigationView()
        return customNavBar
    }()
    
    private lazy var contentView: DemoContentView = {
        let contentView = DemoContentView()
        return contentView
    }()
}

