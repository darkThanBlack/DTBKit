//
//  XMAuthManager.swift
//  XMApp
//
//  Created by 徐一丁 on 2021/4/19.
//  Copyright © 2021 jiejing. All rights reserved.
//

import UIKit
import AVFoundation
import CoreBluetooth

/// 申请多个系统权限
public protocol XMAuthManagerDelegate: UIViewController {
    /// 展示 Alert
    func needShowAuthHints(with alert: UIAlertController)
    /// 展示 Toast
    func needShowAuthHints(with toast: String)
}

public extension XMAuthManagerDelegate {
    /// 展示 Alert - 默认实现
    func needShowAuthHints(with alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    /// 展示 Toast - 默认实现
    func needShowAuthHints(with toast: String) {
        view.makeToast(toast)
    }
}

/// 申请多个系统权限
public class XMAuthManager: NSObject {
    
    /// 位置
    public enum LocationAuthStyles {
        case whenInUse, always
    }
    
    public enum AuthType {
        /// 摄像头
        case camera
        /// 麦克风
        case mike
        /// 蓝牙
        case bluetooth
        /// 位置
        case location(style: LocationAuthStyles)
    }
    
    private weak var delegate: XMAuthManagerDelegate?
    
    public init(delegate: XMAuthManagerDelegate? = nil) {
        self.delegate = delegate
        
        super.init()
    }
    
    public func bind(delegate: XMAuthManagerDelegate?) {
        self.delegate = delegate
    }
    
    /// 开始申请系统权限
    /// - Parameters:
    ///   - types: 按顺序调起权限
    ///   - allCompleted: success == true 表示所有权限均已开启
    public func startAuthorizations(with types: [AuthType], allCompleted: ((_ success: Bool)->())?) {
        getAuthorization(with: types, index: 0, allCompleted: { (success) in
            DispatchQueue.main.async {
                allCompleted?(success)
            }
        })
    }
    /// 递归，依次处理需要申请的权限
    private func getAuthorization(with types: [AuthType], index: Int, allCompleted: ((_ success: Bool)->())?) {
        if index < types.count {
            let type = types[index]
            
            switch type {
            case .camera:
                getCameraAuthorization(completed: { (success) in
                    if success {
                        self.getAuthorization(with: types, index: index + 1, allCompleted: allCompleted)
                    } else {
                        allCompleted?(false)
                    }
                })
            case .mike:
                getMikeAuthorization(completed: { (success) in
                    if success {
                        self.getAuthorization(with: types, index: index + 1, allCompleted: allCompleted)
                    } else {
                        allCompleted?(false)
                    }
                })
            case .bluetooth:
                getBluetoothAuthorization(completed: { (success) in
                    if success {
                        self.getAuthorization(with: types, index: index + 1, allCompleted: allCompleted)
                    } else {
                        allCompleted?(false)
                    }
                })
            case .location(let style: LocationAuthStyles):
                switch style {
                case.whenInUse:
                    break
                case .always:
                    break
                }
            }
        } else {
            allCompleted?(true)
        }
    }
    
    private func openSysSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                if success == false {
                    self.delegate?.needShowAuthHints(with: "自动跳转失败，请手动前往 iPhone 的 “设置 - 隐私” 页面")
                }
            }
        }
    }
    
    private func getCameraAuthorization(completed: ((_ success: Bool)->())?) {
        let videoAuthorStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch videoAuthorStatus {
        case .authorized:
            completed?(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (success) in
                completed?(success)
            })
        case .denied, .restricted:
            let alert = UIAlertController(title: "提示", message: "您已经关闭了本应用的相机权限，相关功能可能无法正常使用，是否需要现在去开启？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "去设置", style: .default, handler: { (_) in
                self.openSysSetting()
            }))
            delegate?.needShowAuthHints(with: alert)
            completed?(false)
        @unknown default:
            break
        }
    }
    
    private func getMikeAuthorization(completed: ((_ success: Bool)->())?) {
        let videoAuthorStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        switch videoAuthorStatus {
        case .authorized:
            completed?(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (success) in
                completed?(success)
            })
        case .denied, .restricted:
            let alert = UIAlertController(title: "提示", message: "您已经关闭了本应用的麦克风权限，相关功能可能无法正常使用，是否需要现在去开启？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "去设置", style: .default, handler: { (_) in
                self.openSysSetting()
            }))
            delegate?.needShowAuthHints(with: alert)
            completed?(false)
        @unknown default:
            break
        }
    }
    
    //MARK: - 蓝牙连接对象销毁？
    
    @objc(XMAuthManagerBluetoothProcessor)
    class BluetoothProcessor: NSObject, CBCentralManagerDelegate {
        
        var didUpdateStateHandler: ((CBManagerState)->())?
        
        func centralManagerDidUpdateState(_ central: CBCentralManager) {
            didUpdateStateHandler?(central.state)
        }
    }
    
    private var btManager: CBCentralManager?
    
    private var btProcessor: BluetoothProcessor?
    
    private func getBluetoothAuthorization(completed: ((_ success: Bool)->())?) {
        let processor = BluetoothProcessor()
        processor.didUpdateStateHandler = { [weak self] state in
            defer {
                self?.btProcessor = nil
                self?.btManager = nil
            }
            switch state {
            case .poweredOn:
                completed?(true)
            case .unauthorized:
                let alert = UIAlertController(title: "提示", message: "您已经关闭了蓝牙或本应用的蓝牙权限，相关功能可能无法正常使用，是否需要现在去开启？", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "去设置", style: .default, handler: { (_) in
                    self?.openSysSetting()
                }))
                self?.delegate?.needShowAuthHints(with: alert)
                completed?(false)
            case .poweredOff:
                completed?(false)
            case .unsupported:
                self?.delegate?.needShowAuthHints(with: "当前设备不支持蓝牙")
                completed?(false)
            case .resetting, .unknown:
                self?.delegate?.needShowAuthHints(with: "蓝牙权限未知错误")
                completed?(false)
            @unknown default:
                self?.delegate?.needShowAuthHints(with: "蓝牙权限未知错误")
                completed?(false)
            }
        }
        
        let manager = CBCentralManager(
            delegate: processor,
            queue: nil,
            options: [
                //蓝牙power没打开时alert提示框 iOS11设置页里关闭才会弹
                CBCentralManagerOptionShowPowerAlertKey: true
//                CBCentralManagerOptionRestoreIdentifierKey: "XMAuthManagerBluetoothManagerKey"
            ]
        )
        
        self.btProcessor = processor
        self.btManager = manager
    }
    
    ///
    private func getLocationAuthorization(style: LocationAuthStyles, completed: ((_ success: Bool)->())?) {
        let manager = CLLocationManager()
        let state = manager.authorizationStatus
//        switch state {
//        case .notDetermined:
//            switch style {
//            case .whenInUse:
//                break
//            case .always:
//                break
//            }
//        case .restricted:
//            <#code#>
//        case .denied:
//            <#code#>
//        case .authorizedAlways:
//            <#code#>
//        case .authorizedWhenInUse:
//            <#code#>
//        case .authorized:
//            <#code#>
//        }
    }
    
}
