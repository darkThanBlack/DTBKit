//
//  GuideAlertController.swift
//  XMBundleLN
//
//  Created by moonShadow on 2023/8/14
//  Copyright © 2023 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// 新手引导 - 刷新弹窗
class GuideRefreshAlertController: UIViewController {
    
    private let animateHandler = AlertAnimationHandler(type: .center)
    
    private var titles: [String] = []
    
    var completedHandler: (()->())?
    
    @objc private func doneButtonEvent(button: UIButton) {
        dismiss(animated: true)
//        guard titles.isEmpty == false else {
//            return
//        }
        completedHandler?()
    }
    
    init(titles: [String]) {
        self.titles = titles
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = animateHandler
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView(frame: .zero)
        view.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(240.0)  //* ScreenRatio
            make.height.lessThanOrEqualToSuperview()
        }
        
        loadViews(in: contentView)
        
        reloadData()
    }
    
    private func reloadData() {
        titleLabel.text = titles.isEmpty ? "刷新成功，暂时没有新的任务完成" : "恭喜你，成功完成了以下任务"
        doneButton.setTitle(titles.isEmpty ? "去完成任务" : "继续完成任务", for: .normal)
        
        tableView.snp.updateConstraints { make in
            make.height.equalTo(titles.isEmpty ? 0.0 : 150.0)
        }
        tableView.reloadData()
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(bgImageView)
        box.addSubview(successImageView)
        box.addSubview(titleLabel)
        box.addSubview(tableView)
        box.addSubview(doneButton)
        
        bgImageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(box)
            make.height.equalTo(bgImageView.snp.width).multipliedBy(480.0/540.0)
            make.bottom.lessThanOrEqualTo(box.snp.bottom).offset(-8.0)
        }
        successImageView.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.top.equalTo(box.snp.top).offset(40.0)
            make.width.height.equalTo(60.0)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(successImageView.snp.bottom).offset(16.0)
            make.left.equalTo(box.snp.left).offset(24.0)
            make.right.equalTo(box.snp.right).offset(-24.0)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32.0)
            make.left.equalTo(box.snp.left).offset(24.0)
            make.right.equalTo(box.snp.right).offset(-24.0)
            make.height.equalTo(150.0)
        }
        doneButton.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.top.equalTo(tableView.snp.bottom).offset(32.0)
            make.bottom.equalTo(box.snp.bottom).offset(-24.0)
            make.width.equalTo(110.0)
            make.height.equalTo(30.0)
        }
    }
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 5.0
        return contentView
    }()
    
    private lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView(image: UIImage(named: "guide_alert_bg"))
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    private lazy var successImageView: UIImageView = {
        let successImageView = UIImageView(image: UIImage(named: "guide_success_big"))
        successImageView.contentMode = .scaleAspectFit
        return successImageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        titleLabel.textColor = DriftAdapter.color_333333()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44.0
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.register(GuideRefreshAlertCell.self, forCellReuseIdentifier: String(describing: GuideRefreshAlertCell.self))
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .custom)
        doneButton.layer.cornerRadius = 4.0
        doneButton.layer.masksToBounds = true
        doneButton.backgroundColor = DriftAdapter.color_FFAB1A()
        doneButton.setTitle("去完成任务", for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .highlighted)
        doneButton.addTarget(self, action: #selector(doneButtonEvent(button:)), for: .touchUpInside)
        return doneButton
    }()
}

extension GuideRefreshAlertController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // do nth.
    }
}

extension GuideRefreshAlertController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GuideRefreshAlertCell.self)) as? GuideRefreshAlertCell else {
            return UITableViewCell()
        }
        if indexPath.row < titles.count {
            cell.title = titles[indexPath.row]
        }
        return cell
    }
}

///
class GuideRefreshAlertCell: UITableViewCell {
    
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        loadViews(in: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadViews(in box: UIView) {
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        box.addSubview(hintImageView)
        box.addSubview(titleLabel)
        
        hintImageView.snp.makeConstraints { make in
            make.top.equalTo(box.snp.top).offset(4.0)
            make.left.equalTo(box.snp.left).offset(0)
            make.bottom.equalTo(box.snp.bottom).offset(-4.0)
            make.width.height.equalTo(18.0)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(hintImageView.snp.centerY)
            make.left.equalTo(hintImageView.snp.right).offset(4.0)
            make.right.equalTo(box.snp.right).offset(-8.0)
        }
    }
    
    private lazy var hintImageView: UIImageView = {
        let hintImageView = UIImageView(image: UIImage(named: "guide_success"))
        hintImageView.contentMode = .scaleAspectFill
        return hintImageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        titleLabel.textColor = DriftAdapter.color_999999()
        return titleLabel
    }()
}

