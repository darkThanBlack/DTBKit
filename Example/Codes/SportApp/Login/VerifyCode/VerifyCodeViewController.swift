//
//  VerifyCodeViewController.swift
//  XMSport
//
//  Created by moonShadow on 2024/1/22
//  Copyright © 2024 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    



import Moya
import RxSwift

/// 输入验证码
class VerifyCodeViewController: DTB.BaseViewController {
    
    private let viewModel = VerifyCodeViewModel()
    
    private let phone: String
    
    init(phone: String) {
        self.phone = phone
        super.init(nibName: nil, bundle: nil)
        
        resetCount()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews(in: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timerFire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timerInvalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    
    //MARK: - Timer
    
    /// 验证码倒数计时
    private let key = DTB.ConstKey<Int>("MemoryKey.verifyCodeCount")
    
    private var timer: Timer?
    
    private var timeCount: Int {
        get {
            return DTB.app.get(key) ?? 0
        }
        set {
            DTB.app.set(newValue, key: key)
        }
    }
    
    private func resetCount() {
        timeCount = 60
    }
    
    private func timerFire() {
        if timer == nil {
            let t = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeHandler), userInfo: nil, repeats: true)
            t.fire()
            timer = t
        }
    }
    
    private func timerInvalidate() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func timeHandler() {
        timeCount -= 1
        if timeCount < 1 {
            timeCount = 60
            timerInvalidate()
            
            contentView.setCounter(.resend)
        } else {
            contentView.setCounter(.counting(value: timeCount))
        }
    }
    
    @objc private func backButtonEvent(button: UIButton) {
        UIViewController.dtb.popAnyway()
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(backgroundImageView)
        box.addSubview(backButton)
        box.addSubview(contentView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(box)
            make.height.equalTo(backgroundImageView.snp.width)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalTo(box.safeAreaLayoutGuide.snp.top).offset(CGFloat(30.0).dtb.hf())
            make.left.equalTo(box.snp.left).offset(16.0)
        }
        contentView.snp.makeConstraints { make in
            make.top.equalTo(box.safeAreaLayoutGuide.snp.top).offset(CGFloat(86.0).dtb.hf())
            make.left.equalTo(box.snp.left).offset(16.0)
            make.right.equalTo(box.snp.right).offset(-16.0)
        }
    }
    
    private lazy var backgroundImageView = UIImageView().dtb
        .image(UIImage(named: "background01"))
        .contentMode(.scaleToFill)
        .value
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "nav_back"), for: .normal)
        button.setImage(UIImage(named: "nav_back"), for: .highlighted)
        button.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 20.0)
        button.addTarget(self, action: #selector(backButtonEvent(button:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var contentView = {
        let view = VerifyCodeView()
        view.delegate = self
        return view
    }()
    
    /// FIXME: 临时解决系统输入法自动填充时，触发多次回调导致登录失败问题
    private var isRequesting: Bool = false
}

extension VerifyCodeViewController: VerifyCodeViewDelegate {
    
    /// 验证码输入完成
    func entryCompletedEvent(_ code: String) {
        view.resignFirstResponder()
        
        guard isRequesting == false else {
            return
        }
        isRequesting = true
        
        // FIXME: login
        viewModel.doLoginWithVerifyCode(LoginContext(phone: phone, verifyCode: code))
            .done { ctx in
                UserManager.shared.login(ctx)
            }.catch { error in
                if error.localizedDescription.count > 0 {
                    UIView.dtb.toast(error.localizedDescription)
                }
            }.finally {
                self.isRequesting = false
            }
    }
    
    /// 重新发送
    func resendEvent() {
        /// 滑块验证
        let sliderVC = VerifySliderViewController()
        sliderVC.sliderHandler = { [weak self] data in
            self?.viewModel.sendSms(to: self?.phone ?? "", slider: data)
                .done({ message in
                    self?.resetCount()
                    self?.timerFire()
                }).cauterize()
        }
        present(sliderVC, animated: true)
    }
    
}
