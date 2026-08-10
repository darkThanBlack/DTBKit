//
//  VerifyCodeView.swift
//
//  Created by moonShadow on 2024/03/22
//  Copyright © 2024 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

/// Simple verify code field.
///
/// forked: https://github.com/darkThanBlack/MHVerifyCodeView/
/// refer: https://github.com/feaskters/MHVerifyCodeView/blob/master/MHVerifyCodeView/
public class MHVerifyCodeView: UIView, UITextFieldDelegate {
    
    // MARK: Interface
    
    ///
    public var completedHandler: ((_ verifyCode: String) -> Void)?
    
    ///
    public func setupDefItem(count: Int = 4, configer: ((_ label: UILabel) -> Void)? = nil) {
        setupItem(count: count, builder: { _ in
            let label = UILabel()
            label.backgroundColor = .white
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 8.0
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 23, weight: .medium)
            label.textColor = UIColor(red: 61 / 255.0, green: 61 / 255.0, blue: 61 / 255.0, alpha: 1.0)
            configer?(label)
            return label
        })
    }
    
    // MARK: Customable
    
    ///
    public func setupItem(count: Int, builder: ((_ index: Int) -> UIView)?) {
        stacks.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        let arranges = (0..<count).compactMap({ builder?($0) })
        arranges.forEach { item in
            stacks.addArrangedSubview(item)
            [item].forEach({
                $0.translatesAutoresizingMaskIntoConstraints = false
            })
            NSLayoutConstraint.activate([
                item.widthAnchor.constraint(equalTo: stacks.heightAnchor, constant: 0.0),
                item.heightAnchor.constraint(equalTo: stacks.heightAnchor, constant: 0.0)
            ])
        }
    }
    
    ///
    public lazy var field: UITextField = {
        let textfield = UITextField()
        textfield.isHidden = true
        textfield.keyboardType = .numberPad
        if #available(iOS 12.0, *) {
            textfield.textContentType = .oneTimeCode
        }
        textfield.delegate = self
        return textfield
    }()
    
    ///
    public lazy var stacks: UIStackView = {
        let stacks = UIStackView()
        stacks.axis = .horizontal
        stacks.alignment = .center
        stacks.distribution = .equalSpacing
        return stacks
    }()
    
    ///
    private var items: [UILabel] {
        return stacks.arrangedSubviews.compactMap({ $0 as? UILabel })
    }
    
    //MARK: Life Cycle
    
    ///
    public convenience init(count: Int = 4, completed: ((_ verifyCode: String) -> Void)?) {
        self.init(frame: .zero)
        
        setupDefItem(count: count)
        completedHandler = completed
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
        
        isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(showFieldEvent(gesture:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        addGestureRecognizer(singleTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        [field, stacks].forEach({
            box.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: box.topAnchor, constant: 0.0),
                $0.leftAnchor.constraint(equalTo: box.leftAnchor, constant: 0.0),
                $0.rightAnchor.constraint(equalTo: box.rightAnchor, constant: 0.0),
                $0.bottomAnchor.constraint(equalTo: box.bottomAnchor, constant: 0.0),
            ])
        })
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        guard text.count <= items.count else {
            textField.text = String(text.prefix(items.count))
            return
        }
        
        items.forEach({ $0.text = "" })
        for (index, char) in text.enumerated() {
            items[index].text = String(char)
        }
        
        if (text.count == items.count) {
            endEditing(true)
            completedHandler?(text)
        }
    }
    
    @objc private func showFieldEvent(gesture: UITapGestureRecognizer) {
        field.becomeFirstResponder()
    }
}
