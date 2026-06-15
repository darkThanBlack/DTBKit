//
//  LoginViewController.swift
//  XMSport
//
//  Created by moonShadow on 2024/1/10
//  Copyright © 2024 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//




import Moya
import RxSwift
import PromiseKit

import Kingfisher

/// 手机号登录
class LoginViewController: DTB.BaseViewController {
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews(in: view)
    }
    
    @objc private func viewEvent(gesture: UITapGestureRecognizer) {
        resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(backgroundImageView)
        box.addSubview(contentView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(box)
            make.height.equalTo(backgroundImageView.snp.width)
        }
        contentView.snp.makeConstraints { make in
            make.top.equalTo(box.safeAreaLayoutGuide.snp.top).offset(CGFloat(86.0).dtb.hf())
            make.left.right.equalTo(box)
        }
    }
    
    private lazy var backgroundImageView = UIImageView().dtb
        .image(UIImage(named: "background01"))
        .contentMode(.scaleToFill)
        .value
    
    private lazy var contentView = {
        let view = PhoneLoginView()
        view.delegate = self
        return view
    }()
}

extension LoginViewController: PhoneLoginViewDelegate {
    
    /// 隐私政策文本跳转
    func linkTextView(_ view: DTB.LinkTextView, shouldInteract linkKey: String) {
        print("linkTextView taped, key=\(linkKey)")
        
//        firstly {
//            switch linkKey {
//            case "login.policy.hint.p0":
//                return DTB.network.getWebUrl(.serviceAgreement)
//            case "login.policy.hint.p1":
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
    
    /// 隐私政策
    func policyButtonEvent() {
        contentView.isPolicySelected = !contentView.isPolicySelected
    }
    
    private func getPhoneWithCheck() -> String? {
        view.endEditing(true)
        
        guard let phone = contentView.getPhone(), phone.isEmpty == false else {
            self.view.dtb.toast(String.dtb.create("login.sms.placeholder.phone"))
            return nil
        }
        guard phone.dtb.isRegular(.init("^\\d{11}$")) else {
            self.view.dtb.toast(String.dtb.create("login.phone.error"))
            return nil
        }
        
        return phone
    }
    
    /// 发送
    func sendButtonEvent() {
        guard let phone = getPhoneWithCheck() else {
            return
        }
        
        /// 滑块验证
        func showSlider() {
            let sliderVC = VerifySliderViewController()
            sliderVC.sliderHandler = { [weak self] data in
                self?.viewModel.sendSms(to: phone, slider: data).done({ _ in
                    let vc = VerifyCodeViewController(phone: phone)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }).cauterize()
            }
            present(sliderVC, animated: true)
        }
        
        if contentView.isPolicySelected {
            showSlider()
        } else {
            let alert = UIAlertController(title: "温馨提示", message: "在您登录之前，请您阅读完整版的《服务协议》和《隐私政策》，并同意服务协议中的所有条款。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: .dtb.create("common.cancel"), style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: .dtb.create("common.ensure"), style: .default, handler: { [weak self] _ in
                self?.contentView.isPolicySelected = true
                showSlider()
            }))
            present(alert, animated: true)
        }
    }
    
    /// 虚拟登录
    func virtualCodeEvent() {
        // do sth.
        DTB.console.log("virtualCodeEvent: do nth.")
        UIViewController.dtb.popAnyway()
    }
}
