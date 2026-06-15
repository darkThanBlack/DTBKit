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
    
    var instAdmin: UserInstAdminVO?
    
    init(phone: String? = nil, verifyCode: String? = nil, user: AdminLoginResultVO? = nil, instAdmin: UserInstAdminVO? = nil) {
        self.phone = phone
        self.verifyCode = verifyCode
        self.user = user
        self.instAdmin = instAdmin
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
            serverType: "B_LOGIN",
        )
        let request = SmsService.sendVerifyCode(request: params)
        return provider.requestPromise(MultiTarget(request)).map({ result in
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
        return provider.requestPromiseObject(MultiTarget(request), type: AdminLoginResultVO.self)
            .map { result in
                guard let userId = ctx.user?.userId else {
                    throw NSError.dtb.empty("userId")
                }
                ctx.user = result
                return ctx
            }
            .then({ self.chainInstAdmin($0) })
            .then({ self.chainSwitchInst($0) })
    }
    
    private func chainInstAdmin(_ ctx: LoginContext) -> Promise<LoginContext> {
        let request = AdminLoginService.getUserInstAdminList(
            request: UserIdRequest(
                state: .VALID,
                userId: ctx.user?.userId
            )
        )
        return provider.requestPromiseArray(MultiTarget(request), type: UserInstAdminVO.self)
            .map { result in
                guard let instAdmin = result.first else {
                    throw NSError.dtb.create("该用户没有机构")
                }
                guard let adminId = instAdmin.id else {
                    throw NSError.dtb.empty("adminId")
                }
                guard let instId = instAdmin.instId else {
                    throw NSError.dtb.empty("instId")
                }
                ctx.instAdmin = instAdmin
                return ctx
            }
    }
    
    private func chainSwitchInst(_ ctx: LoginContext) -> Promise<LoginContext> {
        let request = AdminLoginService.switchInst(
            request: SwitchInstRequest(
                adminId: ctx.instAdmin?.id,
                instId: ctx.instAdmin?.instId
            )
        )
        return provider.requestPromise(MultiTarget(request))
            .map { result in
                DTB.console.log("switchInst, success=\(result)")
                return ctx
            }
    }
}
