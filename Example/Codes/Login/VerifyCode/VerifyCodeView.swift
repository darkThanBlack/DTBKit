//
//  VerifyCodeView.swift
//  XMSport
//
//  Created by moonShadow on 2024/1/22
//  Copyright © 2024 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//




protocol VerifyCodeViewDelegate: AnyObject {
    
    /// 超时重新发送
    func resendEvent()
    
    /// 验证码输入完成
    func entryCompletedEvent(_ code: String)
}

///
class VerifyCodeView: UIView {
    
    weak var delegate: VerifyCodeViewDelegate?
    
    ///
    func setPhone(_ value: String) {
        descLabel.dtb.text(.dtb.create("login.sms.enter.desc") + value)
    }
    
    enum CounterStyles {
        /// 倒数计时
        case counting(value: Int)
        /// 重新发送
        case resend
    }
    
    func setCounter(_ style: CounterStyles) {
        switch style {
        case .counting(let value):
            countLabel.dtb
                .isUserInteractionEnabled(false)
                .textColor(.dtb.create("text2"))
                .text("\(value)s后重新获取")
        case .resend:
            countLabel.dtb
                .isUserInteractionEnabled(true)
                .textColor(.dtb.create("danger"))
                .text("获取验证码")
        }
    }
    
    private func shouldSendCode(_ code: String) {
        delegate?.entryCompletedEvent(code)
    }
    
    @objc private func resendEvent(gesture: UITapGestureRecognizer) {
        delegate?.resendEvent()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(titleStack)
        box.addSubview(mhField)
        box.addSubview(countLabel)
        
        titleStack.arrangedSubviews.forEach { view in
            view.snp.makeConstraints { make in
                make.width.equalTo(titleStack)
            }
        }
        titleStack.snp.makeConstraints { make in
            make.top.left.right.equalTo(box)
        }
        mhField.snp.makeConstraints { make in
            make.top.equalTo(titleStack.snp.bottom).offset(20)
            make.left.right.equalTo(box)
            
            make.height.equalTo(64.0)
        }
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(mhField.snp.bottom).offset(16.0)
            make.right.bottom.equalTo(box)
        }
    }
    
    private lazy var titleLabel = UILabel().dtb
        .textStyle("h1")
        .text(.dtb.create("login.sms.enter"))
        .value
    
    private lazy var descLabel = UILabel().dtb.textStyle("ph").value
    
    private lazy var titleStack = UIStackView(arrangedSubviews: [titleLabel, descLabel]).dtb
        .axis(.vertical)
        .alignment(.leading)
        .distribution(.equalSpacing)
        .spacing(4.0)
        .value
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = .dtb.create("text_disabled")
        label.textAlignment = .right
        
        label.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(resendEvent(gesture:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        label.addGestureRecognizer(singleTap)
        
        return label
    }()
    
    private lazy var mhField: MHVerifyCodeView = {
        let field = MHVerifyCodeView { [weak self] code in
            self?.shouldSendCode(code)
        }
        return field
    }()
    
}
