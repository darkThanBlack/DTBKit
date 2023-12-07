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
import CoreLocation

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
        // view.makeToast(toast)
    }
}

/// 简单申请多个系统权限
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
        case location(_ style: XMAuthManager.LocationAuthStyles)
    }
    
    private weak var delegate: XMAuthManagerDelegate?
    
    /// 内存管理 - 蓝牙
    private var bltHandler: BluetoothHandler? = nil
    
    /// 内存管理 - 定位
    private var locHandler: LocationHandler? = nil
    
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
        guard index < types.count else {
            allCompleted?(true)
            return
        }
        
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
        case .location(let style):
            getLocationAuthorization(style: style, completed: { (success) in
                if success {
                    self.getAuthorization(with: types, index: index + 1, allCompleted: allCompleted)
                } else {
                    allCompleted?(false)
                }
            })
        }
    }
    
    /// 打开系统设置
    private func openSysSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                if success == false {
                    self.delegate?.needShowAuthHints(with: "自动跳转失败，请手动前往 iPhone 的 “设置 - 隐私” 页面")
                }
            }
        }
    }
    
    ///
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
    
    ///
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
    
    ///
    private func getBluetoothAuthorization(completed: ((_ success: Bool)->())?) {
        let handler = BluetoothHandler()
        self.bltHandler = handler
        handler.didUpdateHandler = { [weak self] state in
            defer {
                self?.bltHandler = nil
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
    }
    
    ///
    private func getLocationAuthorization(style: LocationAuthStyles, completed: ((_ success: Bool)->())?) {
        let handler = LocationHandler()
        print("MOON__Log  handler.getStatus=\(handler.getStatus.rawValue)")
        switch handler.getStatus {
        case .notDetermined:
            switch style {
            case .whenInUse:
                handler.requestWhenInUse()
            case .always:
                handler.requestAlways()
            }
            
            self.locHandler = handler
            handler.didUpdateHandler = { [weak self] status in
                print("MOON__Log  didUpdateHandler status=\(status.rawValue)")
                defer {
                    self?.locHandler = nil
                }
                switch status {
                case .notDetermined, .restricted, .denied:
                    completed?(false)
                case .authorized, .authorizedWhenInUse, .authorizedAlways:
                    completed?(true)
                @unknown default:
                    completed?(false)
                }
            }
        case .restricted, .denied:
            let alert = UIAlertController(title: "提示", message: "您已经关闭了本应用的定位权限，相关功能可能无法正常使用，是否需要现在去开启？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "去设置", style: .default, handler: { (_) in
                self.openSysSetting()
            }))
            self.delegate?.needShowAuthHints(with: alert)
            completed?(false)
        case .authorized, .authorizedWhenInUse, .authorizedAlways:
            completed?(true)
        @unknown default:
            completed?(false)
        }
    }
}

// MARK: - Handlers

extension XMAuthManager {
    
    /// 蓝牙
    @objc(XMAuthManagerBluetoothHandler)
    class BluetoothHandler: NSObject, CBCentralManagerDelegate {
        
        var didUpdateHandler: ((CBManagerState)->())?
        
        private lazy var manager: CBCentralManager = {
            return CBCentralManager(
                delegate: self,
                queue: nil,
                options: [
                    CBCentralManagerOptionShowPowerAlertKey: true
                ]
            )
        }()
        
        func centralManagerDidUpdateState(_ central: CBCentralManager) {
            didUpdateHandler?(central.state)
        }
    }
    
    /// 定位
    @objc(XMAuthManagerLocationHandler)
    class LocationHandler: NSObject, CLLocationManagerDelegate {
        
        var getStatus: CLAuthorizationStatus {
            if #available(iOS 14.0, *) {
                return manager.authorizationStatus
            } else {
                return CLLocationManager.authorizationStatus()
            }
        }
        
        func requestWhenInUse() {
            manager.requestWhenInUseAuthorization()
        }
        
        func requestAlways() {
            manager.requestAlwaysAuthorization()
        }
        
        var didUpdateHandler: ((CLAuthorizationStatus)->())?
        
        private lazy var manager: CLLocationManager = {
            let manager = CLLocationManager()
            manager.delegate = self
            return manager
        }()
        
        @available(iOS, introduced: 4.2, deprecated: 14.0)
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            print("MOON__LOG  < iOS 14.0, didChangeAuthorization, status=\(status.rawValue)")
            didUpdateHandler?(status)
        }
        
        @available(iOS 14.0, *)
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            print("MOON__LOG  > iOS 14.0, locationManagerDidChangeAuthorization, status=\(manager.authorizationStatus.rawValue)")
            didUpdateHandler?(manager.authorizationStatus)
        }
    }
}
