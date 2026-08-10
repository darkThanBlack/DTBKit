//
//  LoginViewModel.swift
//  XMSport
//
//  Created by moonShadow on 2024/2/7
//  Copyright © 2024 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//




import Moya

import RPC_Common
import RPC_Journey

/// 持有整个登录过程
class LoginContext {
    
    var phone: String?
    
    var verifyCode: String?
    
    var user: AdminLoginResultVO?
    
    init(phone: String? = nil, verifyCode: String? = nil, user: AdminLoginResultVO? = nil) {
        self.phone = phone
        self.verifyCode = verifyCode
        self.user = user
    }
}

class LoginViewModel: DTB.BaseViewModel {
    
    /// 发送验证码
    ///
    /// - Parameters:
    ///   - phone: 手机号
    ///   - slider: 滑块验证携参
    /// - Returns: error message, nil 表示成功
    func sendSms(to phone: String, slider: JSBridgeSlider?) -> Promise<String> {
        let params = SendVerifyCodeRequest(
            phone: phone,
            serverType: "MOCK",
        )
        let request = SmsService.sendVerifyCode(request: params)
        return moya.requestPromise(MultiTarget(request)).map({ result in
            DTB.console.log("sendVerifyCode, result=\(result)")
            return (result as? String) ?? ""
        })
    }
    
    func doLoginWithVerifyCode(_ ctx: LoginContext) -> Promise<LoginContext> {
        let request = AdminLoginService.loginForApp(
            request: AdminLoginRequest(
                accountNo: ctx.phone,
                certificate: ctx.verifyCode,
                loginType: LoginTypeEnum.SMS
            )
        )
        return moya.requestPromiseObject(MultiTarget(request), type: AdminLoginResultVO.self)
            .map { result in
                guard let userId = ctx.user?.userId else {
                    throw NSError.dtb.empty("userId")
                }
                ctx.user = result
                return ctx
            }
    }
}
