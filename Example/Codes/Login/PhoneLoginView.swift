//
//  PhoneLoginView.swift
//  XMSport
//
//  Created by moonShadow on 2024/1/20
//  Copyright © 2024 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import SnapKit


protocol PhoneLoginViewDelegate: DTB.LinkTextViewDelegate {
    
    /// 隐私政策
    func policyButtonEvent()
    
    /// 发送
    func sendButtonEvent()
    
    /// 虚拟登录
    func virtualCodeEvent()
}

/// 验证码登录 - 输入手机号
class PhoneLoginView: UIView {
    
    weak var delegate: PhoneLoginViewDelegate? {
        didSet {
            policyTexts.tapDelegate = delegate
        }
    }
    
    func getPhone() -> String? {
        return phoneField.text
    }
    
    /// 隐私政策是否已选中
    var isPolicySelected: Bool = false {
        didSet {
            policyButton.setImage(.dtb.local(isPolicySelected ? "checkmark.square" : "square"))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func policyButtonEvent() {
        delegate?.policyButtonEvent()
    }
    
    @objc private func sendButtonEvent() {
        delegate?.sendButtonEvent()
    }
    
    @objc private func titleLabelEvent(gesture: UITapGestureRecognizer) {
        delegate?.virtualCodeEvent()
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        [
            titleStack, fieldContainer, policyButton, policyTexts, sendButton
        ].forEach { item in
            box.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        fieldContainer.addSubview(fieldStack)
        fieldStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.dtb.create(horizontal: 12.0))
        }
        
        titleStack.arrangedSubviews.forEach { view in
            view.snp.makeConstraints { make in
                make.width.equalTo(titleStack)
            }
        }
        
        titleStack.snp.makeConstraints { make in
            make.top.equalTo(box)
            make.left.equalTo(box.snp.left).offset(16.0)
            make.right.equalTo(box.snp.right).offset(-16.0)
        }
        
        fieldContainer.snp.makeConstraints { make in
            make.top.equalTo(titleStack.snp.bottom).offset(24.0)
            make.left.equalTo(box.snp.left).offset(16.0)
            make.right.equalTo(box.snp.right).offset(-16.0)
            make.height.equalTo(54.0)
        }
        policyButton.snp.makeConstraints { make in
            make.top.equalTo(fieldContainer.snp.bottom).offset(24)
            make.left.equalTo(box.snp.left).offset(0)
            make.width.height.equalTo(32.0)
        }
        policyTexts.snp.makeConstraints { make in
            make.centerY.equalTo(policyButton.snp.centerY)
            make.left.equalTo(policyButton.snp.right).offset(4.0)
            make.right.lessThanOrEqualTo(box.snp.right).offset(-16.0)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(policyTexts.snp.bottom).offset(8.0)
            make.left.equalTo(box.snp.left).offset(16.0)
            make.right.equalTo(box.snp.right).offset(-16.0)
            make.bottom.equalTo(box)
        }
        fieldLeftImageView.snp.makeConstraints { make in
            make.width.height.equalTo(22.0)
        }
    }
    
    private lazy var titleLabel = UILabel().dtb
        .textStyle("h1")
        .text(.dtb.create("login.sms"))
        .isUserInteractionEnabled(true)
        .addGestureRecognizer({
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(titleLabelEvent(gesture:)))
            singleTap.numberOfTapsRequired = 5
            singleTap.numberOfTouchesRequired = 1
            return singleTap
        }())
        .value
    
    private lazy var descLabel = UILabel().dtb
        .textStyle("ph")
        .text(.dtb.create("login.sms.desc"))
        .value
    
    private lazy var titleStack = UIStackView(arrangedSubviews: [titleLabel, descLabel]).dtb
        .axis(.vertical)
        .alignment(.leading)
        .distribution(.equalSpacing)
        .spacing(4.0)
        .value
    
    private lazy var fieldLeftImageView = UIImageView().dtb
        .image(.dtb.local("login_phone"))
        .contentMode(.scaleAspectFit)
        .value
    
    private lazy var phoneField: UITextField = {
        let field = UITextField()
        field.font = .dtb.create(19.0, weight: .bold)
        field.textColor = .dtb.create("text")
        field.backgroundColor = .dtb.create("bg2")
        field.attributedPlaceholder = .init(
            string: .dtb.create("login.sms.placeholder.phone"),
            attributes: .dtb.create.font(.dtb.create(15.0))
                .foregroundColor(.dtb.create("text_disabled"))
                .value
        )
        field.delegate = self
        field.borderStyle = .none
        field.keyboardType = .default
        field.clearButtonMode = .whileEditing
        
        field.addTarget(self, action: #selector(phoneTextChangedEvent(_:)), for: .editingChanged)
        
        field.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return field
    }()
    
    private lazy var fieldContainer = {
        let view = DTB.ShapeView()
        view.updateUI(
            DTB.ShapeStyle(
                corners: .allCorners,
                radius: .fixed(8.0),
                fillColor: .dtb.create("bg2")
            )
        )
        return view
    }()
    
    private lazy var fieldStack = UIStackView(arrangedSubviews: [fieldLeftImageView, phoneField]).dtb
        .axis(.horizontal)
        .alignment(.center)
        .distribution(.fill)
        .spacing(14.0)
        .value
    
    private lazy var policyButton = {
        let button = DTB.Button()
        button.setImageDirection(.left)
        button.setContentEdgeInsets(.init(top: 8.0, left: 16.0, bottom: 8.0, right: 0.0))
        button.setTintColor(.dtb.create("danger"))
        button.setImage(.dtb.local("square"))
        button.addTarget(self, action: #selector(policyButtonEvent), for: .touchUpInside)
        return button
    }()
    
    private lazy var policyTexts = {
        let view = DTB.LinkTextView()
        view.text = .dtb.create(format: "login.policy.hint", .dtb.create("login.policy.hint.p0"), .dtb.create("login.policy.hint.p1"))
        view.multiLinks = [
            "login.policy.hint.p0": .dtb.create("login.policy.hint.p0"),
            "login.policy.hint.p1": .dtb.create("login.policy.hint.p1")
        ]
        view.linkConfigsFinished()
        return view
    }()
    
    private lazy var sendButton = {
        let button = DTB.Button()
        button.setConfig(.dtb.create("large01"))
        button.setTitle(.dtb.create("login.sms.send"), for: .normal)
//        button.titleLabel?.dtb.textStyle("h1")
        button.addTarget(self, action: #selector(sendButtonEvent), for: .touchUpInside)
        return button
    }()
}

extension PhoneLoginView: UITextFieldDelegate {
    
    @objc private func phoneTextChangedEvent(_ sender: UITextField) {
        // FIXME: limit
        // let _ = sender.limitTextLength(11)  // 位数限制
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

