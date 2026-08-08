//
//  UserManager.swift
//  Ring
//
//  Created by moonShadow on 2026/6/13
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

import ObjectMapper
import RPC_Journey

public class UserVM: Mappable {
    
    var rawUser: AdminLoginResultVO?
    
    public required init?(map: Map) {
    }
    
    public convenience init?(rawUser: AdminLoginResultVO? = nil) {
        self.init(JSON: [String: Any]())
        self.rawUser = rawUser
    }
    
    public func mapping(map: Map) {
        rawUser <- map["rawUser"]
    }
}

public class UserManager {
    
    public static let loginStateChangedKey = Notification.Name(rawValue: "ring.login.StateChange")
    
    private let localKey = DTB.ConstKey<[String: Any]>("ring.user")
    
    public static let shared = UserManager()
    public init() {
        if let json = UserDefaults.dtb.read(localKey) {
            vm = UserVM(JSON: json)
        }
    }
    
    private var vm: UserVM? = nil
    
    var isLogined: Bool { vm == nil }
    
    func login(_ ctx: LoginContext) {
        vm = UserVM(rawUser: ctx.user)
        UserDefaults.dtb.write(vm?.toJSON(), key: localKey)
        NotificationCenter.default.post(name: UserManager.loginStateChangedKey, object: nil)
    }
    
    func logout() {
        vm = nil
        UserDefaults.dtb.write(nil, key: localKey)
        NotificationCenter.default.post(name: UserManager.loginStateChangedKey, object: nil)
    }
}
