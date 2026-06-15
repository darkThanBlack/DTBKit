//
//  VerifySliderViewController.swift
//  XMSport
//
//  Created by moonShadow on 2024/2/18
//  Copyright © 2024 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//




/// 滑块验证
class VerifySliderViewController: UIViewController {
    
    /// 回调
    var sliderHandler: ((JSBridgeSlider?)->())?
    
    private let transHandler = AlertAnimationHandler(type: .center)
    
    //MARK: Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalPresentationStyle = .custom
        transitioningDelegate = transHandler
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("VerifySliderViewController deinit...")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews(in: view)
        
        defJSBridge = DTB.JSBridgeHandler(inject: nil, view: self.webView)
        JSBridgeSlider.setupNativeCallBack({ data in
            self.sliderHandler?(data)
            self.dtb.popAnyway()
        })
        defJSBridge?.register(receive: JSBridgeSlider())
        
        // FIXME: url
        webView.loadURL("")
        //        DTB.network.getWebUrl(.slider).done { url in
        //            self.webView.loadURL(url)
        //        }
    }
    
    ///
    private var defJSBridge: DTB.JSBridgeHandler? = nil
    
    //MARK: Event
    
    @objc private func refreshButtonEvent() {
        webView.reload()
    }
    
    @objc private func closeButtonEvent() {
        UIViewController.dtb.popAnyway()
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(webContainer)
        box.addSubview(refreshButton)
        box.addSubview(closeButton)
        
        webContainer.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(box)
            make.width.equalTo(324.0.dtb.hf())
            make.height.equalTo(200.0.dtb.hf())
        }
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(webContainer.snp.top).offset(12.0)
            make.right.equalTo(webContainer.snp.right).offset(-12.0)
            make.width.height.equalTo(22.0)
        }
        refreshButton.snp.makeConstraints { make in
            make.centerY.equalTo(closeButton.snp.centerY)
            make.right.equalTo(closeButton.snp.left).offset(-12.0)
            make.width.height.equalTo(22.0)
        }
        
        webContainer.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 12.0 + 26.0, left: 16.0, bottom: 12.0, right: 16.0))
        }
    }
    
    private lazy var refreshButton = {
        let button = DTB.Button()
        button.setImage(.dtb.local("arrow.clockwise"))
        button.setImageSize(CGSize(width: 18.0, height: 18.0))
        button.setTintColor(.dtb.create("text2"))
        button.addTarget(self, action: #selector(refreshButtonEvent), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton = {
        let button = DTB.Button()
        button.setImage(.dtb.local("xmark"))
        button.setImageSize(CGSize(width: 18.0, height: 18.0))
        button.setTintColor(.dtb.create("text2"))
        button.addTarget(self, action: #selector(closeButtonEvent), for: .touchUpInside)
        return button
    }()
    
    private lazy var webContainer = {
        let view = DTB.ShapeView()
        view.updateUI(
            DTB.ShapeStyle(
                corners: .allCorners,
                radius: .fixed(12.0),
                fillColor: .dtb.create("bg2")
            )
        )
        return view
    }()
    
    private lazy var webView = {
        let view = DTB.WebView.default()
        return view
    }()
}

